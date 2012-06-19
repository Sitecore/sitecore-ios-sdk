#import "iPhoneProductsViewController.h"
#import "ProductDetailsViewController.h"
#import "ProductCell.h"

#import "ProductsViewControllerDelegate.h"

@class DetailsViewController;
@protocol TableViewControllerDelegate;

@interface iPhoneProductsViewController ()

@property ( nonatomic, strong ) NSString* filter;
@property ( nonatomic, strong ) NSArray* items;
@property ( nonatomic, strong, readonly ) NSArray* filteredItems;

@end

@implementation iPhoneProductsViewController

@synthesize tableView
, searchBar
, itemsReader
, filter
, items;

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    if ( self.itemsReader )
    {
        self.itemsReader( ^( id result_, NSError* error_ )
        {
            if ( self.isViewLoaded )
            {
                self.items = result_;
                [ self.tableView reloadData ];
            }
        } );
    }
}

-(void)viewDidUnload
{
    [ super viewDidUnload ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:( UISearchBar* )searchBar_
{
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar_
{
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_
{
    [ searchBar_ resignFirstResponder ];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.filter = searchText;
    [ self.tableView reloadData ];
}

-(void)searchBarCancelButtonClicked:( UISearchBar* )searchBar_
{
    searchBar_.text = nil;
}

-(NSArray*)filteredItems
{
    if ( [ self.filter length ] == 0 )
        return self.items;
    return [ self.items select: ^BOOL(SCItem* item_)
    {
        return [ [ item_.displayName lowercaseString ] hasPrefix: [ self.filter lowercaseString ] ];
    } ];
}

#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource

-(NSInteger)tableView:( UITableView* )tableView numberOfRowsInSection:( NSInteger )section;
{
    return [ self.items count ] ? [ self.filteredItems count ] : 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

-(UITableViewCell*)tableView:( UITableView* )tableView_
       cellForRowAtIndexPath:( NSIndexPath* )indexPath_
{
    if ( ![ self.items count ] )
        return [ tableView_ dequeueReusableCellWithIdentifier: @"SCLoadingCell" ];

    ProductCell* productCell_ = [ tableView_ dequeueReusableCellWithIdentifier: @"SCProductCell" ];
    //productCell_.delegate = self;

    SCItem* item_ = [ self.filteredItems objectAtIndex: indexPath_.row ];
    [ productCell_ setModel: item_ ];

    return productCell_;
}

- (void)tableView:( UITableView* )tableView_
didSelectRowAtIndexPath:( NSIndexPath* )indexPath
{
    [ self.searchBar resignFirstResponder ];

    if ( ![ self.filteredItems count ] )
        return;

    ProductCell* cell_ = ( ProductCell* )[ tableView_ cellForRowAtIndexPath:indexPath ];

    [ self performSegueWithIdentifier: @"iphone_details" sender: self ];
    ProductDetailsViewController* controller_ = ( ProductDetailsViewController* )[ [ self navigationController ] topViewController ];
    ProductDetailsViewController* presentedController_ = controller_;
    [ presentedController_ productsViewController: self
                             didSelectProductItem: cell_.item ];
}

@end
