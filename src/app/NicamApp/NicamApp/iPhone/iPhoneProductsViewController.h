#import <UIKit/UIKit.h>

@class DetailsViewController;
@protocol ProductsViewControllerDelegate;

@interface iPhoneProductsViewController: UIViewController
<
UISearchBarDelegate
, UITableViewDelegate
, UITableViewDataSource
>

@property ( nonatomic, weak ) IBOutlet UITableView* tableView;
@property ( nonatomic, weak ) IBOutlet UISearchBar* searchBar;
@property ( nonatomic, copy ) SCAsyncOp itemsReader;

@end
