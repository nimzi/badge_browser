#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AFNetworking.h"



@interface KhanAcademyBrowserTests : XCTestCase
@property (strong) NSOperationQueue* queue;
@property (strong) NSString* url;
@end

@implementation KhanAcademyBrowserTests

- (void)setUp {
  [super setUp];
  _queue = [NSOperationQueue new];
  _queue.maxConcurrentOperationCount = 100;
  
  _url = @"http://www.khanacademy.org/api/v1/badges?format=pretty";
  
//  NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
//                                                          diskCapacity:0
//                                                              diskPath:nil];
//  [NSURLCache setSharedURLCache:sharedCache];
  
}


- (void)tearDown {
  _queue.suspended = YES;
  _queue = nil;
 [super tearDown];
}

- (void)testOps {
  
  __block BOOL isQueueEmpty = _queue.operationCount == 0;
  [_queue addOperationWithBlock:^{
    isQueueEmpty = _queue.operationCount == 0;
  }];
  
  
  [_queue waitUntilAllOperationsAreFinished];
  XCTAssert(!isQueueEmpty, @"Pass");
}


- (void) testBinarySearch {
  
  
  NSArray* sortedArray = @[@"alpha", @"bettan", @"gamma", @"mu", @"rho", @"sigma"];
  NSRange range = NSMakeRange(0, sortedArray.count);
  
  NSUInteger idx = [sortedArray indexOfObject:@"mu" inSortedRange:range options:NSBinarySearchingFirstEqual
             usingComparator:^NSComparisonResult(NSString* l, NSString* r) {

               
               return [l compare:r];
             }];
  
    XCTAssert(idx == 3, @"Pass");
}

//- (void)testFetch {
//  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//  __block BOOL didPass = NO;
//  
//  [manager GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSLog(@"JSON: %@", responseObject);
//    didPass = YES;
//  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    NSLog(@"Error: %@", error);
//  }];
//  
//  [manager.operationQueue waitUntilAllOperationsAreFinished];
//  
//  
//  XCTAssert(didPass, @"Pass");
//}

-(void)testAppleFetch {
  NSURL* actualUrl = [[NSURL alloc] initWithString:_url];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:actualUrl];
  [request setHTTPMethod:@"GET"];
  [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
  [request setTimeoutInterval:15];

  
  
  
  __block BOOL done = NO;
  
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:_queue
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                           
                           // This will get the NSURLResponse into NSHTTPURLResponse format
                           NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                           
                           // This will Fetch the status code from NSHTTPURLResponse object
                           NSInteger responseStatusCode = [httpResponse statusCode];
                           
                           //Just to make sure, it works or not
                           NSLog(@"Status Code :: %ld", (long)responseStatusCode);
                           NSLog(@"Response: %@", httpResponse);
                           
                           
                           id json = (nil == data) ? nil : [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                           NSLog(@"JSON: %@", json);
                           NSLog(@"Error: %@", connectionError);
                           
                           done = YES;
                           
                         }];
  
  
  while (! done) { }
  
  XCTAssert(done, "Got it");
}


-(void) testValueForKeyPath {
  
  id xyz = @{@"abc": @{
                 @"x" : @54,
                 @"y" : @76
                 }
             };
  
  id y = [xyz valueForKeyPath:@"abc.y"];
  id z = [xyz valueForKeyPath:@"mmm"];
  
  XCTAssertEqualObjects(y, @76);
  XCTAssertEqualObjects(z, nil);
  
}






- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
