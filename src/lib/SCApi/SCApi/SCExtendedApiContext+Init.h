#import <SitecoreMobileSDK/SCExtendedApiContext.h>
#import <SitecoreMobileSDK/SCWebApiVersion.h>

@class SCRemoteApi;
@class SCItemsCache;
@protocol SCItemRecordCacheRW;


@interface SCExtendedApiContext (Init)

// designated initializer
-(instancetype)initWithRemoteApi:( SCRemoteApi* )api
                      itemsCache:( id<SCItemRecordCacheRW> )itemsCache
              notificationCenter:( NSNotificationCenter* )notificationCenter;

-(instancetype)initWithRemoteApi:( SCRemoteApi* )api
                      itemsCache:( id<SCItemRecordCacheRW> )itemsCache;

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;
@property ( nonatomic ) SCRemoteApi * api;
@property ( nonatomic ) NSNotificationCenter* notificationCenter;

@end
