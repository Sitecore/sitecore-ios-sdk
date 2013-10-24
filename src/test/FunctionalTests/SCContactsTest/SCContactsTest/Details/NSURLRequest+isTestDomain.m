#import "NSURLRequest+isTestDomain.h"

@implementation NSURLRequest (isTestDomain)

-(BOOL)isTestDomain
{
    BOOL domainOk_ = [ self.URL.host isEqualToString: @"mobiledev1ua1.dk.sitecore.net" ];
    BOOL schemeOk_ = domainOk_ && [ self.URL.scheme isEqualToString: @"http" ];
    BOOL pathOk_   = schemeOk_ && [ self.URL.path isEqualToString: @"/mobilesdk-test-path" ];
    return pathOk_;
}

-(BOOL)isUrlMeaningful
{
    if ( nil == self.URL )
    {
        return NO;
    }
    else if ( [ [ self.URL absoluteString ] isEqualToString: @"about:blank" ] )
    {
        return NO;
    }
    
    return YES;
}

@end
