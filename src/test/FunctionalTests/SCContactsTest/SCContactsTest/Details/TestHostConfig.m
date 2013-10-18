#import "TestHostConfig.h"

@implementation TestHostConfig

+(NSString*)testInstance
{
    return @"http://mobiledev1ua1.dk.sitecore.net:666";
}

+(NSString*)mobileSdkTestPath
{
    return [ [ self testInstance ] stringByAppendingString: @"/mobilesdk-test-path" ];
}

@end
