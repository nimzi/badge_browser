#import "ServiceFacade.h"
#import "AFNetworking.h"
#import "Badge.h"
#import "FTHTTPCodes.h"

#import <iso646.h>


typedef void (^CompletionHandlerType)(NSURLResponse *response, NSData *data, NSError *connectionError);
typedef void (^CallbackType)(NSArray* operations);
typedef void (^ProgressBlockType)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations);


@interface ServiceFacade()
@property BOOL busy;
@property (strong) typeof(NSOperationQueue*) firstStageQ, secondStageQ;
@property (strong, readonly) NSURL* serviceUrl;
@property (readonly) NSTimeInterval timeoutIntervalForManifest;
@property (readonly) NSTimeInterval timeoutIntervalForDetail;
@property (readonly) NSTimeInterval timeoutIntervalForImages;
@end



@implementation ServiceFacade
@synthesize serviceUrl=_serviceUrl;

+(instancetype) instance {
  static ServiceFacade* shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[self alloc] init];
  });
  return shared;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    // Don't really need pretty... but nice to print to console :)
    id path = @"http://www.khanacademy.org/api/v1/badges?format=pretty";
    _serviceUrl = [[NSURL alloc] initWithString:path];
    
    // Pretty arbitrary but at least explicit
    _timeoutIntervalForDetail = 10;
    _timeoutIntervalForImages = 15;
    _timeoutIntervalForManifest = 7;
    
    
    self.firstStageQ = [NSOperationQueue new];
    self.firstStageQ.maxConcurrentOperationCount = 1;
    
    self.secondStageQ = [NSOperationQueue new];
    self.secondStageQ.maxConcurrentOperationCount = 32;
    
  }
  return self;
}

-(BOOL) isBusy {
  return self.busy;
}

// Can never become busy concurrently from multiple threads
-(BOOL) _becomeBusy {
  @synchronized (self) {
    if (self.busy) {
      return NO;
    } else {
      self.busy = YES;
      return YES;
    }
  }
}


// Can never interfere with _becomeBusy
-(BOOL) _becomeIdle {
  @synchronized (self) {
    if (self.busy) {
      self.busy = NO;
      return YES;
    } else {
      [NSException raise:@"InconsistendState" format:@"Someone asking Service to become Idle when NOT busy"];
      return NO;
    }
  }
}


-(void) _sendDidBecomeIdle {
  __weak typeof(self) weakSelf = self;
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf.delegate serviceFacadeDidBecomeIdle:strongSelf];
  }];
}


-(void) _sendDidBecomeBusy {
  __weak typeof(self) weakSelf = self;
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf.delegate serviceFacadeDidBecomeBusy:strongSelf];
  }];
}

#pragma mark -

-(NSArray*) _operationsForBadge:(BadgeProxy*)entry {
  
  NSMutableArray* ops = [@[] mutableCopy];
  
  
  if (entry.name) {
    NSURL* urlForLarge = entry.largeImageURL ? [NSURL URLWithString:entry.largeImageURL] : nil;
    NSURL* urlForSmall = entry.smallImageURL ? [NSURL URLWithString:entry.smallImageURL] : nil;
    
    __weak typeof(self) weakSelf = self;
    
    if (urlForLarge) {
      NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:urlForLarge];
      AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
      op.responseSerializer = [AFImageResponseSerializer serializer];
      [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"Large image response: %@", responseObject);
        entry.largeImage = UIImagePNGRepresentation(responseObject);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          [strongSelf.delegate serviceFacade:strongSelf
                           didLoadLargeImage:responseObject
                                    forEntry:entry];
        }];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
      }];
      
      [ops addObject:op];
    }
    
    if (urlForSmall) {
      NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:urlForSmall];
      AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
      op.responseSerializer = [AFImageResponseSerializer serializer];
      [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"Small image response: %@", responseObject);
        
        // Very inefficient because extra conversion: NSData -> Image -> NSData
        // but trying to move quickly 
        
        entry.smallImage = UIImagePNGRepresentation(responseObject);    // Should be thread-safe
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          [strongSelf.delegate serviceFacade:strongSelf
                           didLoadSmallImage:responseObject
                                    forEntry:entry];
        }];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
      }];
      
      [ops addObject:op];
    }
  }
  
  
  return ops;
}



-(void) refreshIfNotBusy {
  if ([self _becomeBusy]) {
    [self _sendDidBecomeBusy];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.serviceUrl];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    [request setTimeoutInterval:self.timeoutIntervalForManifest];
    
    // Not strictly necessary to do weak/strong pattern at all since self is a singleton...
    // but making it "pretty"
    __weak typeof(self) weakSelf = self;
    CompletionHandlerType manifestGrabber = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (strongSelf) {
        if (connectionError) {
          [strongSelf _becomeIdle];
          [strongSelf _sendDidBecomeIdle];
        } else {
          NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
          NSInteger responseStatusCode = [httpResponse statusCode];
          
          if (responseStatusCode != HTTPCode200OK) {
            //Just to make sure, it works or not
            NSLog(@"WARNING: Status code = %ld", (long)responseStatusCode);
            NSLog(@"%@", [FTHTTPCodes descriptionForCode:responseStatusCode]);
            [strongSelf _becomeIdle];
            [strongSelf _sendDidBecomeIdle];
          } else {
            NSError* parsingError = nil;
            NSArray* json = (nil == data) ? nil : [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:0
                                                                                    error:&parsingError];
            
            if (parsingError or json == nil or not [json isKindOfClass:[NSArray class]]) {
              NSLog(@"WARNING: Inconsistend format");
              [strongSelf _becomeIdle];
              [strongSelf _sendDidBecomeIdle];
            } else {
              if (not (json.count > 0)) {
                NSLog(@"WARNING: Empty manifest");
                [strongSelf _becomeIdle];
                [strongSelf _sendDidBecomeIdle];
              } else {
                NSMutableArray* ops = [NSMutableArray new];
                for (NSDictionary* entry in json) {
                  BadgeProxy* bproxy = [BadgeProxy proxyFromJSON:entry];
                  if (bproxy) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                      [strongSelf.delegate serviceFacade:strongSelf didLoadEntry:bproxy];
                    }];
                    [ops addObjectsFromArray:[strongSelf _operationsForBadge:bproxy]];
                  }
                }
                
                
                CallbackType join = ^(NSArray *operations) {
                  NSLog(@"Done with all operations");
                  [strongSelf _becomeIdle];
                  [strongSelf _sendDidBecomeIdle];
                };
              
                ProgressBlockType progress = ^(NSUInteger finishedCount, NSUInteger totalCount) {
                  NSLog(@"Progress %lu of %lu", (unsigned long)finishedCount, (unsigned long)totalCount);
                };

                
                id transformedBatch = [AFURLConnectionOperation batchOfRequestOperations:ops
                                                                           progressBlock:progress
                                                                         completionBlock:join];
                
                [strongSelf.secondStageQ addOperations:transformedBatch waitUntilFinished:NO];
                
              }
            }
          }
        }
      }
    };
    
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.firstStageQ
                           completionHandler:manifestGrabber];
    
    
    
    
    
  }
}

@end
