#import "SCWebViewContainer.h"

#import "NSURLRequest+isTestDomain.h"

@interface NSString (SCWebViewContainer)

//STODO move to header
-(NSString*)dwFilePath;

@end

@implementation SCWebViewContainer
{
   __strong SCWebView* _webView;

   __strong NSString* _JSToTest;
   __strong NSString* _javascript;
}

-(id)initWithJSResourcePath:( NSString* )path_
                   JSToTest:( NSString* )JSToTest_
{
    self = [ super init ];

    if ( self )
    {
        self->_webView = [ SCWebView new ];
        [ self->_webView addOwnedObject: self ];
       self-> _webView.delegate = self;

        self->_JSToTest = JSToTest_;

        self->_javascript = [ NSString stringWithContentsOfFile: path_
                                                       encoding: NSUTF8StringEncoding
                                                          error: nil ];
    }

    return self;
}

-(void)runJavascript
{
    [ self->_webView loadURLWithString: @"http://mobiledev1ua1.dk.sitecore.net:89/mobilesdk-test-path" ];
}

#pragma mark SCWebViewDelegate

-(void)webViewDidFinishLoad:( SCWebView* )webView_
{
    NSString* jsResult_ = nil;
    jsResult_ = [ _webView stringByEvaluatingJavaScriptFromString: self->_javascript ];
    NSLog(@"webViewDidFinishLoad1 - Result : %@", jsResult_ );
    
    jsResult_ = [ webView_ stringByEvaluatingJavaScriptFromString: self->_JSToTest ];
    NSLog(@"webViewDidFinishLoad2 - Result : %@", jsResult_ );    
}

- (BOOL)webView:(SCWebView *)webView
shouldStartLoadWithRequest:( NSURLRequest* )request_
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [ request_ isTestDomain ] )
    {
        return YES;
    }
    else if ( ![ request_ isUrlMeaningful ] )
    {
        return YES;
    }


    if ( self->_testWebViewRequest( request_ ) )
    {
        [ self->_webView removeOwnedObject: self ];
    }
    return NO;
}

@end

