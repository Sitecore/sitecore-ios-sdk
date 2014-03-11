#import "TestHostConfig.h"

@implementation TestHostConfig


+(NSString*)testInstance
{
    //return @"http://mobiledev1ua1.dk.sitecore.net:666";
    
    NSString* result = [ NSString stringWithFormat: @"%@://%@:%@",
                        [ self testHostUrlScheme ], [ self testHost ], [ self testPort ] ];
    
    return result;
}

+(NSString*)mobileSdkTestPath
{
    //return @"http://mobiledev1ua1.dk.sitecore.net:666/mobilesdk-test-path";
    
    NSString* result = [ [ self testInstance ] stringByAppendingPathComponent: [ self testHostSuffix ] ];
    
    return result;
}

+(NSString*)testHostSuffixPath
{
    return [ @"/" stringByAppendingString: [ self testHostSuffix ] ];
}

+(NSString*)testHostUrlScheme
{
    return @"http";
}

+(NSString*)testHost
{
    return @"mobiledev1ua1.dk.sitecore.net";
}

+(NSString*)testPort
{
    return @"7200";
}

+(NSString*)testHostSuffix
{
    return @"mobilesdk-test-path";
}



@end
