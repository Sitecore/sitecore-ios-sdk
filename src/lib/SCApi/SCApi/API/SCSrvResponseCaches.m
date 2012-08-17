#import "SCSrvResponseCaches.h"

#import "SCDataCache.h"

#import <JFFCache/JFFCache.h>

static NSString* const scSrvCacheName_ = @"scSrvResponseCache";

@interface SCCacheDBAdaptor : NSObject < SCDataCache >

@property ( nonatomic ) id< JFFCacheDB >  jffCacheDB;

@end

@implementation SCCacheDBAdaptor

@synthesize jffCacheDB;

-(void)setData:( NSData* )data_ forKey:( NSString* )key_
{
    [ jffCacheDB setData: data_ forKey: key_ ];
}

-(NSData*)dataForKey:( NSString* )data_ lastUpdateDate:( NSDate** )date_
{
    return  [ jffCacheDB dataForKey: data_ lastUpdateTime: date_ ];
}

@end

static JFFCaches* sharedSCCaches()
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

id< SCDataCache > sharedSrvResponseCache( void )
{
    SCCacheDBAdaptor* result_ = [ SCCacheDBAdaptor new ];
    result_.jffCacheDB = [ sharedSCCaches() cacheByName: scSrvCacheName_ ];
    return result_;
}
