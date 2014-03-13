//
//  SCWebBrowserDelegate.h
//  SCWebBrowserDelegate
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCWebBrowser;

@protocol SCWebBrowserDelegate <NSObject>

@optional
/**
 This method is alias to -[SCWebViewDelegate webView:shouldStartLoadWithRequest:navigationType:] method.
 */
- (BOOL)webView:(SCWebBrowser *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
/**
 This method is alias to -[SCWebViewDelegate webViewDidStartLoad:] method.
 */
- (void)webViewDidStartLoad:(SCWebBrowser *)webView;
/**
 This method is alias to -[SCWebViewDelegate webViewDidFinishLoad:] method.
 */
- (void)webViewDidFinishLoad:(SCWebBrowser *)webView;
/**
 This method is alias to -[SCWebViewDelegate webView:didFailLoadWithError:] method.
 */
- (void)webView:(SCWebBrowser *)webView didFailLoadWithError:(NSError *)error;

@end
