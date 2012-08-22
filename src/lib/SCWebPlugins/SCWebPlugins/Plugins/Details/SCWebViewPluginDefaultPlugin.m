#import "SCWebViewPluginDefaultPlugin.h"

@implementation SCWebViewPluginDefaultPlugin

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return YES;
}

-(id)initWithRequest:( NSURLRequest* )request_
{
    return [ super init ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    [ self.delegate close ];
}

@end
