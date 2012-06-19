#import "iPadProductsViewController.h"

#import "iPadDetailsViewController.h"
#import "ProductCell.h"

#import "ProductsViewControllerDelegate.h"

@interface iPadProductsViewController ()

@property ( nonatomic, strong ) NSArray* items;
@property ( nonatomic, strong, readonly ) NSArray* filteredItems;

@property ( nonatomic, strong ) NSString* filter;
@property ( nonatomic, strong ) UIPopoverController* popover;

@end

@implementation iPadProductsViewController

@synthesize tableView
, searchBar
, items
, itemsReader
, filter
, secondViewController
, popover
, delegate;

-(void)splitViewController:( UISplitViewController* )svc
    willHideViewController:( UIViewController* )aViewController
         withBarButtonItem:( UIBarButtonItem* )barButtonItem
      forPopoverController:( UIPopoverController* )pc
{
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Products list";

    iPadDetailsViewController* detailViewController =
      [ svc.viewControllers objectAtIndex:1];
    [ detailViewController showRootPopoverButtonItem: barButtonItem ];
    secondViewController = detailViewController;
    popover = pc;
}

-(void)splitViewController:( UISplitViewController* )svc
    willShowViewController:( UIViewController* )aViewController
 invalidatingBarButtonItem:( UIBarButtonItem* )barButtonItem
{
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    iPadDetailsViewController* detailViewController =
        [ svc.viewControllers objectAtIndex: 1 ];
    [ detailViewController invalidateRootPopoverButtonItem: barButtonItem ];
    secondViewController = detailViewController;
    popover = nil;
}

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    if ( self.itemsReader )
    {
        self.itemsReader( ^( id result_, NSError* error_ )
        {
            if ( !self.isViewLoaded )
                return;

            self.items = result_;
            [ self.tableView reloadData ];
            if ( [ self.items count ] > 0 )
            {
                NSIndexPath *nsip = [NSIndexPath indexPathForRow:0 inSection:0];
                [ self.tableView selectRowAtIndexPath: nsip 
                                             animated: YES 
                                       scrollPosition: UITableViewScrollPositionTop];
                [ self tableView: self.tableView didSelectRowAtIndexPath: nsip ];
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

-(NSArray*)filteredItems
{
    if ( [ self.filter length ] == 0 )
        return self.items;
    return [ self.items select: ^BOOL(SCItem* item_)
    {
        return [ [ item_.displayName lowercaseString ] hasPrefix: [ self.filter lowercaseString ] ];
    } ];
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

   ProductCell* cell_ = (ProductCell*)[tableView_ cellForRowAtIndexPath:indexPath];

   [ popover dismissPopoverAnimated: YES ];

   [ self.delegate productsViewController: self
                     didSelectProductItem: cell_.item ];
}

@end
