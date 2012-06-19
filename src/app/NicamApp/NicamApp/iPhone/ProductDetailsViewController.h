#import "ProductsViewControllerDelegate.h"
#import <UIKit/UIKit.h>
@class SCWebBrowser; 
@interface ProductDetailsViewController : UIViewController < ProductsViewControllerDelegate >

@property ( nonatomic, weak ) IBOutlet SCWebBrowser* webBrowser;

@end
