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
    
    NSInteger _finishLoadInvocationCount;
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
    NSString* testPath = [ TestHostConfig mobileSdkTestPath ];
    [ self->_webView loadURLWithString: testPath ];
}

#pragma mark SCWebViewDelegate

-(void)webViewDidFinishLoad:( SCWebView* )webView_
{
    // First time we come here after [ SCWebView new ]
    // Then we come here after [ self->_webView loadURLWithString: testPath ] and should execute JavaScript
    // We may come here after javascript is executed but we should not run it again
    
    if ( 1 == self->_finishLoadInvocationCount )
    {
        // NSLog( @"---===webViewDidFinishLoad : %d", self->_finishLoadInvocationCount );
        
        NSString* jsResult_ = nil;
        jsResult_ = [ _webView stringByEvaluatingJavaScriptFromString: self->_javascript ];
        NSLog(@"webViewDidFinishLoad1 - Result : %@", jsResult_ );
        
        jsResult_ = [ webView_ stringByEvaluatingJavaScriptFromString: self->_JSToTest ];
        NSLog(@"webViewDidFinishLoad2 - Result : %@", jsResult_ );
    }
    
    ++self->_finishLoadInvocationCount;
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

