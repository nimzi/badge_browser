#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


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


@interface Amoeba : NSManagedObject
@property (nonatomic) NSString* name;   // x
@property (nonatomic) NSString* absoluteURL; // x
@property (nonatomic) NSInteger categoryId; // x

@property (nonatomic) NSData* smallImage;               // dictated by icons.compact
@property (nonatomic) NSData* largeImage;               // dictated by icons.large
@property (nonatomic) NSInteger points;                 // x - points
@property (nonatomic) NSString* compactDescription;      // x - description
@property (nonatomic) NSString* extendedDescription;   // x - safe_extended_description

@property (nonatomic) NSDate* timeStamp;                // x ... for analisys purposes

@end
