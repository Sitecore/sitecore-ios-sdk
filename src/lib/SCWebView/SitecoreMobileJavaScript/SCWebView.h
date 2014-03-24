#import <UIKit/UIKit.h>

@protocol SCWebViewDelegate;

/**
 The SCWebView is a Sitecore WebBrowser which provides javascript API to platform specific functionalities like acceleremoter, email composer and etc.
 
 The interface of SCWebView is similar to UIWebView and has the same behaviour.
 */
@interface SCWebView : UIView


/**
 This property is alias to -[UIWebView delegate] property.
 */
@property(nonatomic,weak) id<SCWebViewDelegate> delegate;


/**
 Activity indicator in the center of browser.
 */
@property(nonatomic,readonly) UIActivityIndicatorView* activityIndicator;



/**
 This property is alias to -[UIWebView scrollView] property.
 */
@property(nonatomic,readonly) UIScrollView *scrollView;



/**
 This method just calls -[UIWebView loadURL:[[NSURL alloc]initWithString: urlString]] method.
 
 @param urlString string with URL to open by browser
 */
- (void)loadURLWithString:(NSString *)urlString;




/**
 This method is alias to -[UIWebView loadRequest:] method.
 
 @param request A URL request identifying the location of the content to load.
 */
- (void)loadRequest:(NSURLRequest *)request;




/**
 This method is alias to -[UIWebView loadHTMLString:baseURL:] method.
 
 @param string The content for the main page.
 @param baseURL The base URL for the content. It will be prepended to all relative hyperlinks.
 */
- (void)loadHTMLString:(NSString *)string
               baseURL:(NSURL *)baseURL;



/**
 This method is an alias to -[UIWebView loadRequest:] method.
 It constructs the request from the URL and loads it in the corresponding UIWebView.
 
 @param url URL of the web page to display
 */
- (void)loadURL:(NSURL *)url;



/**
 This method is an alias to -[UIWebView loadData:MIMEType:textEncodingName:baseURL:] method.
 
 @param data The content for the main page.
 @param MIMEType The MIME type of the content.
 @param textEncodingName The IANA encoding name as in utf-8 or utf-16.
 @param baseURL The base URL for the content.
*/
- (void)loadData:(NSData *)data
        MIMEType:(NSString *)MIMEType
textEncodingName:(NSString *)textEncodingName
         baseURL:(NSURL *)baseURL;



/**
 This property is alias to -[UIWebView request] property.
 */
@property(nonatomic,readonly) NSURLRequest *request;



/**
 This method is alias to -[UIWebView reload] method.
 */
- (void)reload;



/**
 Refresh view.
 */
-(void)refreshViews;



/**
 This method is alias to -[UIWebView stopLoading] method.
 */
- (void)stopLoading;


/**
 This method is alias to -[UIWebView goBack] method.
 */
- (void)goBack;



/**
 This method is alias to -[UIWebView goForward] method.
 */
- (void)goForward;


/**
 This property is alias to -[UIWebView canGoBack] property.
 */
@property(nonatomic,readonly,getter=canGoBack) BOOL canGoBack;




/**
 This property is alias to -[UIWebView canGoForward] property.
 */
@property(nonatomic,readonly,getter=canGoForward) BOOL canGoForward;




/**
 This property is alias to -[UIWebView loading] property.
 */
@property(nonatomic,readonly,getter=isLoading) BOOL loading;



/**
 This method is alias to -[UIWebView stringByEvaluatingJavaScriptFromString:] method.
 
 @param script A string that contains the JavaScript code to execute.
 
 @return The result of running script or nil if it fails.
 */
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;



/**
 This property is alias to -[UIWebView scalesPageToFit] property.
 */
@property(nonatomic) BOOL scalesPageToFit;




/**
 This property is alias to -[UIWebView dataDetectorTypes] property.
 */
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes;




/**
 This property is alias to -[UIWebView allowsInlineMediaPlayback] property.
 
  @return iPhone Safari defaults to NO. iPad Safari defaults to YES
 */
@property (nonatomic) BOOL allowsInlineMediaPlayback;



/**
 This property is alias to -[UIWebView mediaPlaybackRequiresUserAction] property.
 
  @return iPhone and iPad Safari both default to YES
 */
@property (nonatomic) BOOL mediaPlaybackRequiresUserAction;



/**
 This property is alias to -[UIWebView mediaPlaybackAllowsAirPlay] property.
 
  @return iPhone and iPad Safari both default to YES
 */
@property (nonatomic) BOOL mediaPlaybackAllowsAirPlay;



/**
 Used to add string to UIWebView user agent header.
 
 @param userAgentAddition string to add to UIWebView user agent.
 */
+ (void)setUserAgentAddition:(NSString *)userAgentAddition;

@end
