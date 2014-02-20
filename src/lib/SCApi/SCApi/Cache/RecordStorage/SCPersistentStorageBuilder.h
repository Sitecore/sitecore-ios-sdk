#import <SCApi/Cache/RecordStorage/SCItemRecordStorageBuilder.h>
#import <Foundation/Foundation.h>

@class SCCacheSettings;
@class SCExtendedApiSession;

@interface SCPersistentStorageBuilder : NSObject< SCItemRecordStorageBuilder >

-(instancetype)initWithDatabasePathBase:( NSString* )databasePathBase
                               settings:( SCCacheSettings* )settings;


@property ( nonatomic, weak ) SCExtendedApiSession* apiSession;

@end
