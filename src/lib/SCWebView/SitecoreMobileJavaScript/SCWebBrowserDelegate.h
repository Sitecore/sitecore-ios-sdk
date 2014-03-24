//
//  SCWebBrowserDelegate.h
//  SCWebBrowserDelegate
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCWebBrowser;



/**
 The SCWebBrowserDelegate protocol defines methods that a delegate of the SCWebBrowser can optionally implement to intervene when web content is loaded.
 */
@protocol SCWebBrowserDelegate <NSObject>

@optional
/**
 This method is alias to -[SCWebViewDelegate webView:shouldStartLoadWithRequest:navigationType:] method.
 
 @param webView The web view that is about to load a new frame. This object invokes the selector.
 @param request The content location.
 @param navigationType The type of user action that started the load request.
 */
- (BOOL)webView:(SCWebBrowser *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType;


/**
 This method is alias to -[SCWebViewDelegate webViewDidStartLoad:] method.
 
 @param webView The web view that has begun loading a new frame.
 */
- (void)webViewDidStartLoad:(SCWebBrowser *)webView;


/**
 This method is alias to -[SCWebViewDelegate webViewDidFinishLoad:] method.
 
 @param webView The web view has finished loading.
 */
- (void)webViewDidFinishLoad:(SCWebBrowser *)webView;


/**
 This method is alias to -[SCWebViewDelegate webView:didFailLoadWithError:] method.
 
 @param webView The web view that failed to load a frame.
 @param error The error that occurred during loading.
 */
- (void)webView:(SCWebBrowser *)webView didFailLoadWithError:(NSError *)error;

@end
