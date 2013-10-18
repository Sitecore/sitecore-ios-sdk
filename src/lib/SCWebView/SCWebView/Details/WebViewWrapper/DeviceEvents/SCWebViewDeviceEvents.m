#import "SCWebViewDeviceEvents.h"

@implementation SCWebViewDeviceEvents
{
    UIWebView* _webView;
}

-(void)dealloc
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

-(id)initWithWebView:( UIWebView* )webView_
{
    self = [ super init ];

    if ( self )
    {
        _webView = webView_;

        UIApplication* application_ = [ UIApplication sharedApplication ];
        NSNotificationCenter* notificationCenter_ = [ NSNotificationCenter defaultCenter ];
        [ notificationCenter_ addObserver: self
                                 selector: @selector( didBecomeActive: )
                                     name: UIApplicationDidBecomeActiveNotification
                                   object: application_ ];
        [ notificationCenter_ addObserver: self
                                 selector: @selector( willResignActive: )
                                     name: UIApplicationDidEnterBackgroundNotification
                                   object: application_ ];
    }

    return self;
}

-(void)didBecomeActive:( NSNotification* )notification_
{
    [ _webView stringByEvaluatingJavaScriptFromString: @"scmobile.device.__fireResume()" ];
}

-(void)willResignActive:( NSNotification* )notification_
{
    [ _webView stringByEvaluatingJavaScriptFromString: @"scmobile.device.__firePause()" ];
}

@end
