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



id strongCast(id obj, Class clz) {
  if (obj == nil) return nil;
  if ([obj isKindOfClass:clz]) return obj; else return nil;
}

@implementation BadgeProxy

-(void) setTimeStamp:(NSDate *)timeStamp {
  _timeStamp = strongCast(timeStamp, [NSDate class]);
}

-(void) setAbsoluteURL:(NSString *)absoluteURL {
  _absoluteURL = strongCast(absoluteURL, [NSString class]);
}

-(void) setCategoryId:(NSNumber *)categoryId {
  _categoryId = strongCast(categoryId, [NSNumber class]);
}

-(void) setCompactDescription:(NSString *)compactDescription {
  _compactDescription = strongCast(compactDescription, [NSString class]);
}

-(void) setExtendedDescription:(NSString *)extendedDescription {
  _extendedDescription = strongCast(extendedDescription, [NSString class]);
}

-(void) setPoints:(NSNumber *)points {
  _points = strongCast(points, [NSNumber class]);
}

-(void) setName:(NSString *)name {
  _name = strongCast(name, [NSString class]);
}

-(void) setSmallImageURL:(NSString *)smallImageURL {
  _smallImageURL = strongCast(smallImageURL, [NSString class]);
}

-(void) setLargeImageURL:(NSString *)largeImageURL {
  _largeImageURL = strongCast(largeImageURL, [NSString class]);
}





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


@end













