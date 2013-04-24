#import "SCSrvResponseCaches.h"

#import "SCCacheDBAdaptor.h"
#import "SCDataCache.h"

#import <JFFCache/JFFCache.h>


static NSString* const scSrvCacheName_ = @"scSrvResponseCache";

@implementation SCSrvResponseCachesFactory

+(JFFCaches*)sharedSCCaches
{
    static id instance_ = nil;

    if ( !instance_ )
    {
        NSDictionary* srvResponseCacheInfo_ = @{
        @"fileName" : @"scSrvResponseCache.data",
        @"version"  : @"1"
        };

        NSDictionary* dbDescription_ = @{ scSrvCacheName_ : srvResponseCacheInfo_ };

        instance_ = [ [ JFFCaches alloc ] initWithDBInfoDictionary: dbDescription_ ];
    }

    return instance_;
}

+(id< SCDataCache >)sharedSrvResponseCache
{
    SCCacheDBAdaptor* result_ = [ SCCacheDBAdaptor new ];
    result_.jffCacheDB = [ self mobileSdkRawCache ];
    return result_;
}

+(id< JFFCacheDB >)mobileSdkRawCache;
{
    return [ [ self sharedSCCaches ] cacheByName: scSrvCacheName_ ];
}

@end
