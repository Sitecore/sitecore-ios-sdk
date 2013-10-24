#import "SCExtendedApiContext+Init.h"

@implementation SCExtendedApiContext (Init)

@dynamic itemsCache;
@dynamic api;
@dynamic notificationCenter;


-(instancetype)initWithRemoteApi:( SCRemoteApi* )api
                      itemsCache:( id<SCItemRecordCacheRW> )itemsCache
              notificationCenter:( NSNotificationCenter* )notificationCenter
{
    self = [ super init ];
    {
        self.api = api;
        self.itemsCache = itemsCache;
        self.notificationCenter = notificationCenter;
    }
    
    return self;
}

-(instancetype)initWithRemoteApi:( SCRemoteApi* )api
                      itemsCache:( id<SCItemRecordCacheRW> )itemsCache
{
    NSNotificationCenter* defaultCenter = [ NSNotificationCenter defaultCenter ];
    return [ self initWithRemoteApi: api
                         itemsCache: itemsCache
                 notificationCenter: defaultCenter ];
}

@end
