#import "SCMapViewLogic.h"

#import "SCPlacemark.h"
#import "SCMapKitLocationUtils.h"
#import "SCGoogleAPI.h"

@interface NSObject (SCMapViewLogic)

-(MKAnnotationView*)annotationViewForMapView:( MKMapView* )mapView_;

-(void)didTappedCalloutAccessoryControl:( UIControl* )control_
                         annotationView:( MKAnnotationView* )annotationView_ 
                                mapView:( MKMapView* )mapView_;

@end

@interface SCMapViewLogic ()
{
    NSArray*        _placeMarks;
    CLLocation*     _selfLocation;
    MKPolyline*     _routeLine;
    MKPolylineView* _routeLineView;
}

@end

@implementation SCMapViewLogic
{
    MKMapView* _mapView;
}

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
    self.regionRadius = 100000000.;
}

-(void)adjustRegion
{
    ///eul algorith is correct please see
    // http://stackoverflow.com/questions/1336370/positioning-mkmapview-to-show-multiple-annotations-at-once

    CLLocation* startLocation_;
    CLLocation* endLocation_;

    if ( [ self->_placeMarks count ] > 0 )
    {
        if ( !self->_selfLocation )
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
        }
        else if ( self->_drawRouteToNearestAddress )
        {
            startLocation_ = self->_selfLocation;
            endLocation_   = [ self nearestPlaceMarkLocationFromLocation: self->_selfLocation ];
        }
    }

    CLLocationCoordinate2D center_ = CLLocationCoordinate2DMake( (  startLocation_.coordinate.latitude  + endLocation_.coordinate.latitude  ) / 2.0
                                                                , ( startLocation_.coordinate.longitude + endLocation_.coordinate.longitude ) / 2.0 );

    MKCoordinateSpan span_ = MKCoordinateSpanMake( fabs( startLocation_.coordinate.latitude  - endLocation_.coordinate.latitude  ) * 1.02
                                                  ,fabs( startLocation_.coordinate.longitude - endLocation_.coordinate.longitude ) * 1.02 );

    MKCoordinateRegion viewRegion_     = MKCoordinateRegionMake( center_, span_ );
    MKCoordinateRegion adjustedRegion_ = [ self->_mapView regionThatFits: viewRegion_ ];

    [ self->_mapView setRegion: adjustedRegion_ animated: YES ];

    ///eul alternative algorith to cheack result
    //    CLLocationCoordinate2D points[2] = {startLocation_.coordinate, endLocation_.coordinate};
    //    MKPolygon *poly = [MKPolygon polygonWithCoordinates:points count:2];
    //    [_mapView setRegion:MKCoordinateRegionForMapRect([poly boundingMapRect])];
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
                        apiContext:( SCApiContext* )apiContext_
                           handler:( void(^)( NSError* ) )handler_
{
    handler_ = [ handler_ copy ];
    itemAddressesGeocoder( apiContext_, query_ )( nil, nil, ^( NSArray* placeMarks_, NSError* error_ )
    {
        if ( handler_ )
            handler_( error_ );

        [ self didLoadAddressesHandler ]( placeMarks_, error_ );
    } );
}

-(CLLocation*)nearestPlaceMarkLocationFromLocation:( CLLocation* )location_
{
    CLLocation* placeMarksLocation_ = [ self->_placeMarks[ 0 ] location ];

    CLLocationDistance minDistance_ = [ location_ distanceFromLocation: placeMarksLocation_ ];
    CLLocation* nearestLoacation_   = [ self->_placeMarks[ 0 ] location ];

    for ( SCPlacemark* placeMark_ in self->_placeMarks )
    {
        CLLocationDistance distance_ = [ location_ distanceFromLocation: placeMark_.location ];
        if ( distance_ < minDistance_ )
        {
            minDistance_      = distance_;
            nearestLoacation_ = placeMark_.location;
        }
    }

    return nearestLoacation_;
}

-(void)hideRouteLineView
{
    if ( self->_routeLine )
    {
        [ self->_mapView removeOverlay: self->_routeLine ];
        self->_routeLine = nil;
    }
}

-(void)drawRouteToClosestPlaceMark
{
    if ( [ self->_placeMarks count ] == 0
        || !self->_selfLocation
        /*|| !self->_drawRouteToNearestAddress*/ )
        return;

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
                        apiContext:( SCApiContext* )apiContext_
                           handler:( void(^)( NSError* ) )handler_
{
    handler_ = [ handler_ copy ];
    itemAddressesGeocoderWithPath( apiContext_, path_ )( nil, nil, ^( NSArray* placeMarks_, NSError* error_ )
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

    [ self adjustRegion ];    

    [ self drawRouteToClosestPlaceMark ];
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
