#import "SCWebViewWrapper.h"

#import "SCWebViewWrapperDelegate.h"

#import "SCWebViewSwipes.h"
#import "SCWebViewDeviceEvents.h"

#import <SCDevice2Web/WebSocketServer/SCWebSocketServer.h>

//STODO remove
@interface NSURL (IsDWFilePathURL_STODORemove)

-(BOOL)isDWFilePathURL;

@end

@interface SCWebViewWrapper ()
<
UIWebViewDelegate
, UINavigationControllerDelegate
>

@property ( nonatomic ) UIActivityIndicatorView* activityIndicator;
@property ( nonatomic ) NSURLRequest* contentRequest;

-(void)initialize;

@end

@implementation SCWebViewWrapper
{
    UIWebView* _webView;
    UIActivityIndicatorView* _activityIndicator;

    SCWebViewSwipes*        _webViewSwipes;
    SCWebViewDeviceEvents*  _deviceEvents;
}

@dynamic scalesPageToFit;
@dynamic request;

-(void)dealloc
{
    _webView.delegate = nil;
    
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

-(id)init
{
    return [ self initWithFrame: CGRectZero ];
}

-(id)initWithFrame:( CGRect )frame_
{
    self = [ super initWithFrame: frame_ ];

    [ self initialize ];

    return self;
}

-(UIWebView*)webView
{
    if ( !_webView )
    {
        _webView = [ [ UIWebView alloc ] initWithFrame: self.frame ];
        _webView.delegate = self;
        [ self addSubviewAndScale: _webView ];

        _activityIndicator = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray ];
        _activityIndicator.color = [ UIColor redColor ];
        _activityIndicator.autoresizingMask = UIViewAutoresizingNone;
        _activityIndicator.center = self.center;
        [ self addSubview: _activityIndicator ];

        [ _webView loadRequest: self.contentRequest ];
    }
    return _webView;
}

-(void)initialize
{
    [ SCWebSocketServer start ];

    _deviceEvents  = [ [ SCWebViewDeviceEvents alloc ] initWithWebView: _webView ];
    _webViewSwipes = [ [ SCWebViewSwipes       alloc ] initWithWebView: _webView ];

    self.scalesPageToFit = YES;

    //STODO remove
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( didChangedPort: )
                                                    name: @"SCWebSocketServerPortChanged"
                                                  object: nil ];
}

-(void)handleMemoryWarning
{
    self.contentRequest = _webView.request;

    [ _webView removeFromSuperview ];
    _webView = nil;
}

-(NSURLRequest*)request
{
    return _webView ? _webView.request : self.contentRequest;
}

-(void)didChangedPort:( NSNotification* )notification_
{
    NSString* webSocketPortJSFormat_ = @"scmobile.device.socketPort = '%@';";
    NSString* webSocketPortJS_ = [ [ NSString alloc ] initWithFormat: webSocketPortJSFormat_, notification_.object ];
    [ self stringByEvaluatingJavaScriptFromString: webSocketPortJS_ ];
}

-(void)awakeFromNib
{
    [ self initialize ];
}

#pragma mark UIWebView

-(void)loadURL:( NSURL* )url_
{
    NSURLRequest* request_ = [ [ NSURLRequest alloc ] initWithURL: url_ ];
    [ self loadRequest: request_ ];
}

-(void)loadURLWithString:( NSString* )url_string_
{
    [ self loadURL: [ [ NSURL alloc ] initWithString: url_string_ ] ];
}

-(UIScrollView*)scrollView
{
    return self->_webView.scrollView;
}

-(void)loadRequest:( NSURLRequest* )request_
{
    [ self->_activityIndicator startAnimating ];
    
    [ self->_webView loadRequest: request_ ];
}

-(void)loadHTMLString:( NSString* )string_ baseURL:( NSURL* )baseURL_
{
    [ self->_webView loadHTMLString: string_ baseURL: baseURL_ ];
}

-(void)reload
{
    [ self->_webView reload ];
}

-(void)stopLoading
{
    [ self->_webView stopLoading ];
}

-(void)goBack
{
    [ self->_webView goBack ];
}

-(void)goForward
{
    [ self->_webView goForward ];
}

-(BOOL)canGoBack
{
    return [ self->_webView canGoBack ];
}

-(BOOL)canGoForward
{
    return [ self->_webView canGoForward ];
}

-(id)forwardingTargetForSelector:( SEL )aSelector
{
    return self.webView;
}

+(void)enableSCJavascriptForWevView:( UIWebView* )webView_
{
    [ webView_ enableSCWebViewPlugins ];
}

-(NSString*)stringByEvaluatingJavaScriptFromString:( NSString* )script_
{
    return [ self->_webView stringByEvaluatingJavaScriptFromString: script_ ];
}

-(BOOL)isLoading
{
    return [ self->_webView isLoading ];
}

-(void)loadData:(NSData *)data
       MIMEType:(NSString *)MIMEType
textEncodingName:(NSString *)textEncodingName
        baseURL:(NSURL *)baseURL
{
    [ self->_webView loadData: data
                     MIMEType: MIMEType
             textEncodingName: textEncodingName
                      baseURL: baseURL ];
}

-(void)layoutSubviews
{
    [ super layoutSubviews ];

    self->_activityIndicator.center = self.center;
}

#pragma mark UIWebViewDelegate

-(BOOL)webView:( UIWebView* )webView_
shouldStartLoadWithRequest:( NSURLRequest* )request_
navigationType:( UIWebViewNavigationType )navigation_type_
{
    if ( [ webView_ applyPluginToRequest: request_ ] )
        return NO;

    if ( [ [ request_ URL ] isDWFilePathURL ] )
        return YES;

    SEL selector_ = @selector( webView:shouldStartLoadWithRequest:navigationType: );
    if ( [ self->_delegate respondsToSelector: selector_ ] )
    {
        return [ self->_delegate webView: self
       shouldStartLoadWithRequest: request_
                   navigationType: navigation_type_ ];
    }

    return YES;
}

-(void)webViewDidStartLoad:( UIWebView* )webView_
{
    if ( [ self->_delegate respondsToSelector: @selector( webViewDidStartLoad: ) ] )
        [ self->_delegate webViewDidStartLoad: self ];
}

-(void)webViewDidFinishLoad:( UIWebView* )webView_
{
    [ self->_activityIndicator stopAnimating ];

    if ( [ self->_delegate respondsToSelector: @selector( webViewDidFinishLoad: ) ] )
        [ self->_delegate webViewDidFinishLoad: self ];

    [ [ self class ] enableSCJavascriptForWevView: webView_ ];
}

-(void)webView:( UIWebView* )web_view_
didFailLoadWithError:( NSError* )error_
{
    [ self->_activityIndicator stopAnimating ];

    if ( [ self->_delegate respondsToSelector: @selector( webView:didFailLoadWithError: ) ] )
        [ self->_delegate webView: self didFailLoadWithError: error_ ];
}

@end
