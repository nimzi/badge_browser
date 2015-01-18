//
//  RemoteDataController.h
//  KhanAcademyBrowser
//
//  Created by Paul Agron on 1/15/15.
//  Copyright (c) 2015 Paul Agron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ServiceFacade;
@class BadgeProxy;

@protocol ServiceFacadeDelegate<NSObject>
-(void) serviceFacade:(ServiceFacade*)facade didLoadEntry:(BadgeProxy*)entry;
-(void) serviceFacade:(ServiceFacade*)facade didLoadLargeImage:(UIImage*)image forEntry:(BadgeProxy*)entry;
-(void) serviceFacade:(ServiceFacade*)facade didLoadSmallImage:(UIImage*)image forEntry:(BadgeProxy*)entry;

-(void) serviceFacadeDidBecomeIdle:(ServiceFacade*)facade;
@end

@interface ServiceFacade : NSObject
@property (weak, nonatomic) id<ServiceFacadeDelegate> delegate;
-(BOOL) isBusy;
-(void) refreshIfNotBusy;
+(instancetype) instance;
@end
