#import <UIKit/UIKit.h>

@class SCItem;
@class SCApiContext;

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIWindow *window;
@property (nonatomic, weak) IBOutlet UITabBarController *tabController;

@property ( nonatomic, strong ) SCItem* home;

- (IBAction)showTabBarController:(id)sender;

@end
