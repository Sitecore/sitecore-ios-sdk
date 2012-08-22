#import "SCWebSocketServer.h"

#import "HTTPServer.h"

#import "JWSHTTPConnection.h"

@class SCWebSocketServer;

static SCWebSocketServer* instance_ = nil;

NSString* const SCWebSocketServerPortChanged = @"SCWebSocketServerPortChanged";

@implementation SCWebSocketServer
{
    HTTPServer* _server;
    UInt16 _port;
}

-(void)dealloc
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

-(void)didStart
{
    UIApplication* application_ = [ UIApplication sharedApplication ];
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( didBecomeActive: )
                                                    name: UIApplicationDidBecomeActiveNotification
                                                  object: application_ ];
}

-(void)startOnSomePort
{
    const UInt16 startPort_ = _port + 1;
    for ( UInt16 port_ = startPort_; port_ < startPort_ + 10000; ++port_ )
    {
        // Normally there's no need to run our server on any specific port.
        // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
        // However, for easy testing you may want force a certain port so you can just hit the refresh button.
        [ _server setPort: port_ ];

        NSError* error;
        // Start the server (and check for problems)
        if( ![ _server start: &error ] )
        {
            //NSLog( @"Error starting HTTP Server: %@", error );
            continue;
        }

        //NSLog( @"Started HTTP Server with port: %d", port_ );
        _port = port_;
        break;
    }
}

-(void)didBecomeActive:( NSNotification* )notification_
{
    [ self->_server stop ];
    [ self startOnSomePort ];

    NSNumber* port_ = @( self->_port );
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: SCWebSocketServerPortChanged
                                                           object: port_ ];
}

-(void)start
{
    // Create server using our custom MyHTTPServer class
    _server = [ HTTPServer new ];

    // Tell server to use our custom JWSSHTTPConnection class.
    [ _server setConnectionClass: [ JWSHTTPConnection class ] ];

    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [ _server setType: @"_http._tcp." ];

    //TODO remove

    _port = 64447;
    [ self startOnSomePort ];

    [ self didStart ];
}

+(UInt16)port
{
    return instance_->_port;
}

+(void)start
{
    if ( !instance_ )
    {
        instance_ = [ self new ];
        [ instance_ start ];
    }
}

@end
