#import <SitecoreMobileJavaScript/SCWebBrowserToolbar.h>

#import <UIKit/UIKit.h>

@interface SCNavigationHeader : UIView <SCWebBrowserToolbar>

@property(nonatomic,weak) id<SCWebBrowserToolbarDelegate> delegate;

@end
