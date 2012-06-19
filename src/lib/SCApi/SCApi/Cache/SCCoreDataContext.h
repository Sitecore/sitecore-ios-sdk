#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface SCCoreDataContext : NSObject

@property ( nonatomic, retain, readonly ) NSManagedObjectContext* managedObjectContext;

+(id)sharedCoreDataContext;

@end
