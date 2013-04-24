#import <SitecoreMobileSDK/SCApiContext.h>


@class SCRemoteApi;
@class SCItemsCache;


@interface SCApiContext (Init)


/**
 Returns a new instance of SCApiContext.
 This is a designated initializer that follows the "inversion of control" principle.
 */
-(id)initWithRemoteApi:( SCRemoteApi* )api_
            itemsCache:( SCItemsCache* )itemsCache_;


/**
 Returns a new instance of SCApiContext.
 Creates new instance of both SCRemoteApi and SCItemsCache.
 
 @param host the host of Sitecore Item Web Api, example: "mobilesdk.sc-demo.net/-/item"
 @param login the login of user to the Sitecore site
 @param password the password of user to the Sitecore site
 */
-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_;

/**
 Returns a new instance of SCApiContext for "anonymous" user.
 Creates new instance of both SCRemoteApi and SCItemsCache.
 
  @param host the host of Sitecore Item Web Api, example: "mobilesdk.sc-demo.net/-/item"
 */
-(id)initWithHost:( NSString* )host_;


@property ( nonatomic ) SCItemsCache* itemsCache;
@property ( nonatomic ) SCRemoteApi * api;


@end
