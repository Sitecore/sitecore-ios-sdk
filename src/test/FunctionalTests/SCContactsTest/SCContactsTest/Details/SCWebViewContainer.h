#import <Foundation/Foundation.h>

typedef BOOL (^TestWebViewRequest)( NSURLRequest* request_ );

@interface SCWebViewContainer : NSObject < SCWebViewDelegate >

@property ( nonatomic, copy ) TestWebViewRequest testWebViewRequest;

-(id)initWithJSResourcePath:( NSString* )path_
                   JSToTest:( NSString* )JSToTest_;

-(void)runJavascript;

@end
