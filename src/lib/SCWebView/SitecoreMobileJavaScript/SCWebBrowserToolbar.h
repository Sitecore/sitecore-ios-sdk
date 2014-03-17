//
//  SCWebBrowserToolbar.h
//  SCWebBrowserToolbar
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCWebBrowser;
@protocol SCWebBrowserToolbarDelegate;

/**
 The SCWebBrowserToolbar protocol provides interface for [SCWebBrowser setCustomNavigatorView:] method's argument.
 
 SCWebBrowser has simple navigator view and if you need to provide own custom navigator view, please pass UIView object which conforms to SCWebBrowserToolbar protocol.
 */
@protocol SCWebBrowserToolbar <NSObject>

@optional
/**
 You custom navigator view will be provided with delegate object when you set it using [SCWebBrowser setCustomNavigatorView:] method.
 
 SCWebBrowserToolbarDelegate delegate object can be used to load the previous or next location in the back-forward list, see [UIWebView goBack] for details.
 */
@property(nonatomic,weak) id<SCWebBrowserToolbarDelegate> delegate;

/**
 SCWebBrowser calls this method when start loading of site.
 You can use this method to start activity of loading indicator.
 
 @param webBrowser the SCWebBrowser object sender.
 */
- (void)didStartLoadingWebBrowser:(SCWebBrowser *)webBrowser;
/**
 SCWebBrowser calls this method when finish loading of site.
 You can use this method to stop activity of loading indicator.
 
 @param webBrowser the SCWebBrowser object sender.
 */
- (void)didStopLoadingWebBrowser:(SCWebBrowser *)webBrowser;

@end

@protocol SCWebBrowserToolbarDelegate <NSObject>

@required
/**
 Call this method to load the previous location in the back list, see [UIWebView goBack] and [SCWebBrowserToolbar delegate] for details.
 
 @param navigator the SCWebBrowserToolbar object sender.
 */
- (void)goBackWebBrowserNavigator:(id<SCWebBrowserToolbar>)navigator;
/**
 Call this method to load the next location in the forward list, see [UIWebView goForward] and [SCWebBrowserToolbar delegate] for details.
 
 @param navigator the SCWebBrowserToolbar object sender.
 */
- (void)goForwardWebBrowserNavigator:(id<SCWebBrowserToolbar>)navigator;

@end
