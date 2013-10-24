#import <Foundation/Foundation.h>

@interface SCCacheSettings : NSObject

@property ( nonatomic ) NSString* host;
@property ( nonatomic ) NSString* userName;
@property ( nonatomic ) NSString* cacheDbVersion;

-(NSString*)getBaseNameForCacheDatabase;
-(NSString*)getFullNameForCacheDatabaseInDocumentsDir;

@end
