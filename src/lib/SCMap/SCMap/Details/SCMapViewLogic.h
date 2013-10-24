#import <Foundation/Foundation.h>

@class SCApiContext;

@interface SCMapViewLogic : NSObject

@property ( nonatomic ) CLLocationDistance regionRadius;
@property ( nonatomic ) BOOL drawRouteToNearestAddress;
@property ( nonatomic ) BOOL regionIsAdjusted;
    
-(id)initWithMapView:( MKMapView* )mapView_;

-(void)addItemsAnnotationsForQuery:( NSString* )query_
                        apiContext:( SCApiContext* )apiContext_
                           handler:( void(^)( NSError* ) )handler_;

-(void)addItemsAnnotationsWithPath:( NSString* )path_
                        apiContext:( SCApiContext* )apiContext_
                           handler:( void(^)( NSError* ) )handler_;

-(void)addAddressesAnnotations:( NSArray* )addresses_;

typedef void (^SCMapViewLogicResultHandler)(NSArray *annotations, NSError *error);
@property (nonatomic,copy) SCMapViewLogicResultHandler didLoadedAnnotationsHandler;

#pragma mark MKMapView delegates

-(void)didUpdateUserLocation:( MKUserLocation* )userLocation_;
-(MKAnnotationView*)viewForAnnotation:( id< MKAnnotation > )annotation_;
-(NSArray*)didAddAnnotationViews:( NSArray* )views_;
-(void)didTappedCalloutAccessoryControl:( UIControl* )control_ inAnnotationView:( MKAnnotationView* )view_;

-(MKOverlayView*)viewForOverlay:( id< MKOverlay > )overlay_;

@end
