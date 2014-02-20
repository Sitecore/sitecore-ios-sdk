#import "SCMapViewLogic.h"

#import "SCPlacemark.h"
#import "SCMapKitLocationUtils.h"
#import "SCGoogleAPI.h"

#import <MapKit/MapKit.h>

@interface NSObject (SCMapViewLogic)

-(MKAnnotationView*)annotationViewForMapView:( MKMapView* )mapView_;

-(void)didTappedCalloutAccessoryControl:( UIControl* )control_
                         annotationView:( MKAnnotationView* )annotationView_ 
                                mapView:( MKMapView* )mapView_;

@end

@implementation SCMapViewLogic
{
@private
    MKMapView* _mapView;

@private
    NSArray*        _placeMarks;
    CLLocation*     _selfLocation;
    MKPolyline*     _routeLine;
    MKPolylineView* _routeLineView;
    
@private
    Class _MKDirectionsClass;
    Class _MKDirectionsRequestClass;
    Class _MKDirectionsResponseClass;
}

static const double DEFAULT_REGION_RADIUS = 10000.;

-(id)initWithMapView:( MKMapView* )mapView_
{
    self = [ super init ];

    if ( self )
    {
        self->_mapView                   = mapView_;
        self->_mapView.showsUserLocation = YES;
        self->_drawRouteToNearestAddress = YES;
        self->_selfLocation = self->_mapView.userLocation.location;
        [ self initialize ];
    }

    return self;
}

-(void)initialize
{
    self->_MKDirectionsClass         = NSClassFromString( @"MKDirections" );
    self->_MKDirectionsRequestClass  = NSClassFromString( @"MKDirectionsRequest" );
    self->_MKDirectionsResponseClass = NSClassFromString( @"MKDirectionsResponse" );
    
    self.regionIsAdjusted = NO;
    self.regionRadius = DEFAULT_REGION_RADIUS;
}

-(void)adjustRegion
{
    if ( !self.regionIsAdjusted )
    {
        CLLocation* startLocation_;
        CLLocation* endLocation_;
        CLLocationCoordinate2D center_;
        MKCoordinateSpan span_;
        MKCoordinateRegion viewRegion_;

        if ( !self->_selfLocation )
        {
            [ self adjustRegionJustForAdresses ];
            return;
        }

        if ( [ self->_placeMarks count ] > 0 && ( self->_drawRouteToNearestAddress ))
        {
            
            startLocation_ = self->_selfLocation;
            endLocation_   = [ self nearestPlaceMarkLocationFromLocation: self->_selfLocation ];
            
            center_ = CLLocationCoordinate2DMake( (  startLocation_.coordinate.latitude  + endLocation_.coordinate.latitude  ) / 2.0
                                                 , ( startLocation_.coordinate.longitude + endLocation_.coordinate.longitude ) / 2.0 );
            
            span_ = MKCoordinateSpanMake( fabs( startLocation_.coordinate.latitude  - endLocation_.coordinate.latitude  ) * 1.04
                                         ,fabs( startLocation_.coordinate.longitude - endLocation_.coordinate.longitude ) * 1.04 );
            
            viewRegion_ = MKCoordinateRegionMake( center_, span_ );
        }
        else
        {
            center_ = self->_selfLocation.coordinate;
            viewRegion_ = MKCoordinateRegionMakeWithDistance(
                                                            center_,
                                                             self->_regionRadius, self->_regionRadius
                                                            );
        }

        MKCoordinateRegion adjustedRegion = [ self->_mapView regionThatFits:viewRegion_ ];

        if ( [ self isRegionValid: adjustedRegion ] )
        {
            [ self->_mapView setRegion: adjustedRegion animated: YES ];
        }
        else
        {
            [ self adjustDefaultRegion ];
        }
        
    }
}

-(void)adjustDefaultRegion
{
    CLLocationCoordinate2D center_ = self->_mapView.userLocation.coordinate;
    
    MKCoordinateRegion viewRegion_ = MKCoordinateRegionMakeWithDistance(
                                                     center_,
                                                     DEFAULT_REGION_RADIUS, DEFAULT_REGION_RADIUS
                                                     );
    
    MKCoordinateRegion adjustedRegion = [ self->_mapView regionThatFits:viewRegion_ ];

    if ( [ self isRegionValid: adjustedRegion ] )
    {
        [ self->_mapView setRegion: adjustedRegion animated: YES ];
    }
}

-(BOOL)isRegionValid:(MKCoordinateRegion)region
{
    BOOL centerCoordsIsValid = CLLocationCoordinate2DIsValid( region.center );
    
    BOOL spanIsValid =   ( -180.0f < region.span.latitudeDelta && region.span.latitudeDelta < 180.0f )
                      && ( -180.0f < region.span.longitudeDelta && region.span.longitudeDelta < 180.0f );
    
    return spanIsValid && centerCoordsIsValid;
}

-(void)adjustRegionJustForAdresses
{
    CLLocation* startLocation_;
    CLLocation* endLocation_;
    CLLocationCoordinate2D center_;
    MKCoordinateSpan span_;
    MKCoordinateRegion viewRegion_;
    
    if ( [ self->_placeMarks count ] )
    {
        SCPlacemark* firstPlaceMark_ = self->_placeMarks[ 0 ];
        
        CLLocationDegrees minLat_  = firstPlaceMark_.location.coordinate.latitude;
        CLLocationDegrees maxLat_  = firstPlaceMark_.location.coordinate.latitude;
        CLLocationDegrees minLong_ = firstPlaceMark_.location.coordinate.longitude;
        CLLocationDegrees maxLong_ = firstPlaceMark_.location.coordinate.longitude;
        
        for ( SCPlacemark* placeMark_ in self->_placeMarks )
        {
            minLat_  = fmin( minLat_ , placeMark_.location.coordinate.latitude  );
            maxLat_  = fmax( maxLat_ , placeMark_.location.coordinate.latitude  );
            minLong_ = fmin( minLong_, placeMark_.location.coordinate.longitude );
            maxLong_ = fmax( maxLong_, placeMark_.location.coordinate.longitude );
        }
        
        startLocation_ = [ [ CLLocation alloc ] initWithLatitude: minLat_ longitude: minLong_ ];
        endLocation_   = [ [ CLLocation alloc ] initWithLatitude: maxLat_ longitude: maxLong_ ];
        
        center_ = CLLocationCoordinate2DMake( (  startLocation_.coordinate.latitude  + endLocation_.coordinate.latitude  ) / 2.0
                                             , ( startLocation_.coordinate.longitude + endLocation_.coordinate.longitude ) / 2.0 );
        
        span_ = MKCoordinateSpanMake( fabs( startLocation_.coordinate.latitude  - endLocation_.coordinate.latitude  ) * 1.02
                                     ,fabs( startLocation_.coordinate.longitude - endLocation_.coordinate.longitude ) * 1.02 );
        
        viewRegion_ = MKCoordinateRegionMake( center_, span_ );
        
        MKCoordinateRegion adjustedRegion_ = [ self->_mapView regionThatFits: viewRegion_ ];
        
        [ self->_mapView setRegion: adjustedRegion_ animated: YES ];
    }
    else
    {
        NSLog(@"Addresses are not available!!!");
    }
}

-(void)setRegionRadius:( CLLocationDistance )regionRadius_
{
    if ( self->_regionRadius == regionRadius_ )
        return;

    self->_regionRadius = regionRadius_;
    [ self adjustRegion ];
}

-(void)drawPlaceMarks:( NSArray* )placeMarks_
{
    if ( placeMarks_ )
    {
        self->_placeMarks = placeMarks_;
        [ self->_mapView addAnnotations: placeMarks_ ];

        [ self adjustRegion ];
        [ self drawRouteToClosestPlaceMark ];
    }
}

-(JFFDidFinishAsyncOperationHandler)didLoadAddressesHandler
{
    return ^( NSArray* placeMarks_, NSError* error_ )
    {
        [ self drawPlaceMarks: placeMarks_ ];

        if ( self.didLoadedAnnotationsHandler )
            self.didLoadedAnnotationsHandler( placeMarks_, error_ );
    };
}

-(void)addItemsAnnotationsForQuery:( NSString* )query_
                        apiSession:( SCApiSession * )apiSession_
                           handler:( void(^)( NSError* ) )handler_
{
    handler_ = [ handler_ copy ];
    itemAddressesGeocoder( apiSession_, query_ )( nil, nil, ^( NSArray* placeMarks_, NSError* error_ )
    {
        if ( handler_ )
            handler_( error_ );

        [ self didLoadAddressesHandler ]( placeMarks_, error_ );
    } );
}

-(CLLocation*)nearestPlaceMarkLocationFromLocation:( CLLocation* )location_
{
    SCPlacemark *nearestPlacemark = [ self nearestPlaceMarkFromLocation: location_ ];

    return nearestPlacemark.location;
}

-(SCPlacemark*)nearestPlaceMarkFromLocation:( CLLocation* )location_
{
    CLLocation* placeMarksLocation_ = [  (SCPlacemark*)self->_placeMarks[ 0 ] location ];
    
    CLLocationDistance minDistance_ = [ location_ distanceFromLocation: placeMarksLocation_ ];
    SCPlacemark* nearestPlacemark   = (SCPlacemark*)self->_placeMarks[ 0 ];
    
    for ( SCPlacemark* placeMark_ in self->_placeMarks )
    {
        CLLocationDistance distance_ = [ location_ distanceFromLocation: placeMark_.location ];
        if ( distance_ < minDistance_ )
        {
            minDistance_      = distance_;
            nearestPlacemark = placeMark_;
        }
    }
    
    return nearestPlacemark;
}


-(void)hideRouteLineView
{
    if ( self->_routeLine )
    {
        [ self->_mapView removeOverlay: self->_routeLine ];
        self->_routeLine = nil;
    }
}

-(BOOL)shouldDrawRoute
{
    BOOL isLocationSet = ( nil != self->_selfLocation );
    
    BOOL result =
    (
     isLocationSet                    &&
     self->_drawRouteToNearestAddress &&
     [ self->_placeMarks hasElements ]
    );

    return result;
}

-(void)drawRouteToClosestPlaceMark
{
    BOOL shouldDrawRoute = [ self shouldDrawRoute ];
    if ( !shouldDrawRoute )
    {
        return;
    }
    
    
    BOOL nativePAthBuilderIsAvalable = [ ESFeatureAvailabilityChecker isPathBuilderAvailable ];
    if ( nativePAthBuilderIsAvalable )
    {
        [ self buildRouteWithNativeAPI ];
    }
    else
    {
        [ self buildRouteWithGoogleAPI ];
    }
}

-(void)buildRouteWithGoogleAPI
{
    CLLocation* closestMarkPlace_ = [ self nearestPlaceMarkLocationFromLocation: _selfLocation ];
    
    JFFDidFinishAsyncOperationHandler doneCallback_ = ^( NSArray* points_, NSError* error_ )
    {
        CLLocationCoordinate2D coordinates_[ points_.count ];
        
        for ( NSUInteger index_ = 0; index_ < points_.count; ++index_ )
        {
            CLLocation* location_  = points_[ index_ ];
            coordinates_[ index_ ] = location_.coordinate;
        }
        
        [ self hideRouteLineView ];
        
        self->_routeLine = [ MKPolyline polylineWithCoordinates: coordinates_ count: points_.count ];
        
        if ( self->_routeLine )
        {
            [ self->_mapView addOverlay: self->_routeLine ];
        }
    };
    
    CLLocationCoordinate2D destination_ = closestMarkPlace_.coordinate;
    JFFAsyncOperation loader_ = [ SCGoogleAPI routePointsReaderForStartLocation: _selfLocation.coordinate
                                                                    destination: destination_ ];
    loader_( nil, nil, doneCallback_ );

}

-(void)buildRouteWithNativeAPI
{
    NSParameterAssert( NULL != self->_MKDirectionsClass         );
    NSParameterAssert( NULL != self->_MKDirectionsRequestClass  );
    NSParameterAssert( NULL != self->_MKDirectionsResponseClass );
    
    MKPlacemark *currentLocationPlacemark = [ [MKPlacemark alloc] initWithCoordinate: self->_selfLocation.coordinate
                                                                   addressDictionary: nil ];
    SCPlacemark *destinationPlacemark = [ self nearestPlaceMarkFromLocation: self->_selfLocation ];
    
    MKMapItem *sourceItem = [ [MKMapItem alloc] initWithPlacemark: currentLocationPlacemark ];
    MKMapItem *destinationItem = [ [MKMapItem alloc] initWithPlacemark :destinationPlacemark ];
    
    
    id<SC_MKDirectionsRequestProtocol> request = [ [ self->_MKDirectionsRequestClass alloc] init ];
    {
        request.source = sourceItem;
        request.destination = destinationItem;
        request.requestsAlternateRoutes = NO;
    }
    id<SC_MKDirectionsProtocol> directions = [ [self->_MKDirectionsClass alloc] initWithRequest:request ];
    
    [ directions calculateDirectionsWithCompletionHandler:
    ^( id<SC_MKDirectionsResponseProtocol> response, NSError *error )
    {
         if ( !error && [ response.routes count ] > 0 )
         {
             [ self hideRouteLineView ];
             MKRoute *route = response.routes[0];
             self->_routeLine = route.polyline;
             [ self->_mapView addOverlay: self->_routeLine
                                   level: MKOverlayLevelAboveRoads ];
         }
    }];
}

-(void)setDrawRouteToNearestItemAddress:( BOOL )drawRouteToNearestAddress_
{
    if ( self->_drawRouteToNearestAddress == drawRouteToNearestAddress_ )
        return;

    self->_drawRouteToNearestAddress = drawRouteToNearestAddress_;

    if ( drawRouteToNearestAddress_ )
    {
        [ self drawRouteToClosestPlaceMark ];
    }
    else
    {
        [ self hideRouteLineView ];
    }
}

-(void)addAddressesAnnotations:( NSArray* )addresses_
{
    addressDictionariesGeocoder()( addresses_ )( nil, nil, [ self didLoadAddressesHandler ] );
}

-(void)addItemsAnnotationsWithPath:( NSString* )path_
                        apiSession:( SCApiSession * )apiSession_
                           handler:( void(^)( NSError* ) )handler_
{
    handler_ = [ handler_ copy ];
    itemAddressesGeocoderWithPath( apiSession_, path_ )( nil, nil, ^( NSArray* placeMarks_, NSError* error_ )
    {
        if ( handler_ )
            handler_( error_ );
        [ self didLoadAddressesHandler ]( placeMarks_, error_ );
    } );
}

#pragma mark MKMapViewDelegate

-(void)didUpdateUserLocation:( MKUserLocation* )userLocation_
{
    _selfLocation = userLocation_.location;
    
    if ( self->_placeMarks && !self.regionIsAdjusted)
    {
        [ self adjustRegion ];
        
        self.regionIsAdjusted = YES;
        
        [ self drawRouteToClosestPlaceMark ];
    }
}

-(MKAnnotationView*)viewForAnnotation:( id< MKAnnotation > )annotation_
{
    if ( [ annotation_ respondsToSelector: @selector( annotationViewForMapView: ) ] )
    {
        NSObject* annotationObject_ = annotation_;
        return [ annotationObject_ annotationViewForMapView: _mapView ];
    }

    return nil;
}

-(NSArray*)didAddAnnotationViews:( NSArray* )views_
{
    return [ views_ select: ^BOOL( MKAnnotationView* view_ )
    {
        return ![ view_.annotation isKindOfClass: [ SCPlacemark class ] ];
    } ];
}

-(MKOverlayView *)viewForOverlay:( id< MKOverlay > )overlay_
{
    MKOverlayView* overlayView_ = nil;

    if ( overlay_ == self->_routeLine )
    {
        if( self->_routeLineView )
        {
            [ self->_routeLineView removeFromSuperview ];
            self->_routeLineView = nil;
        }

        self->_routeLineView             = [ [ MKPolylineView alloc ] initWithPolyline: self->_routeLine ]; 
        self->_routeLineView.fillColor   = [ UIColor redColor ];
        self->_routeLineView.strokeColor = [ UIColor blueColor ];
        self->_routeLineView.lineWidth   = 7;

        overlayView_ = self->_routeLineView;
    }

    return overlayView_;
}

-(void)didTappedCalloutAccessoryControl:( UIControl* )control_ inAnnotationView:( MKAnnotationView* )view_
{
    SEL selector_ = @selector( didTappedCalloutAccessoryControl:annotationView:mapView: );
    if ( [ view_.annotation respondsToSelector: selector_ ] )
    {
        NSObject* annotationObject_ = view_.annotation;

        [ annotationObject_ didTappedCalloutAccessoryControl: control_
                                              annotationView: view_ 
                                                     mapView: self->_mapView ];
    }
}

@end
