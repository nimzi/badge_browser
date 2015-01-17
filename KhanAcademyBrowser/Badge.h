//
//  Event.h
//  KhanAcademyBrowser
//
//  Created by Paul Agron on 1/15/15.
//  Copyright (c) 2015 Paul Agron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Badge : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * absoluteURL;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSString * compactDescription;
@property (nonatomic, retain) NSString * extendedDescription;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * smallImage;
@property (nonatomic, retain) NSData * largeImage;

-(void) hydrateFromJSON:(NSDictionary*) json;

@end
