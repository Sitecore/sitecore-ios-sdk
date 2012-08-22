#import "SCWebView.h"

#import "SCWebViewDelegate.h"

#import "SCWebViewWrapper.h"
#import "SCWebViewWrapperDelegate.h"

#import "SCLRSwipeRecognizer.h"
#import "SCLRSwipeRecognizerDelegate.h"

@interface SCWebView () <
SCWebViewWrapperDelegate
, JFFPageSliderDelegate
, SCLRSwipeRecognizerDelegate
>

@property ( nonatomic, readonly ) SCWebViewWrapper* webView;
@property ( nonatomic ) BOOL cachedScalesPageToFit;

@end

@implementation SCWebView
{
    JFFPageSlider* _stripeView;
    NSUInteger _numberOfElements;
    SCLRSwipeRecognizer* _recognizer;
}

@dynamic dataDetectorTypes
, allowsInlineMediaPlayback
, mediaPlaybackRequiresUserAction
, mediaPlaybackAllowsAirPlay
, activityIndicator
, scrollView;

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

-(id)initWithCoder:( NSCoder* )decoder_
{
    self = [ super initWithCoder: decoder_ ];

    if ( self )
    {
        [ self initialize ];
    }

    return self;
}

-(void)initialize
{
    _numberOfElements = 1;

    _stripeView = [ [ JFFPageSlider alloc ] initWithFrame: self.bounds
                                                 delegate: self ];
    [ self addSubviewAndScale: _stripeView ];

    _recognizer = [ [ SCLRSwipeRecognizer alloc ] initWithDelegate: self
                                                              view: (UIWebView*)self ];
}

-(SCWebViewWrapper*)webView
{
    return (SCWebViewWrapper*)[ _stripeView elementAtIndex: _stripeView.activeIndex ];
}

#pragma mark UIWebView proxy methods

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

-(void)loadRequest:(NSURLRequest *)request
{
    [ self.webView loadRequest: request ];
}

-(NSString*)stringByEvaluatingJavaScriptFromString:( NSString* )script_
{
    return [ self.webView stringByEvaluatingJavaScriptFromString: script_ ];
}

-(BOOL)scalesPageToFit
{
    return [ self.webView scalesPageToFit ];
}

- (void)loadData:(NSData *)data
        MIMEType:(NSString *)MIMEType
textEncodingName:(NSString *)textEncodingName
         baseURL:(NSURL *)baseURL
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

-(void)setScalesPageToFit:( BOOL )scalesPageToFit_
{
    self.cachedScalesPageToFit = scalesPageToFit_;
    self.webView.scalesPageToFit = scalesPageToFit_;
}

#pragma mark JFFStripeViewDelegate

-(NSInteger)numberOfElementsInStripeView:( JFFPageSlider* )pageSlider_
{
    return _numberOfElements;
}

-(UIView*)stripeView:( JFFPageSlider* )pageSlider_
      elementAtIndex:( NSInteger )index_
{
    SCWebViewWrapper* webView_ = [ [ SCWebViewWrapper alloc ] initWithFrame: self.bounds ];
    
    webView_.delegate = self;
    webView_.scalesPageToFit = self.cachedScalesPageToFit;
    
    return webView_;
}

-(void)pageSlider:( JFFPageSlider* )pageSlider_
didChangeActiveElementFrom:( NSInteger )previousIndex_
               to:( NSInteger )activeIndex_
{
    UIWebView* webView_ = (UIWebView*)[ pageSlider_ viewAtIndex: previousIndex_ ];
    
    if ( !webView_ )
        return;
    
    UIScrollView* scrollView_ = webView_.scrollView;
    
    if ( scrollView_.contentOffset.x > 0.1f
        || scrollView_.contentOffset.x < -0.1f )
    {
        CGRect rect_ = CGRectMake( 0.f
                                  , 0.f
                                  , webView_.scrollView.contentSize.width
                                  , self.bounds.size.height );
        [ webView_.scrollView zoomToRect: rect_ animated: NO ];
    }
}

-(void)pageSlider:( JFFPageSlider* )pageSlider_
handleMemoryWarningForElementAtIndex:( NSInteger )element_index_
{
    SCWebViewWrapper* webView_ = (SCWebViewWrapper*)[ pageSlider_ viewAtIndex: element_index_ ];
    
    [ webView_ handleMemoryWarning ];
}

#pragma mark Navigation logic

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
    if ( self.webView.canGoBack )
    {
        [ self.webView goBack ];
        return;
    }
    
    [ self slideLeftIfPossible ];
}

-(void)goForward
{
    if ( self.webView.canGoForward )
    {
        [ self.webView goForward ];
        return;
    }
    
    [ self slideRightIfPossible ];
}

-(BOOL)canGoBack
{
    return self.webView.canGoBack || _stripeView.activeIndex > _stripeView.firstIndex;
}

-(BOOL)canGoForward
{
    return self.webView.canGoForward || _stripeView.activeIndex < _stripeView.lastIndex;
}

-(BOOL)isLoading
{
    return [ self.webView isLoading ];
}

-(id)forwardingTargetForSelector:( SEL )aSelector
{
    return self.webView;
}

-(void)loadCorrespondPageWithURL:( NSURL* )url_
{
    if ( url_ )
    {
        [ self loadURL: url_ ];
        return;
    }
    
    if ( [ _delegate respondsToSelector: @selector( webViewDidStartLoad: ) ] )
        [ _delegate webViewDidStartLoad: self ];
    
    if ( !self.webView.isLoading )
    {
        if ( [ _delegate respondsToSelector: @selector( webViewDidFinishLoad: ) ] )
            [ _delegate webViewDidFinishLoad: self ];
    }
}

-(NSURL*)getURLUsingJS:( NSString* )javascript_
{
    NSString* urlString_ = [ self.webView stringByEvaluatingJavaScriptFromString: javascript_ ];
    NSURL* url_ = [ NSURL URLWithString: urlString_ ];
    return [ [ url_ description ] length ] != 0 ? url_ : nil;
}

-(NSURL*)swipeForwardLink
{
    return [ self getURLUsingJS: @"scmobile.navigations.scmForwardLink()" ];
}

-(NSURL*)swipeBackwardLink
{
    return [ self getURLUsingJS: @"scmobile.navigations.scmBackwardLink()" ];
}

-(void)slideToIndex:( NSInteger )index_ url:( NSURL* )url_
{
    [ _stripeView slideToIndex: index_ animated: YES ];
    self.scalesPageToFit = self.cachedScalesPageToFit;
    [ self loadCorrespondPageWithURL: url_ ];
}

-(BOOL)slideLeftIfPossible
{
    if ( _stripeView.activeIndex <= _stripeView.firstIndex )
        return NO;
    
    BOOL added_ = NO;
    NSURL* url_ = nil;
    NSInteger newIndex_ = _stripeView.activeIndex - 1;
    if ( _stripeView.activeIndex <= 0 )
    {
        url_ = [ self swipeBackwardLink ];
        SCWebViewWrapper* previousWebView_ =
        (SCWebViewWrapper*)[ _stripeView viewAtIndex: newIndex_ ];
        if ( ![ url_ isEqual: previousWebView_.request.URL ] )
        {
            added_ = YES;
            JSignedRange range_ = JSignedRangeMake( _stripeView.firstIndex
                                                   , newIndex_ - _stripeView.firstIndex + 1 );
            
            _numberOfElements -= range_.length;
            [ _stripeView removeViewsInRange: range_ ];
        }
    }
    url_ = added_ ? url_ : nil;
    if ( added_ )
    {
        ++_numberOfElements;
        [ _stripeView pushBackElement ];
    }
    [ self slideToIndex: newIndex_ url: url_ ];
    return YES;
}

-(BOOL)slideRightIfPossible
{
    if ( _stripeView.activeIndex >= _stripeView.lastIndex )
        return NO;

    BOOL added_ = NO;
    NSURL* url_ = nil;
    NSInteger newIndex_ = _stripeView.activeIndex + 1;
    if ( _stripeView.activeIndex >= 0 )
    {
        url_ = [ self swipeForwardLink ];
        SCWebViewWrapper* previousWebView_ =
        (SCWebViewWrapper*)[ _stripeView viewAtIndex: newIndex_ ];
        if ( ![ url_ isEqual: previousWebView_.request.URL ] )
        {
            added_ = YES;
            JSignedRange range_ = JSignedRangeMake( newIndex_
                                                   , _stripeView.lastIndex - newIndex_ + 1 );

            _numberOfElements -= range_.length;
            [ _stripeView removeViewsInRange: range_ ];
        }
    }

    url_ = added_ ? url_ : nil;
    if ( added_ )
    {
        ++_numberOfElements;
        [ _stripeView pushFrontElement ];
    }
    [ self slideToIndex: newIndex_ url: url_ ];
    return YES;
}

-(BOOL)callPredicateJSFunction:( NSString* )name_
{
    NSString* hasForwardLink_ = [ self.webView stringByEvaluatingJavaScriptFromString: name_ ];
    return [ hasForwardLink_ isEqualToString: @"true" ];
}

#pragma mark SCLRSwipeRecognizerDelegate

-(void)swipeForward
{
    if ( [ self isLoading ] && _stripeView.activeIndex < _stripeView.lastIndex )
    {
        [ self slideToIndex: _stripeView.activeIndex + 1 url: nil ];
        return;
    }

    if ( [ self callPredicateJSFunction: @"scmobile.navigations.hasSCMForwardLink()" ]
        && [ self slideRightIfPossible ] )
        return;

    NSURL* url_ = [ self swipeForwardLink ];
    if ( url_ )
    {
        ++_numberOfElements;
        [ _stripeView pushFrontElement ];
        [ self slideToIndex: _stripeView.activeIndex + 1 url: url_ ];
    }
}

-(void)leftSwipeRecognized:( SCLRSwipeRecognizer* )recognizer_
{
    [ self swipeForward ];
}

-(void)swipeBack
{
    if ( [ self isLoading ] && _stripeView.activeIndex > _stripeView.firstIndex )
    {
        [ self slideToIndex: _stripeView.activeIndex - 1 url: nil ];
        return;
    }

    if ( [ self callPredicateJSFunction: @"scmobile.navigations.hasSCMBackwardLink()" ]
        && [ self slideLeftIfPossible ] )
        return;

    NSURL* url_ = [ self swipeBackwardLink ];
    if ( url_ )
    {
        ++_numberOfElements;
        [ _stripeView pushBackElement ];
        [ self slideToIndex: _stripeView.activeIndex - 1 url: url_ ];
    }
}

-(void)rightSwipeRecognized:( SCLRSwipeRecognizer* )recognizer_
{
    [ self swipeBack ];
}

#pragma mark SCWebViewWrapperDelegate

-(BOOL)webView:(SCWebViewWrapper *)webView_
shouldStartLoadWithRequest:(NSURLRequest *)request_
navigationType:(UIWebViewNavigationType)navigationType_
{
    if ( self.webView != webView_ )
        return NO;

    if ( [ @"scr" isEqualToString: request_.URL.scheme ] )
    {
        NSString* host_ = request_.URL.host;
        if ( [ @"swipe_back" isEqualToString: host_ ] )
        {
            [ self swipeBack ];
        }
        else if ( [ @"swipe_forward" isEqualToString: host_ ] )
        {
            [ self swipeForward ];
        }
        return NO;
    }

    SEL selector_ = @selector( webView:shouldStartLoadWithRequest:navigationType: );
    if ( [ _delegate respondsToSelector: selector_ ] )
    {
        return [ _delegate webView: self
       shouldStartLoadWithRequest: request_
                   navigationType: navigationType_ ];
    }

    return YES;
}

-(void)webViewDidStartLoad:( SCWebViewWrapper* )webView_
{
    if ( self.webView != webView_ )
        return;

    if ( [ _delegate respondsToSelector: @selector( webViewDidStartLoad: ) ] )
        [ _delegate webViewDidStartLoad: self ];
}

-(BOOL)isFirstPageWebView:( SCWebViewWrapper* )webView_
{
    UIView* firstView_ = self->_stripeView.viewByIndex[ @( _stripeView.firstIndex ) ];
    return firstView_ == webView_;
}

-(BOOL)isLastPageWebView:( SCWebViewWrapper* )webView_
{
    UIView* lastView_ = self->_stripeView.viewByIndex[ @( self->_stripeView.lastIndex ) ];
    return lastView_ == webView_;
}

-(void)webViewDidFinishLoad:( SCWebViewWrapper* )webView_
{
    {
        static NSString* const isFirstPageFormat_ = @"__private_scmobile_is_first_page = %@";
        NSString* isFirstPage_ = [ [ NSString alloc ] initWithFormat: isFirstPageFormat_
                                  , [ self isFirstPageWebView: webView_ ] ? @"true" : @"false" ];
        [ webView_ stringByEvaluatingJavaScriptFromString: isFirstPage_ ];
    }
    {
        static NSString* const isLastPageFormat_ = @"__private_scmobile_is_last_page = %@";
        NSString* isLastPage_ = [ [ NSString alloc ] initWithFormat: isLastPageFormat_
                                 , [ self isLastPageWebView: webView_ ] ? @"true" : @"false" ];
        [ webView_ stringByEvaluatingJavaScriptFromString: isLastPage_ ];
    }

    if ( self.webView != webView_ )
        return;

    if ( [ self->_delegate respondsToSelector: @selector( webViewDidFinishLoad: ) ] )
        [ self->_delegate webViewDidFinishLoad: self ];
}

-(void)webView:( SCWebViewWrapper* )webView_ didFailLoadWithError:( NSError* )error_
{
    if ( self.webView != webView_ )
        return;

    if ( [ self->_delegate respondsToSelector: @selector( webView:didFailLoadWithError: ) ] )
        [ self->_delegate webView: self didFailLoadWithError: error_ ];
}

+(void)setUserAgentAddition:( NSString* )userAgentAddition_
{
    [ UIWebView setUserAgentAddition: userAgentAddition_ ];
}

@end
