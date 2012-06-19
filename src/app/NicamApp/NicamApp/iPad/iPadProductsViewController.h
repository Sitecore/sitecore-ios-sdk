#import <UIKit/UIKit.h>

@class iPadDetailsViewController;
@protocol ProductsViewControllerDelegate;

@interface iPadProductsViewController : UIViewController
   <
      UISearchBarDelegate
      , UITableViewDelegate
      , UITableViewDataSource
      , UISplitViewControllerDelegate
   >

@property ( nonatomic, weak ) IBOutlet UITableView* tableView;
@property ( nonatomic, weak ) IBOutlet UISearchBar* searchBar;
@property ( nonatomic, weak ) IBOutlet iPadDetailsViewController* secondViewController;
@property ( nonatomic, copy ) SCAsyncOp itemsReader;

@property ( nonatomic, weak ) id< ProductsViewControllerDelegate > delegate;


@end
