#import "SCApiContext+Init.h"

#import "SCRemoteApi.h"
#import "SCItemsCache.h"

@implementation SCApiContext (Init)

@dynamic itemsCache;
@dynamic api;

-(id)initWithRemoteApi:( SCRemoteApi* )api_
            itemsCache:( SCItemsCache* )itemsCache_
{
    self = [ super init ];
    {
        self.api = api_;
        self.itemsCache = itemsCache_;
    }

    return self;
}

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
{
    SCRemoteApi* api_ =
    [ [ SCRemoteApi alloc ] initWithHost: host_
                                   login: login_
                                password: password_ ];
    
    SCItemsCache* itemsCache_ = [ SCItemsCache new ];


    return [ self initWithRemoteApi: api_
                         itemsCache: itemsCache_ ];
}

-(id)initWithHost:( NSString* )host_
{
    return [ self initWithHost: host_
                         login: nil
                      password: nil ];
}

@end
