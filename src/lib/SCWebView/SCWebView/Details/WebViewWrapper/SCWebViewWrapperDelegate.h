#import <Foundation/Foundation.h>

@class SCWebViewWrapper;

@protocol SCWebViewWrapperDelegate <NSObject>

@optional
- (BOOL)webView:(SCWebViewWrapper *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(SCWebViewWrapper *)webView;
- (void)webViewDidFinishLoad:(SCWebViewWrapper *)webView;
- (void)webView:(SCWebViewWrapper *)webView didFailLoadWithError:(NSError *)error;

@end
