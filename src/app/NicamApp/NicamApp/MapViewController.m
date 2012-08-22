#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.regionRadius = 36000;
    mapView.drawRouteToNearestAddress = true;
    
    SCApiContext* context_ = [ SCApiContext contextWithHost: @"mobilesdk.sc-demo.net/-/item" ];
    NSString* query_ = @"/sitecore/content/Mobile SDK Datasource/descendant::*[@@templatename='Mobile Address']";
    //
    [ mapView addItemsAnnotationsForQuery: query_
                               apiContext: context_
                                  handler: ^( NSError* error_ )
     {
         NSLog( @"error: %@", error_ );
     } ];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
