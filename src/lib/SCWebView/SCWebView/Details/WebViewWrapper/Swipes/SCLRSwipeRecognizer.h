#import <Foundation/Foundation.h>

@class UIWebView;
@protocol SCLRSwipeRecognizerDelegate;

@interface SCLRSwipeRecognizer : NSObject

-(id)initWithDelegate:( id< SCLRSwipeRecognizerDelegate > )delegate_
                 view:( UIWebView* )view_;

@end
