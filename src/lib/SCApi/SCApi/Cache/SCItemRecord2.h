#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SCItemRecord2 : NSManagedObject

@property ( nonatomic, retain ) NSString* itemId;
@property ( nonatomic, retain ) NSString* database;
@property ( nonatomic, retain ) NSString* language;

@end
