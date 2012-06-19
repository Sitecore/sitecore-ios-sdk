#import "iPadDetailsViewController.h"

@interface iPadDetailsViewController ()

@property ( nonatomic, retain ) UIBarButtonItem* barButtonItem;

@end

@implementation iPadDetailsViewController

@synthesize barButtonItem = _barButtonItem
, toolBar
, webBrowser;

-(void)showRootPopoverButtonItem:( UIBarButtonItem* )barButtonItem
{
    self.barButtonItem = barButtonItem;
    NSMutableArray* itemsArray = [ toolBar.items mutableCopy];
    [ itemsArray insertObject: barButtonItem atIndex: 0 ];
    [ toolBar setItems: itemsArray animated: NO ];
}

-(void)invalidateRootPopoverButtonItem:( UIBarButtonItem* )barButtonItem
{
    self.barButtonItem = nil;
    // Remove the popover button from the toolbar.
    NSMutableArray* itemsArray = [ toolBar.items mutableCopy ];
    [ itemsArray removeObject: barButtonItem ];
    [ toolBar setItems: itemsArray animated: NO ];
}

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    webBrowser.scalesPageToFit = YES;

    if ( self.barButtonItem )
    {
        NSMutableArray* itemsArray = [ toolBar.items mutableCopy];
        [ itemsArray insertObject: self.barButtonItem atIndex: 0 ];
        [ toolBar setItems: itemsArray animated: NO ];
        
        
    }
}

-(void)viewDidUnload
{
    [ super viewDidUnload ];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark ProductsViewControllerDelegate

-(void)productsViewController:( id )sender_
         didSelectProductItem:( SCItem* )item_
{
    NSString* root_path_ = @"http://mobilesdk.sc-demo.net";
    NSString* itemPath = [ root_path_ stringByAppendingString: item_.path];
    NSLog( @"select itemPath: %@", itemPath );
    [ webBrowser loadURLWithString: itemPath ];
    [ webBrowser layoutSubviews ];
}


@end
