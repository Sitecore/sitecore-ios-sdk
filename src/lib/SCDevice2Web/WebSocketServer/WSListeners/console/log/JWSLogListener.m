#import "JWSLogListener.h"

#import "HTTPMessage.h"

@implementation JWSLogListener

+(NSString*)requestURLPath
{
    return @"/scmobile/console/log";
}

-(void)didOpen
{
    [ super didOpen ];

    NSDictionary* components_ = [ request.url queryComponents ];
    NSString* logMessage_ = [ [ components_ objectForKey: @"log" ] noThrowObjectAtIndex: 0 ];
    NSLog( @"WebView: %@", logMessage_ );

    [ self stop ];
}

@end
