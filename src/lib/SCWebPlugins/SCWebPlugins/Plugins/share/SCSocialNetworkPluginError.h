#import "SCWebPluginError.h"

@interface SCSocialNetworkPluginError : SCWebPluginError

+(SCSocialNetworkPluginError*)noViewControllerError;
+(SCSocialNetworkPluginError*)unknownSocialNetworkError;
+(SCSocialNetworkPluginError*)tooOldIosError;
+(SCSocialNetworkPluginError*)noSocialAccountError;
+(SCSocialNetworkPluginError*)postCancelledError;

@end
