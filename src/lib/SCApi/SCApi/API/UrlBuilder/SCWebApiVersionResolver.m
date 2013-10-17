#import "SCWebApiVersionResolver.h"

static NSArray* VERSIONS_MAP = nil;

@implementation SCWebApiVersionResolver

+(NSArray*)versionsMap
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
    ^{
        VERSIONS_MAP = @[ @"Unknown", @"v1" ];
    } );

    return VERSIONS_MAP;
}

+(NSString*)webApiVersionToString:( SCWebApiVersion )webApiVersion
{
    if ( webApiVersion < SCWebApiMinSupportedVersion )
    {
        return nil;
    }
    else if ( webApiVersion > SCWebApiMaxSupportedVersion )
    {
        return nil;
    }

    return [ self versionsMap ][ webApiVersion ];
}

@end
