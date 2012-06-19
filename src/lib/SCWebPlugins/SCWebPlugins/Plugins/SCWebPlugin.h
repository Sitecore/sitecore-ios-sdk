#import <Foundation/Foundation.h>

@class UIWebView;
@protocol SCWebPluginDelegate;

@protocol SCWebPlugin < NSObject >

@required
+(BOOL)canInitWithRequest:( NSURLRequest* )request_;

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

-(id)initWithRequest:( NSURLRequest* )request_;

@optional
+(NSString*)pluginJavascript;

-(void)didOpenInWebView:( UIWebView* )webView_;
-(void)didClose;

-(void)didReceiveMessage:( NSString* )message_;

-(BOOL)closeWhenBackground;

@end

@protocol SCWebPluginDelegate < NSObject >

@required
-(void)sendMessage:( NSString* )message_;

-(void)close;

@end
