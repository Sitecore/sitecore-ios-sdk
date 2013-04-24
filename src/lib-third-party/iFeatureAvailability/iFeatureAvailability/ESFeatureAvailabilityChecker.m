#import "ESFeatureAvailabilityChecker.h"

@implementation ESFeatureAvailabilityChecker

+(BOOL)isSocialFrameworkAvailable
{
    static NSString* const SOCIAL_FRAMEWORK_MIN_IOS_VERSION = @"6.0";
    NSString* systemVersion = [ [ UIDevice currentDevice ] systemVersion ];
    NSComparisonResult comp = [ systemVersion compare: SOCIAL_FRAMEWORK_MIN_IOS_VERSION ];
    
    return ( comp != NSOrderedAscending );
}

@end
