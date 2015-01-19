//
//  Event.h
//  KhanAcademyBrowser
//
//  Created by Paul Agron on 1/15/15.
//  Copyright (c) 2015 Paul Agron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol Badge <NSObject>
@property (strong) NSDate*   timeStamp;
@property (strong) NSString* absoluteURL;
@property (strong) NSNumber* categoryId;
@property (strong) NSString* compactDescription;
@property (strong) NSString* extendedDescription;
@property (strong) NSNumber* points;
@property (strong) NSString* name;
@property (strong) NSData*   smallImage;
@property (strong) NSData*   largeImage;
@property (strong) NSString* smallImageURL;
@property (strong) NSString* largeImageURL;
@end




@interface Badge : NSManagedObject
@property (nonatomic, strong) NSDate* timeStamp;
@property (nonatomic, strong) NSString* absoluteURL;
@property (nonatomic, strong) NSNumber* categoryId;
@property (nonatomic, strong) NSString* compactDescription;
@property (nonatomic, strong) NSString* extendedDescription;
@property (nonatomic, strong) NSNumber* points;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSData* smallImage;
@property (nonatomic, strong) NSData* largeImage;
@property (nonatomic, strong) NSString* smallImageURL;
@property (nonatomic, strong) NSString* largeImageURL;
@end


@interface BadgeProxy : NSObject<Badge>
@property (strong) NSDate* timeStamp;
@property (strong) NSString* absoluteURL;
@property (strong) NSNumber* categoryId;
@property (strong) NSString* compactDescription;
@property (strong) NSString* extendedDescription;
@property (strong) NSNumber* points;
@property (strong) NSString* name;
@property (strong) NSData* smallImage;
@property (strong) NSData* largeImage;
@property (strong) NSString* smallImageURL;
@property (strong) NSString* largeImageURL;

@property (strong) Badge* badge;

+(instancetype) proxyFromJSON:(NSDictionary*)json;
-(void)upsert:(NSManagedObjectContext*)moc;
@end

