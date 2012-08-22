#import "ViewController.h"
#import "iPadProductsViewController.h"
#import "QRCodeViewController.h"
#import "TabBarController.h"
#import "NavigationToolbar.h"
#import "MapViewController.h"

#import "AppDelegate.h"

@interface BrowserViewController : UIViewController

@property ( nonatomic, retain ) NSString* urlString;

@end

@implementation BrowserViewController

@synthesize urlString;

-(SCWebBrowser*)webView
{
    return (SCWebBrowser*)self.view;
}

-(void)loadView
{
    self.view = [ SCWebBrowser new ];
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    NavigationToolbar *view = [ [ NavigationToolbar alloc ] initWithFrame: CGRectMake(0.f, 0.f, 110.f, 35.f) ];
    [ self.webView setCustomToollbarView: view ];

    NSURL* url = [ NSURL URLWithString: self.urlString ];
    self.webView.scalesPageToFit = YES;
    [ self.webView loadRequest: [ NSURLRequest requestWithURL: url ] ];
}

@end

@implementation ViewController

@synthesize tabController;
@synthesize window = _window;

@synthesize home = _home;
//@synthesize _mainMenu;

+(UIViewController*)CreateTabItemWithTitle:( NSString* )title
                                  withPath:( NSString* )path 
                                  withIcon:( UIImage* )icon
{
    BrowserViewController* vc = [ BrowserViewController new ];
    vc.urlString = path;
    vc.title = title;
    //NSLog( @"Item image path: %@", icon.imagePath );
    vc.tabBarItem.image = icon;

    return vc;
}

-(UIViewController*)productsController
{
    NSString* iPadIdentifier_ = @"ProductsSplitViewController";
    NSString* iPhoneIdentifier_ = @"TableViewController";
    UIViewController* controller_;
    UINavigationController* navController_;
    iPadProductsViewController* firstController_;

    if ( [ [ UIDevice currentDevice ] userInterfaceIdiom ] != UIUserInterfaceIdiomPhone )
    {
        controller_ = (UISplitViewController*)[ self.storyboard instantiateViewControllerWithIdentifier: iPadIdentifier_ ];

        navController_ = [ [ (UISplitViewController*)controller_ viewControllers ] objectAtIndex: 0 ] ;
        firstController_ = (iPadProductsViewController*)[ navController_ topViewController ];
        ((UISplitViewController*)controller_).delegate = firstController_;
        firstController_.delegate = [ [ (UISplitViewController*)controller_ viewControllers ] objectAtIndex: 1 ];
    }
    else
    {
        controller_ = [ self.storyboard instantiateViewControllerWithIdentifier: iPhoneIdentifier_ ];
        firstController_ = (iPadProductsViewController*)controller_;
    }

    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
    request_.request = @"/sitecore/content/Nicam/Products/descendant::*[@@templatename='Product Group']"
    "/child::*[@@templatename!='Product Group' and @@templatename!='RSSTwitterReader']";
    request_.requestType = SCItemReaderRequestQuery;
    request_.fieldNames = [ NSSet setWithObject: @"Image" ];
    SCApiContext* context_ = [ SCApiContext contextWithHost: @"mobilesdk.sc-demo.net/-/item" ];
    firstController_.itemsReader = [ context_ itemsReaderWithRequest: request_ ];

    controller_.title = @"Products";
    [ context_ imageLoaderForSCMediaPath:  @"~/media/Images/icon_photo" ]( ^( id result_, NSError* error_ )
    {
        controller_.tabBarItem.image = result_;
    } );

    return controller_;
}

-(UIViewController*)qrcodeController
{
    NSString* identifier_ = @"QRCodeNavigationController";
    QRCodeViewController* controller_;

    controller_ = (QRCodeViewController*)[ self.storyboard instantiateViewControllerWithIdentifier: identifier_ ];

    controller_.title = @"QR Code";
    controller_.tabBarItem.image = [ UIImage imageNamed: @"QRCode.png" ];

    return controller_;
}

-(UIViewController*)mapController
{
    NSString* identifier_ = @"MapController";
    MapViewController* controller_;

    controller_ = (MapViewController*)[ self.storyboard instantiateViewControllerWithIdentifier: identifier_ ];

    controller_.title = @"Map";
    controller_.tabBarItem.image = [ UIImage imageNamed: @"pin_map.png" ];

    return controller_;
}

-(void)showTabBarControllerWithTabs:( NSArray* )listOfViewControllers
{
    [ self performSegueWithIdentifier: @"test" sender: self ];
    TabBarController* tabBar_ = (TabBarController*)self.presentedViewController;
    NSLog( @"tabBar: %@", tabBar_ );
    [ tabBar_ setViewControllers: listOfViewControllers animated: YES ];
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    NSString* rootPath_ = @"http://mobilesdk.sc-demo.net";
    NSMutableArray* listOfViewControllers = [ NSMutableArray new ];
    NSString* titleFieldName_ = @"Menu title";
    NSString* iconFieldName_  = @"Tab Icon";

    SCApiContext* context_ = [ SCApiContext contextWithHost: @"mobilesdk.sc-demo.net/-/item" ];
    NSSet* fieldsNames_ = [ NSSet setWithObjects: titleFieldName_, iconFieldName_, nil ];
    NSString* itemPath_ = @"/sitecore/content/nicam";

    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: itemPath_
                                                                    fieldsNames: fieldsNames_ ];
    request_.flags = SCItemReaderRequestReadFieldsValues;

    [ context_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_, NSError* error_ )
    {
        if ( error_ )
        {
            NSLog( @"can not read item with path: %@", itemPath_ );
            return;
        }
        SCItem* homeItem_ = [ result_ objectAtIndex: 0 ];
        NSString* path_ = [ rootPath_ stringByAppendingString: homeItem_.path ];
        UIViewController* viewController_ = 
            [ ViewController CreateTabItemWithTitle: [ homeItem_ fieldValueWithName: titleFieldName_ ]
                                           withPath: path_
                                           withIcon: [ homeItem_ fieldValueWithName: iconFieldName_ ] ];
        [ listOfViewControllers addObject: viewController_ ];
        //start read children of home item
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/Nicam/*[@@templatename='Site Section']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames = [ [ NSSet alloc ] initWithObjects: @"Title", iconFieldName_, nil ];                                                                                                                                                                                           
        request_.flags = SCItemReaderRequestReadFieldsValues;

        [ context_ itemsReaderWithRequest: request_ ]( ^( id result, NSError* error_ )
        {
            for( SCItem* item_ in result )
            {
                NSString* path_ = [ rootPath_ stringByAppendingString: item_.path ];
                UIViewController* viewController_ = 
                    [ ViewController CreateTabItemWithTitle: [ item_ fieldValueWithName: @"Title" ]
                                                   withPath: path_
                                                   withIcon: [ item_ fieldValueWithName: iconFieldName_ ] ];
                [ listOfViewControllers addObject: viewController_ ];
            }
            [ listOfViewControllers addObject: [ self productsController ] ];
            [ listOfViewControllers addObject: [ self qrcodeController ] ];
            [ listOfViewControllers addObject: [ self mapController ] ];

            [ self performSelector: @selector( showTabBarControllerWithTabs: )
                        withObject: listOfViewControllers
                        afterDelay: 0.2 ];
        } );
    } );
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(IBAction)showTabBarController:( id )sender_
{
   [ self performSegueWithIdentifier: @"test" sender: self ];
}

@end
