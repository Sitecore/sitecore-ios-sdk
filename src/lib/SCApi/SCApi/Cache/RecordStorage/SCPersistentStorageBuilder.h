#import <SCApi/Cache/RecordStorage/SCItemRecordStorageBuilder.h>
#import <Foundation/Foundation.h>

@class SCCacheSettings;
@class SCExtendedApiContext;

@interface SCPersistentStorageBuilder : NSObject< SCItemRecordStorageBuilder >

-(instancetype)initWithDatabasePathBase:( NSString* )databasePathBase
                               settings:( SCCacheSettings* )settings;


@property ( nonatomic, weak ) SCExtendedApiContext* apiContext;

@end
