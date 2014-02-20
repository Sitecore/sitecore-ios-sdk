#import "NSURLRequest+isTestDomain.h"

#import "TestHostConfig.h"

@implementation NSURLRequest (isTestDomain)

-(BOOL)isTestDomain
{
    BOOL domainOk_ = [ self.URL.host isEqualToString: [ TestHostConfig testHost ] ];
    BOOL schemeOk_ = [ self.URL.scheme isEqualToString: [ TestHostConfig testHostUrlScheme ] ];
    BOOL pathOk_   = [ self.URL.path isEqualToString: [ TestHostConfig testHostSuffixPath ] ];

    
    BOOL result = domainOk_ && schemeOk_ && pathOk_;
    
    return result;
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
