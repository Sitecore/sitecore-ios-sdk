#import <UIKit/UIKit.h>

@interface UIWebView (SCWebViewPlugins)

-(void)enableSCWebViewPlugins;

-(BOOL)applyPluginToRequest:( NSURLRequest* )request_;

@end
