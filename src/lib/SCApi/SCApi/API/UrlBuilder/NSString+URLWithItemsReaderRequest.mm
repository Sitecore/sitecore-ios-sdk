#import "NSString+URLWithItemsReaderRequest.h"

@implementation NSString (URLWithItemsReaderRequest)

-(NSString*)apiVersionPathWithSitecoreShell
{
    return [ self stringByAppendingString: @"/sitecore/shell" ];
}

-(NSString*)scHostWithURLScheme
{
    std::string stlHost = [ self toStlString ];
    ::http::url parsedHost = ::http::ParseHttpUrl( stlHost );

    BOOL isUrlSchemePresent = !parsedHost.protocol.empty();    
    if ( isUrlSchemePresent )
    {
        return self;
    }

    NSString* result_ = [ @"http://" stringByAppendingString: self ];
    return result_;
}

@end

