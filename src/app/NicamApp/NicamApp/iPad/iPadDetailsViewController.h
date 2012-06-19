#import "ProductsViewControllerDelegate.h"

#import <UIKit/UIKit.h>

@class SCWebBrowser; 
@interface iPadDetailsViewController : UIViewController < ProductsViewControllerDelegate >

@property ( nonatomic, weak ) IBOutlet UIToolbar* toolBar;
@property ( nonatomic, weak ) IBOutlet SCWebBrowser* webBrowser;

-(void)showRootPopoverButtonItem:( UIBarButtonItem* )barButtonItem;
-(void)invalidateRootPopoverButtonItem:( UIBarButtonItem* )barButtonItem;

@end
