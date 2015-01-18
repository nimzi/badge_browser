#import "Badge.h"

//   Sample JSON:
//
//        absolute_url" = "http://www.khanacademy.org/badges/challenger";
//        "badge_category" = 0;
//        description = Challenger;
//        "hide_context" = 0;
//        "icon_src" = "https://cdn.kastatic.org/images/badges/meteorite/tinkerer-40x40.png";
//        icons =         {
//          compact = "https://cdn.kastatic.org/images/badges/meteorite/tinkerer-60x60.png";
//          email = "https://cdn.kastatic.org/images/badges/meteorite/tinkerer-70x70.png";
//          large = "https://cdn.kastatic.org/images/badges/meteorite/tinkerer-512x512.png";
//          small = "https://cdn.kastatic.org/images/badges/meteorite/tinkerer-40x40.png";
//        };
//        "is_owned" = 0;
//        "is_retired" = 0;
//        name = completechallengebadge;
//        points = 0;
//        "relative_url" = "/badges/challenger";
//        "safe_extended_description" = "Complete a Computer Science Challenge";
//        slug = challenger;
//        "translated_description" = Challenger;
//        "translated_safe_extended_description" = "Complete a Computer Science Challenge";

id strongCast(id obj, Class clz) {
  if (obj == nil) return nil;
  if ([obj isKindOfClass:clz]) return obj; else return nil;
}


@implementation Badge

@dynamic timeStamp;
@dynamic absoluteURL;
@dynamic categoryId;
@dynamic compactDescription;
@dynamic extendedDescription;
@dynamic points;
@dynamic name;
@dynamic smallImage;
@dynamic largeImage;
@dynamic smallImageURL;
@dynamic largeImageURL;
@end




@interface BadgeProxyImpl : NSObject<Badge>
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
@end

@implementation BadgeProxyImpl
@end



@interface BadgeProxy ()
@property (strong) BadgeProxyImpl* impl;
@end

@implementation BadgeProxy
- (instancetype)init {
  _impl = [BadgeProxyImpl new];
  return self;
}

#pragma mark -
-(void) setTimeStamp:(NSDate *)timeStamp {
  _impl.timeStamp = strongCast(timeStamp, [NSDate class]);
}

-(NSDate*)timeStamp { return _impl.timeStamp; }

#pragma mark -
-(void) setAbsoluteURL:(NSString *)absoluteURL {
  _impl.absoluteURL = strongCast(absoluteURL, [NSString class]);
}

-(NSString*) absoluteURL {
  return _impl.absoluteURL;
}

#pragma mark -
-(void) setCategoryId:(NSNumber *)categoryId {
  _impl.categoryId = strongCast(categoryId, [NSNumber class]);
}

-(NSNumber*)categoryId { return _impl.categoryId; }

#pragma mark -
-(void) setCompactDescription:(NSString *)compactDescription {
  _impl.compactDescription = strongCast(compactDescription, [NSString class]);
}

-(NSString*)compactDescription { return _impl.compactDescription; }

#pragma mark -
-(void) setExtendedDescription:(NSString *)extendedDescription {
  _impl.extendedDescription = strongCast(extendedDescription, [NSString class]);
}

-(NSString*)extendedDescription { return _impl.extendedDescription; }

#pragma mark -
-(void) setPoints:(NSNumber *)points {
  _impl.points = strongCast(points, [NSNumber class]);
}

-(NSNumber*) points { return _impl.points; }

#pragma mark -
-(void) setName:(NSString *)name {
  _impl.name = strongCast(name, [NSString class]);
}

-(NSString*) name { return _impl.name; }

#pragma mark -
-(void) setSmallImageURL:(NSString *)smallImageURL {
  _impl.smallImageURL = strongCast(smallImageURL, [NSString class]);
}

-(NSString*) smallImageURL { return _impl.smallImageURL; }


#pragma mark -
-(void) setLargeImageURL:(NSString *)largeImageURL {
  _impl.largeImageURL = strongCast(largeImageURL, [NSString class]);
}

-(NSString*) largeImageURL { return _impl.largeImageURL; }





+(instancetype) proxyFromJSON:(NSDictionary*)json {
  BadgeProxy* proxy = nil;
  json = strongCast(json, [NSDictionary class]);
  if (json) {
    proxy = [BadgeProxy new];
    
    // `valueForKey` is more efficient than `valueForKeyPath`, so no
    // harm in optimizing a bit :)
    //
    proxy.absoluteURL = json[@"absolute_url"];
    proxy.name = json[@"name"];
    proxy.points = json[@"points"];
    proxy.categoryId = json[@"badge_category"];
    proxy.compactDescription = json[@"description"];
    proxy.extendedDescription = json[@"safe_extended_description"];
    
    proxy.smallImageURL = [json valueForKeyPath:@"icons.compact"];
    proxy.largeImageURL = [json valueForKeyPath:@"icons.large"];
    
    proxy.timeStamp = [NSDate date];
    
  }
  
  
  return proxy;
}



-(void) _findIn:(NSManagedObjectContext*)moc {
  
}


-(void) _sync {
  if (_badge) {
    
  }
}

-(void) _insertNewBadgeInto:(NSManagedObjectContext*)moc {
  //  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Badge"
  //                                            inManagedObjectContext:moc];
  
  _badge = [NSEntityDescription insertNewObjectForEntityForName:@"Badge"
                                         inManagedObjectContext:moc];
  
  _badge.name = _impl.name;
  
  
}

-(void)upsert:(NSManagedObjectContext *)moc {
  if (nil == _badge) {
    [self _findIn:moc];
    if (nil == _badge) {
      [self _insertNewBadgeInto:moc];
    }
  }
  
  [self _sync];
}


@end






















