#import "SCWebBrowser.h"

#import "SCWebView.h"
#import "SCNavigationHeader.h"

#import "SCWebViewDelegate.h"
#import "SCWebBrowserDelegate.h"

#import "SCWebBrowserToolbar.h"

static CGFloat navigatin_header_height_ = 40.f;

@interface SCWebBrowser () < SCWebBrowserToolbarDelegate, SCWebViewDelegate >

@property ( nonatomic ) SCWebView* webView;
@property ( nonatomic ) UIView< SCWebBrowserToolbar >* navigationHeader;

@end

@implementation SCWebBrowser

@synthesize webView, navigationHeader;

@dynamic dataDetectorTypes
, allowsInlineMediaPlayback
, mediaPlaybackRequiresUserAction
, mediaPlaybackAllowsAirPlay
, scalesPageToFit
, activityIndicator;

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

-(CGRect)navigationHeaderRect
{
    CGFloat height_ = self.navigationHeader.bounds.size.height > 0.f
    ? self.navigationHeader.bounds.size.height
    : navigatin_header_height_;
    return CGRectMake( 0.f
                      , 0.f
                      , self.frame.size.width
                      , height_ );
}

-(CGRect)webViewRect
{
    CGRect slice_;
    CGRect remainder_;
    CGRectDivide(self.bounds
                 , &slice_
                 , &remainder_
                 , self.navigationHeader.bounds.size.height
                 , CGRectMinYEdge );
    return remainder_;
}

-(void)setCustomToollbarView:(UIView< SCWebBrowserToolbar >*)navigator_
{
    [ self.navigationHeader removeFromSuperview ];
    
    self.navigationHeader = navigator_;
    
    if ( [ self.navigationHeader respondsToSelector: @selector( setDelegate: ) ] )
        self.navigationHeader.delegate = self;
    
    self.navigationHeader.frame    = [ self navigationHeaderRect ];
    self.navigationHeader.autoresizingMask |= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [ self addSubview: self.navigationHeader ];
    
    if ( self.webView )
    {
        self.webView.frame = [ self webViewRect ];
    }
}

-(void)initialize
{
    SCNavigationHeader* navigationHeader_ = [ [ SCNavigationHeader alloc ] initWithFrame: [ self navigationHeaderRect ] ];
    [ self setCustomToollbarView: navigationHeader_ ];
    
    webView = [ [ SCWebView alloc ] initWithFrame: [ self webViewRect ] ];
    webView.delegate = self;
    [ self addSubviewAndScale: self.webView ];
}

-(void)awakeFromNib
{
    [ self initialize ];
}

-(void)layoutSubviews
{
    [ super layoutSubviews ];
    
    self.webView.frame = [ self webViewRect ];
}

-(id<SCWebViewDelegate>)delegate
{
    return self.webView.delegate;
}

-(void)setDelegate:(id<SCWebViewDelegate>)delegate
{
    self.webView.delegate = delegate;
}

-(UIScrollView*)scrollView
{
    return [ self.webView scrollView ];
}

-(void)loadURL:( NSURL* )url_
{
    [ self.webView loadURL: url_ ];
}

-(void)loadURLWithString:( NSString* )url_string_
{
    [ self.webView loadURLWithString: url_string_ ];
}

-(void)loadHTMLString:( NSString* )string_ baseURL:( NSURL* )baseURL_
{
    [ self.webView loadHTMLString: string_ baseURL: baseURL_ ];
}

-(void)loadRequest:( NSURLRequest* )request_
{
    [ self.webView loadRequest: request_ ];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL
{
    [ self.webView loadData: data
                   MIMEType: MIMEType
           textEncodingName: textEncodingName
                    baseURL: baseURL ];
}

-(NSURLRequest*)request
{
    return self.webView.request;
}

-(void)reload
{
    [ self.webView reload ];
}

-(void)stopLoading
{
    [ self.webView stopLoading ];
}

-(void)goBack
{
    [ self.webView goBack ];
}

-(void)goForward
{
    [ self.webView goForward ];
}

-(BOOL)canGoBack
{
    return [ self.webView canGoBack ];
}

-(BOOL)canGoForward
{
    return [ self.webView canGoForward ];
}

-(BOOL)isLoading
{
    return [ self.webView isLoading ];
}

-(NSString *)stringByEvaluatingJavaScriptFromString:( NSString* )script
{
    return [ self.webView stringByEvaluatingJavaScriptFromString: script ];
}

-(id)forwardingTargetForSelector:( SEL )aSelector
{
    return self.webView;
}

#pragma mark SCWebBrowserToolbarDelegate

-(void)goBackWebBrowserNavigator:( SCNavigationHeader* )header_
{
    [ self.webView goBack ];
}

-(void)goForwardWebBrowserNavigator:( SCNavigationHeader* )header_
{
    [ self.webView goForward ];
}

#pragma mark SCWebViewDelegate

-(void)webViewDidStartLoad:( SCWebView* )web_view_
{
    if ( [ self.navigationHeader respondsToSelector: @selector( didStartLoadingWebBrowser: ) ] )
        [ self.navigationHeader didStartLoadingWebBrowser: self ];
}

-(void)webViewDidFinishLoad:( SCWebView* )web_view_
{
    if ( [ self.navigationHeader respondsToSelector: @selector( didStopLoadingWebBrowser: ) ] )
        [ self.navigationHeader didStopLoadingWebBrowser: self ];
}

-(void)webView:( SCWebView* )web_view_ didFailLoadWithError:( NSError* )error_
{
    if ( [ self.navigationHeader respondsToSelector: @selector( didStopLoadingWebBrowser: ) ] )
        [ self.navigationHeader didStopLoadingWebBrowser: self ];
}

@end
