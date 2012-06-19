#import <UIKit/UIKit.h>

@interface UIPopoverController (PresentPopoverInWebView)

- (void)presentPopoverFromRect:(CGRect)rect
                     inWebView:(UIWebView *)view;

@end
