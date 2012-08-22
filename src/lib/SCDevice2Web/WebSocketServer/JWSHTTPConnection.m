#import "JWSHTTPConnection.h"

#import "HTTPMessage.h"
#import "JDevice2WebSocketProtocol.h"

static NSMutableDictionary* listenerByPath_ = nil;

@implementation JWSHTTPConnection

-(WebSocket*)webSocketForURI:( NSString* )path_
{
    if ( ![ @"localhost" isEqualToString: request.url.host ] )
    {
        return [ super webSocketForURI: path_ ];
    }

    NSString* requestPath_ = request.url.path;

    Class listenerClass_ = listenerByPath_[ requestPath_ ];
    if ( listenerClass_ )
    {
        return [ [ listenerClass_ alloc ] initWithRequest: request socket: asyncSocket ];
    }

    return [ super webSocketForURI: path_ ];
}

+(void)registerListerClass:( Class )class_
{
    NSString* path_ = objc_msgSend( class_, @selector( requestURLPath ) );
    NSAssert( [ path_ length ], @"path can not be empty" );
//  its not possibke to set with: listenerByPath_[ path_ ] = class_; here
    [ listenerByPath_ setObject: class_ forKey: path_ ];
}

+(void)subscribeAllListeners
{
    @autoreleasepool
    {
        listenerByPath_ = [ NSMutableDictionary new ];

        enumerateAllClassesWithBlock( ^( Class class_ )
        {
            //JTODO add method jConformsToProtocol:
            BOOL conformsProtocol_ = [ class_ conformsToProtocol: @protocol( JDevice2WebSocketProtocol ) ];
            if ( conformsProtocol_ )
                [ self registerListerClass: class_ ];
        } );
    }
}

+(void)load
{
    [ self subscribeAllListeners ];
}

@end
