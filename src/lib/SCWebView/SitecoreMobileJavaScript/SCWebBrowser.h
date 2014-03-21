#import <UIKit/UIKit.h>

@protocol SCWebBrowserToolbar;
@protocol SCWebBrowserDelegate;

/**
 The SCWebBrowser object contains SCWebView view and simple navigation bar.
 
 The interface of SCWebBrowser is similar to UIWebView and has the same behaviour. It should be used to open web pages that use sitecore javascript web plug-ins. Otherwise they will not work properly.
 */
@interface SCWebBrowser : UIView

/**
 SCWebBrowser has simple navigation view with back and forward buttons and activity indicator and if you need to provide own custom navigator view, please pass UIView object which conforms to SCWebBrowserToolbar protocol.
 
 @param navigator a custom control that lets the user go back and forward through web pages displayed in the SCWebBrowser. See SCWebBrowserToolbar and SCWebBrowserToolbarDelegate protocols for more details.
 */
-(void)setCustomToollbarView:(UIView< SCWebBrowserToolbar >*)toolbar;

/**
 Activity indicator in the center of browser.
 */
@property(nonatomic,readonly) UIActivityIndicatorView* activityIndicator;

/**
 This property is an alias to -[UIWebView delegate] property.
 */
@property(nonatomic,weak) id<SCWebBrowserDelegate> delegate;

/**
 This property is an alias to -[UIWebView scrollView] property.
 */
@property(nonatomic,readonly) UIScrollView *scrollView;

/**
 This method constructs an URL from the given string and calls the [UIWebView loadURL:] method.
 
```
   NSURL* urlToLoad = [[NSURL alloc]initWithString: urlString];
   [UIWebView loadURL:urlToLoad];
```

 @param urlString string with URL to open by browser
 */
- (void)loadURLWithString:(NSString *)urlString;


/**
 This method is an alias to -[UIWebView loadRequest:] method.
 */
- (void)loadRequest:(NSURLRequest *)request;

/**
 This method is an alias to -[UIWebView loadHTMLString:baseURL:] method.
 */
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;


/**
 This method is an alias to -[UIWebView loadURL:] method.
 */
- (void)loadURL:(NSURL *)url;


/**
 This method is an alias to -[UIWebView loadData:MIMEType:textEncodingName:baseURL:] method.
 */
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;


/**
 This property is an alias to -[UIWebView request] property.
 */
@property(nonatomic,readonly) NSURLRequest *request;


/**
 This method is an alias to -[UIWebView reload] method.
 */
- (void)reload;



/**
 Refresh views
 */
-(void)refreshViews;



/**
 This method is an alias to -[UIWebView stopLoading] method.
 */
- (void)stopLoading;



/**
 This method is an alias to -[UIWebView goBack] method.
 */
- (void)goBack;



/**
 This method is an alias to -[UIWebView goForward] method.
 */
- (void)goForward;

/**
 This property is an alias to -[UIWebView canGoBack] property.
 */
@property(nonatomic,readonly,getter=canGoBack) BOOL canGoBack;



/**
 This property is an alias to -[UIWebView canGoForward] property.
 */
@property(nonatomic,readonly,getter=canGoForward) BOOL canGoForward;


/**
 This property is an alias to -[UIWebView loading] property.
 */
@property(nonatomic,readonly,getter=isLoading) BOOL loading;



/**
 This method is an alias to -[UIWebView stringByEvaluatingJavaScriptFromString:] method.
 */
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;



/**
 This property is an alias to -[UIWebView scalesPageToFit] property.
 */
@property(nonatomic) BOOL scalesPageToFit;



/**
 This property is an alias to -[UIWebView dataDetectorTypes] property.
 */
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes;



/**
 This property is an alias to -[UIWebView allowsInlineMediaPlayback] property.
 
 @return iPhone Safari defaults to NO. iPad Safari defaults to YES
 */
@property (nonatomic) BOOL allowsInlineMediaPlayback;


/**
 This property is an alias to -[UIWebView mediaPlaybackRequiresUserAction] property.
 
 @return iPhone and iPad Safari both default to YES
 */
@property (nonatomic) BOOL mediaPlaybackRequiresUserAction;


/**
 This property is an alias to -[UIWebView mediaPlaybackAllowsAirPlay] property.
 
 @return iPhone and iPad Safari both default to YES
 */
@property (nonatomic) BOOL mediaPlaybackAllowsAirPlay;


@end
