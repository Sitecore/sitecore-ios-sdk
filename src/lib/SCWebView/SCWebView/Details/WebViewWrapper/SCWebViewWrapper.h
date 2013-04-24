#import <UIKit/UIKit.h>

@protocol SCWebViewWrapperDelegate;

@interface SCWebViewWrapper : UIView

@property(weak,nonatomic) IBOutlet id< SCWebViewWrapperDelegate > delegate;

@property(nonatomic,readonly) UIScrollView *scrollView;

- (void)reload;
-(void)refresh;
- (void)stopLoading;
- (void)goBack;
- (void)goForward;

@property(nonatomic,readonly,getter=canGoBack) BOOL canGoBack;
@property(nonatomic,readonly,getter=canGoForward) BOOL canGoForward;
@property(nonatomic,readonly,getter=isLoading) BOOL loading;

- (void)loadURL:(NSURL *)url;
- (void)loadURLWithString:(NSString *)urlString;
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;

@property(nonatomic,readonly) NSURLRequest *request;

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;

@property(nonatomic) BOOL scalesPageToFit;

-(void)handleMemoryWarning;

@end
