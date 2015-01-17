#import "ServiceFacade.h"
#import <iso646.h>


typedef void (^CompletionHandlerType)(NSURLResponse *response, NSData *data, NSError *connectionError);

@interface ServiceFacade()
@property BOOL busy;
@property (strong) typeof(NSOperationQueue*) firstStageQ, secondStageQ;
@property (strong, readonly) NSURL* serviceUrl;
@property (readonly) NSTimeInterval timeoutIntervalForManifest;
@property (readonly) NSTimeInterval timeoutIntervalForDetail;
@property (readonly) NSTimeInterval timeoutIntervalForImages;

-(void) zeroDeficitReachedByAccumulator:(id)accumulator;
@end




@interface StatusAcumulator : NSObject
@property NSInteger smallImageDeficit;
@property NSInteger largeImageDeficit;
@property (weak) id delegate;

-(void) smallImageArrived;
-(void) largeImageArrived;
-(void) imagesArrived;
@end

@implementation StatusAcumulator {
  NSOperationQueue* _serialQueue;
}

-(void) smallImageArrived {
  [_serialQueue addOperationWithBlock:^{
    self.smallImageDeficit = self.smallImageDeficit - 1;
    [self signalIfNeeded]; }];
}

-(void) largeImageArrived {
  [_serialQueue addOperationWithBlock:^{
    self.largeImageDeficit = self.largeImageDeficit - 1;
    [self signalIfNeeded]; }];
}

-(void) imagesArrived {
  [self smallImageArrived];
  [self largeImageArrived];
}

-(void) signalIfNeeded {
  if (_smallImageDeficit == 0 and _largeImageDeficit == 0) {
    [_delegate zeroDeficitReachedByAccumulator:self];
  }
}


- (instancetype)initWithSerialQueue:(NSOperationQueue*)qq delegate:(id)other {
  self = [super init];
  if (self) {
    _serialQueue = qq;
    _delegate = other;
  }
  return self;
}

@end




@implementation ServiceFacade
@synthesize serviceUrl=_serviceUrl;


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
    self.secondStageQ.maxConcurrentOperationCount = 1;

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
      
      // This isn't how you do error logging... but...
      NSLog(@"WARNING: Someone asking Service to become Idle when NOT busy");
      return NO;
    }
  }
}


-(void) zeroDeficitReachedByAccumulator:(id)accumulator {
  [self _becomeIdle];
}




/*
typedef void (^SimpleClosureType)(void);
typedef NSArray* ClosureArray;
typedef ClosureArray (^ForkingHandlerType)(NSURLResponse *response, NSData *data, NSError *connectionError);
typedef void (^JoinHandlerType)(void);


// Note queue must be synchronous
+ (void)sendAsynchronousRequest:(NSURLRequest*) request
                          queue:(NSOperationQueue*) synchronousQueue
                 forkingHandler:(ForkingHandlerType) forker
                    joinHandler:(JoinHandlerType) joiner
{
  
  
  id forkerCopy = [forker copy]; // Necessary??
  id joinerCopy = [joiner copy]; // ??
  
  
  __block NSInteger counter = 0;
  
  CompletionHandlerType handler = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    NSArray* closures = forker(response, data, connectionError);
    if (closures.count > 0) {
      counter = closures.count;
      for (SimpleClosure returnedBlock in closures)
        [synchronousQueue addOperationWithBlock:^{
          returnedBlock();
          
        }];
      
    }
  };
  
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:synchronousQueue
                         completionHandler:handler];
  
}

*/



-(void) _processEntry:(NSDictionary*)entry
           accumulator:(StatusAcumulator*)status {
  
  if (not [entry isKindOfClass:[NSDictionary class]]) {
    [status imagesArrived];
  } else {
    id pathToLarge = [entry valueForKeyPath:@"icons.large"];
    id pathToSmall = [entry valueForKeyPath:@"icons.compact"];
    
    NSURL* urlForLarge = (pathToLarge) ? [NSURL URLWithString:pathToLarge] : nil;
    NSURL* urlForSmall = (pathToSmall) ? [NSURL URLWithString:pathToSmall] : nil;
    
    
  }
  
  
  
  
  
}



-(void) refreshIfNotBusy {
  if ([self _becomeBusy]) {
  
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.serviceUrl];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    [request setTimeoutInterval:self.timeoutIntervalForManifest];
    
    
    StatusAcumulator* status = [[StatusAcumulator alloc] initWithSerialQueue:self.firstStageQ
                                                                    delegate:self];
    
    CompletionHandlerType manifestGrabber = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      if (connectionError) {
        [self _becomeIdle];
      } else {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        if (responseStatusCode != 400) {
          //Just to make sure, it works or not
          NSLog(@"WARNING: Status code = %ld", (long)responseStatusCode);
          [self _becomeIdle];
        } else {
          NSError* parsingError = nil;
          NSArray* json = (nil == data) ? nil : [NSJSONSerialization JSONObjectWithData:data
                                                                                options:0
                                                                                  error:&parsingError];
          
          if (parsingError or json == nil or not [json isKindOfClass:[NSArray class]]) {
            NSLog(@"WARNING: Inconsistend format");
            [self _becomeIdle];
          } else {
            if (not (json.count > 0)) {
              NSLog(@"WARNING: Empty manifest");
              [self _becomeIdle];
            } else {
              status.largeImageDeficit = (status.smallImageDeficit = json.count);
              for (NSDictionary* entry in json) {
                [self _processEntry:entry
                        accumulator:status];
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
