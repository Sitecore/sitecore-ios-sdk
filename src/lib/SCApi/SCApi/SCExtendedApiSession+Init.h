#import <SitecoreMobileSDK/SCExtendedApiSession.h>
#import <SitecoreMobileSDK/SCWebApiVersion.h>

@class SCRemoteApi;
@class SCItemsCache;
@protocol SCItemRecordCacheRW;


@interface SCExtendedApiSession (Init)

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
