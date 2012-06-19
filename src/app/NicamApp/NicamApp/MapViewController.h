#import <UIKit/UIKit.h>

@class SCMapView;

@interface MapViewController : UIViewController < SCMapViewDelegate >

@property (nonatomic, weak) IBOutlet SCMapView* mapView;

@end

