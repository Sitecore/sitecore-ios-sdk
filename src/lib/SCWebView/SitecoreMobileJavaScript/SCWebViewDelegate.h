//
//  SCWebViewDelegate.h
//  SCWebViewDelegate
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCWebView;

@protocol SCWebViewDelegate <NSObject>

@optional
/**
 This method is alias to -[SCWebViewDelegate webView:shouldStartLoadWithRequest:navigationType:] method.
 */
- (BOOL)webView:(SCWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
/**
 This method is alias to -[SCWebViewDelegate webViewDidStartLoad:] method.
 */
- (void)webViewDidStartLoad:(SCWebView *)webView;
/**
 This method is alias to -[SCWebViewDelegate webViewDidFinishLoad:] method.
 */
- (void)webViewDidFinishLoad:(SCWebView *)webView;
/**
 This method is alias to -[SCWebViewDelegate webView:didFailLoadWithError:] method.
 */
- (void)webView:(SCWebView *)webView didFailLoadWithError:(NSError *)error;

@end
