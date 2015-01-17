//
//  RemoteDataController.h
//  KhanAcademyBrowser
//
//  Created by Paul Agron on 1/15/15.
//  Copyright (c) 2015 Paul Agron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceFacade : NSObject
-(BOOL) isBusy;
-(void) refreshIfNotBusy;
@end
