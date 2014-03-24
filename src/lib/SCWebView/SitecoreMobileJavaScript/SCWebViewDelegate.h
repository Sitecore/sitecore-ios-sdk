//
//  SCWebViewDelegate.h
//  SCWebViewDelegate
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCWebView;



/**
 The SCWebViewDelegate protocol defines methods that a delegate of the SCWebView can optionally implement to intervene when web content is loaded.
 */
@protocol SCWebViewDelegate <NSObject>



@optional
/**
 This method is an alias to -[UIWebViewDelegate webView:shouldStartLoadWithRequest:navigationType:] method.
 
 @param webView The web view that is about to load a new frame. This object invokes the selector.
 @param request The content location.
 @param navigationType The type of user action that started the load request.
 */
- (BOOL)webView:(SCWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType;



/**
 This method is alias to -[UIWebViewDelegate webViewDidStartLoad:] method.
 
  @param webView The web view that has begun loading a new frame.
 */
- (void)webViewDidStartLoad:(SCWebView *)webView;


/**
 This method is alias to -[UIWebViewDelegate webViewDidFinishLoad:] method.
 
  @param webView The web view has finished loading.
 */
- (void)webViewDidFinishLoad:(SCWebView *)webView;


/**
 This method is alias to -[UIWebViewDelegate webView:didFailLoadWithError:] method.
 
  @param webView The web view that failed to load a frame.
  @param error The error that occurred during loading.
 */
- (void)webView:(SCWebView *)webView didFailLoadWithError:(NSError *)error;

@end
