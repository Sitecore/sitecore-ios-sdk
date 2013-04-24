#import "SCSocialNetworkPluginError.h"

@implementation SCSocialNetworkPluginError

+(SCSocialNetworkPluginError*)noViewControllerError
{
    return [ [ SCSocialNetworkPluginError alloc ] initWithDescription: @"Root view controller not Found"
                                                                 code: 1 ];
}

+(SCSocialNetworkPluginError*)unknownSocialNetworkError
{
    return [ [ SCSocialNetworkPluginError alloc ] initWithDescription: @"Unknown social network"
                                                                 code: 2 ];
}

+(SCSocialNetworkPluginError*)tooOldIosError
{
    return [ [ SCSocialNetworkPluginError alloc ] initWithDescription: @"Social network is unavailable with this version of iOS"
                                                                 code: 3 ];
}

+(SCSocialNetworkPluginError*)noSocialAccountError
{
    return [ [ SCSocialNetworkPluginError alloc ] initWithDescription: @"No account available. Please sign in."
                                                                 code: 4 ];
}

+(SCSocialNetworkPluginError*)postCancelledError
{
    return [ [ SCSocialNetworkPluginError alloc ] initWithDescription: @"Cancelled by the user"
                                                                 code: 5 ];
}


@end
