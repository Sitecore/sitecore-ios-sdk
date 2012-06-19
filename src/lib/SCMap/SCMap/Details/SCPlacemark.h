#import <MapKit/MapKit.h>

@interface SCPlacemark : MKPlacemark

- (id)initWithCoordinate:( CLLocationCoordinate2D )coordinate_
       addressDictionary:( NSDictionary* )addressDictionary_;

-(MKAnnotationView*)annotationViewForMapView:( MKMapView* )mapView_;

-(void)didTappedCalloutAccessoryControl:( UIControl* )control_
                         annotationView:( MKAnnotationView* )annotationView_ 
                                mapView:( MKMapView* )mapView_;

@end
