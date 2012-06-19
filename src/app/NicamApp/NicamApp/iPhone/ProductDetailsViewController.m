#import "ProductDetailsViewController.h"

@implementation ProductDetailsViewController

@synthesize webBrowser;

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    [ self.webBrowser setCustomToollbarView: nil ];
    webBrowser.scalesPageToFit = YES;
}

-(void)viewDidUnload
{
    [ super viewDidUnload ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark ProductsViewControllerDelegate

-(void)productsViewController:( id )sender_
         didSelectProductItem:( SCItem* )item_
{
    NSString* root_path_ = @"http://mobilesdk.sc-demo.net";
    NSString* itemPath = [root_path_ stringByAppendingString: item_.path];

    [ webBrowser loadURLWithString: itemPath ];
    [ webBrowser layoutSubviews ];
    self.title = item_.displayName;
}

@end
