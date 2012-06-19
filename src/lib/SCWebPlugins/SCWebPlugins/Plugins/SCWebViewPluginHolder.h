#import <Foundation/Foundation.h>

@class UIWebView;

@interface SCWebViewPluginHolder : NSObject

@property ( nonatomic, readonly ) NSString* socketGuid;

+(id)webViewPluginHolderForRequest:( NSURLRequest* )request_;

-(void)didOpenInWebView:( UIWebView* )webView_;
-(void)didReceiveMessage:( NSString* )message_;
-(void)didClose;

@end
