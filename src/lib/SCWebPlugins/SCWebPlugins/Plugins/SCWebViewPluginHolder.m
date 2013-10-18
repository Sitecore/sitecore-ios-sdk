#import "SCWebViewPluginHolder.h"

#import "SCWebPlugin.h"
#import "SCWebViewPluginDefaultPlugin.h"

#include "pathToAllPluginsJavascripts.h"

@interface SCWebViewPluginHolder () < SCWebPluginDelegate >

@property ( nonatomic ) NSString* socketGuid;
@end

@implementation SCWebViewPluginHolder
{
    id< SCWebPlugin > _webPlugin;
    __weak UIWebView* _webView;
    id _ownThemselves;
    BOOL _closed;
}

-(void)dealloc
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

-(id)initWithWebPlugin:( id< SCWebPlugin > )webPlugin_
               request:( NSURLRequest* )request_
{
    self = [ super init ];

    if ( self )
    {
        _webPlugin      = webPlugin_;
        self.socketGuid = [ [ request_.URL queryComponents ] firstValueIfExsistsForKey: @"guid" ];
        _ownThemselves  = self;
    }

    return self;
}

+(id)webViewPluginHolderForRequest:( NSURLRequest* )request_
{
    NSArray* allPlugins_ = scWebPluginsClasses();
    Class pluginClass_ = [ allPlugins_ firstMatch: ^BOOL( id object_ )
    {
        return [ object_ canInitWithRequest: request_ ]
              && object_ != [ SCWebViewPluginDefaultPlugin class ];
    } ];
    
    NSLog( @"webViewPluginHolderForRequest : %@", request_.URL );
    NSLog( @"plugin classes : %@", allPlugins_ );
    NSLog( @"plugin class : %@", pluginClass_ );

    if ( !pluginClass_ )
    {
        pluginClass_ = [ SCWebViewPluginDefaultPlugin class ];
    }

    id< SCWebPlugin > webPlugin_ = [ [ pluginClass_ alloc ] initWithRequest: request_ ];
    NSLog( @"plugin : %@", webPlugin_ );
    
    return [ [ self alloc ] initWithWebPlugin: webPlugin_
                                      request: request_ ];
}

-(void)autoCloseOnResignActive:( NSNotification* )notification_
{
    [ self close ];
    [ self didClose ];
}

-(void)didOpenOnMainThread
{
    if ( [ self->_webPlugin respondsToSelector: @selector( closeWhenBackground ) ]
        && [ self->_webPlugin closeWhenBackground ] )
    {
        UIApplication* application_ = [ UIApplication sharedApplication ];
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( autoCloseOnResignActive: )
                                                        name: UIApplicationDidEnterBackgroundNotification
                                                      object: application_ ];
    }

    if ( [ self->_webPlugin respondsToSelector: @selector( didOpenInWebView: ) ] )
        [ self->_webPlugin didOpenInWebView: self->_webView ];
}

-(void)onDeallocWebView
{
    self->_webPlugin.delegate = nil;
    if ( !self->_closed )
        [ self->_webPlugin didClose ];

    self->_ownThemselves = nil;
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    if ( [ self->_webPlugin respondsToSelector: @selector( setDelegate: ) ] )
        self->_webPlugin.delegate = self;

    self->_webView = webView_;

    __weak SCWebViewPluginHolder* self_ = self;
    [ self->_webView addOnDeallocBlock: ^
    {
        [ self_ onDeallocWebView ];
    } ];

    [ self performSelectorOnMainThread: @selector( didOpenOnMainThread )
                            withObject: nil
                         waitUntilDone: NO ];
}

-(void)didReceiveMessage:( NSString* )message_
{
    if ( [ self->_webPlugin respondsToSelector: @selector( didReceiveMessage: ) ] )
        [ self->_webPlugin didReceiveMessage: message_ ];
}

-(void)didClose
{
    if ( [ self->_webPlugin respondsToSelector: @selector( didClose ) ] )
        [ self->_webPlugin didClose ];

    self->_ownThemselves = nil;
}

#pragma mark SCWebPluginDelegate

-(void)sendMessageNextTick:( NSString* )message_
{
    static NSString* const sendMessageSocketFormat_ = @"scmobile.utils.internalSendMessageSCWebSocketWithGUID( '%@', '%@' )";

    NSData* data_ = [ message_ dataUsingEncoding: NSUTF8StringEncoding ];
    NSString* base64_ = [ NSString base64StringFromData: data_ length: 0 ];

    NSString* javascript_ = [ [ NSString alloc ] initWithFormat: sendMessageSocketFormat_
                             , self.socketGuid
                             , base64_ ];
    [ self->_webView stringByEvaluatingJavaScriptFromString: javascript_ ];
}

-(void)sendMessage:( NSString* )message_
{
    [ self performSelectorOnMainThread: @selector( sendMessageNextTick: )
                            withObject: message_
                         waitUntilDone: NO ];
}

-(void)closeNextTick
{
    static NSString* const closeSocketFormat_ = @"scmobile.utils.internalCloseSCWebSocketWithGUID( '%@' )";
    NSString* const javascript_ = [ NSString stringWithFormat: closeSocketFormat_, self.socketGuid ];
    [ self->_webView stringByEvaluatingJavaScriptFromString: javascript_ ];

    self->_ownThemselves = nil;
}

-(void)close
{
    self->_closed = YES;

    [ self performSelectorOnMainThread: @selector( closeNextTick )
                            withObject: nil
                         waitUntilDone: NO ];
}

@end
