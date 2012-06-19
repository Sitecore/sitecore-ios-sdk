#import "SCWebViewSwipes.h"

#import "SCWebViewWrapper.h"
#import "SCLRSwipeRecognizer.h"
#import "SCLRSwipeRecognizerDelegate.h"

@interface SCWebViewSwipes () <  SCLRSwipeRecognizerDelegate >
@end

@implementation SCWebViewSwipes
{
    UIWebView* _webView;
    SCLRSwipeRecognizer* _recognizer;
}

-(id)initWithWebView:( UIWebView* )webView_
{
    self = [ super init ];

    if ( self )
    {
        _webView = webView_;
        _recognizer = [ [ SCLRSwipeRecognizer alloc ] initWithDelegate: self
                                                                  view: _webView ];
    }

    return self;
}

#pragma mark SCLRSwipeRecognizerDelegate

-(void)leftSwipeRecognized:( SCLRSwipeRecognizer* )recognizer_
{
    NSString* javascript_ = @"scmobile.gesture_recognizer.fireSwipeEvent('left')";
    [ _webView stringByEvaluatingJavaScriptFromString: javascript_ ];
}

-(void)rightSwipeRecognized:( SCLRSwipeRecognizer* )recognizer_
{
    NSString* javascript_ = @"scmobile.gesture_recognizer.fireSwipeEvent('right')";
    [ _webView stringByEvaluatingJavaScriptFromString: javascript_ ];
}

@end
