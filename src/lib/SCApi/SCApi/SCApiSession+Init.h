#import <SitecoreMobileSDK/SCWebApiVersion.h>
#import <SitecoreMobileSDK/SCApiSession.h>

@class SCRemoteApi;
@class SCItemsCache;
@class SCExtendedApiSession;
@protocol SCItemRecordCacheRW;


@interface SCApiSession (Init)


/**
 Returns a new instance of SCApiSession.
 This is a designated initializer that follows the "inversion of control" principle.
 */
-(id)initWithRemoteApi:( SCRemoteApi* )api_
            itemsCache:( id<SCItemRecordCacheRW> )itemsCache_
    notificationCenter:( NSNotificationCenter* )notificationCenter;


/**
 Returns a new instance of SCApiSession.
 Creates new instance of both SCRemoteApi and SCItemsCache.
 
 @param host the host of Sitecore Item Web Api, example: "mobilesdk.sc-demo.net/-/item"
 @param login the login of user to the Sitecore site
 @param password the password of user to the Sitecore site
 */
-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
          version:( SCWebApiVersion )version_;

/**
 Returns a new instance of SCApiSession for "anonymous" user.
 Creates new instance of both SCRemoteApi and SCItemsCache.
 
  @param host the host of Sitecore Item Web Api, example: "mobilesdk.sc-demo.net/-/item"
 */
-(id)initWithHost:( NSString* )host_;


// legacy - for unit tests only
-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_;


@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;
@property ( nonatomic ) SCRemoteApi * api;
@property ( nonatomic ) SCExtendedApiSession *extendedApiSession;

@end
