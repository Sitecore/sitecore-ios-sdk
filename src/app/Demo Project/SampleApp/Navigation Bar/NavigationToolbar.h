#import <UIKit/UIKit.h>

@interface NavigationToolbar : UIView <SCWebBrowserToolbar>

@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UIButton *forwardButton;
@property(nonatomic,strong) UIActivityIndicatorView *activityIndicator;

-(IBAction)goBack:(id)sender;
-(IBAction)goForward:(id)sender;

@end
