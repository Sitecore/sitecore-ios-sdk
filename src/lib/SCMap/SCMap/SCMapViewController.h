#import <CoreLocation/CLLocation.h>

#import <UIKit/UIKit.h>

@class SCMapView;

@interface SCMapViewController : UIViewController

@property ( nonatomic, readonly ) SCMapView* mapView;

@property ( nonatomic ) NSArray* addresses;
@property ( nonatomic ) BOOL drawRoute;
@property ( nonatomic ) CLLocationDistance regionRadius;
@property ( nonatomic ) CLLocationCoordinate2D cameraPosition;
@property ( nonatomic ) CGFloat cameraHeight;
@property ( nonatomic ) CLLocationCoordinate2D viewPointPosition;

-(void)hideMapViewController;

@end

@interface SCMapViewController (TestExtensions)

+(void)setPresentMapViewControllerHendler:( void(^)( SCMapViewController* controller_ ) )handler_;

@end
