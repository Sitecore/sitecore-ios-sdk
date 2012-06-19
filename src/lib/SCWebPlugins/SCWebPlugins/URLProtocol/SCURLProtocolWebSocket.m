#import "SCPluginsURLProtocol.h"

@interface SCURLProtocolWebSocket : SCPluginsURLProtocol
@end

@implementation SCURLProtocolWebSocket

-(void)startLoading
{
    NSDictionary* components_ = [ self.request.URL queryComponents ];
    NSString* log_message_ = [ [ components_ objectForKey: @"log" ] noThrowObjectAtIndex: 0 ];
    NSLog( @"WebView: %@", log_message_ );

    [ self sendFinishLoading ];
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ @"sclog" isEqualToString: request_.URL.scheme ];
}

+(void)load
{
    BOOL result_ = [ NSURLProtocol registerClass: [ self class ] ];
    NSAssert( result_, @"SCURLProtocolWebSocket should be registered" );
}

@end
