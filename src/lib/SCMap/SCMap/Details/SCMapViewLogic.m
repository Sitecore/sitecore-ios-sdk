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

@synthesize regionRadius                = _regionRadius;
@synthesize drawRouteToNearestAddress   = _drawRouteToNearestAddress;
@synthesize didLoadedAnnotationsHandler = _didLoadedAnnotationsHandler;

-(id)initWithMapView:( MKMapView* )mapView_
{
    self = [ super init ];

    if ( self )
    {
        _mapView                   = mapView_;
        _mapView.showsUserLocation = YES;
        _drawRouteToNearestAddress = YES;
        _selfLocation = _mapView.userLocation.location;
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

    if ( [ _placeMarks count ] > 0 )
    {
        if ( !_selfLocation )
        {
            SCPlacemark* firstPlaceMark_ = [ _placeMarks objectAtIndex: 0 ];

            CLLocationDegrees minLat_  = firstPlaceMark_.location.coordinate.latitude;
            CLLocationDegrees maxLat_  = firstPlaceMark_.location.coordinate.latitude;
            CLLocationDegrees minLong_ = firstPlaceMark_.location.coordinate.longitude;
            CLLocationDegrees maxLong_ = firstPlaceMark_.location.coordinate.longitude;

            for ( SCPlacemark* placeMark_ in _placeMarks )
            {
                minLat_  = fmin( minLat_ , placeMark_.location.coordinate.latitude  );
                maxLat_  = fmax( maxLat_ , placeMark_.location.coordinate.latitude  );
                minLong_ = fmin( minLong_, placeMark_.location.coordinate.longitude );
                maxLong_ = fmax( maxLong_, placeMark_.location.coordinate.longitude );
            }

            startLocation_ = [ [ CLLocation alloc ] initWithLatitude: minLat_ longitude: minLong_ ];
            endLocation_   = [ [ CLLocation alloc ] initWithLatitude: maxLat_ longitude: maxLong_ ];
        }
        else if ( _drawRouteToNearestAddress )
        {
            startLocation_ =_selfLocation;
            endLocation_   = [ self nearestPlaceMarkLocationFromLocation: _selfLocation ];
        }
    }

    CLLocationCoordinate2D center_ = CLLocationCoordinate2DMake( (  startLocation_.coordinate.latitude  + endLocation_.coordinate.latitude  ) / 2.0
                                                                , ( startLocation_.coordinate.longitude + endLocation_.coordinate.longitude ) / 2.0 );

    MKCoordinateSpan span_ = MKCoordinateSpanMake( fabs( startLocation_.coordinate.latitude  - endLocation_.coordinate.latitude  ) * 1.02
                                                  ,fabs( startLocation_.coordinate.longitude - endLocation_.coordinate.longitude ) * 1.02 );

    MKCoordinateRegion viewRegion_     = MKCoordinateRegionMake( center_, span_ );
    MKCoordinateRegion adjustedRegion_ = [ _mapView regionThatFits: viewRegion_ ];

    [ _mapView setRegion: adjustedRegion_ animated: YES ];

    ///eul alternative algorith to cheack result
    //    CLLocationCoordinate2D points[2] = {startLocation_.coordinate, endLocation_.coordinate};
    //    MKPolygon *poly = [MKPolygon polygonWithCoordinates:points count:2];
    //    [_mapView setRegion:MKCoordinateRegionForMapRect([poly boundingMapRect])];
}

-(void)setRegionRadius:( CLLocationDistance )regionRadius_
{
    if ( _regionRadius == regionRadius_ )
        return;

    _regionRadius = regionRadius_;
    [ self adjustRegion ];
}

-(void)drawPlaceMarks:( NSArray* )placeMarks_
{
    if ( placeMarks_ )
    {
        _placeMarks = placeMarks_;
        [ _mapView addAnnotations: placeMarks_ ];

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
    CLLocation* placeMarksLocation_ = [ [ _placeMarks objectAtIndex: 0 ] location ];

    CLLocationDistance minDistance_ = [ location_ distanceFromLocation: placeMarksLocation_ ];
    CLLocation* nearestLoacation_   = [ [ _placeMarks objectAtIndex: 0 ] location ];

    for ( SCPlacemark* placeMark_ in _placeMarks )
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
    if ( _routeLine )
    {
        [ _mapView removeOverlay: _routeLine ];
        _routeLine = nil;
    }
}

-(void)drawRouteToClosestPlaceMark
{
    if ( [ _placeMarks count ] == 0
        || !_selfLocation
        /*|| !_drawRouteToNearestAddress*/ )
        return;

    CLLocation* closestMarkPlace_ = [ self nearestPlaceMarkLocationFromLocation: _selfLocation ];

    JFFDidFinishAsyncOperationHandler doneCallback_ = ^( NSArray* points_, NSError* error_ )
    {
        CLLocationCoordinate2D coordinates_[ points_.count ];

        for ( NSUInteger index_ = 0; index_ < points_.count; ++index_ )
        {
            CLLocation* location_  = [ points_ objectAtIndex: index_ ];
            coordinates_[ index_ ] = location_.coordinate;
        }

        [ self hideRouteLineView ];

        _routeLine = [ MKPolyline polylineWithCoordinates: coordinates_ count: points_.count ];

        if ( _routeLine )
        {
            [ _mapView addOverlay: _routeLine ];
        }
    };

    CLLocationCoordinate2D destination_ = closestMarkPlace_.coordinate;
    JFFAsyncOperation loader_ = [ SCGoogleAPI routePointsReaderForStartLocation: _selfLocation.coordinate 
                                                                    destination: destination_ ];
    loader_( nil, nil, doneCallback_ );
}

-(void)setDrawRouteToNearestItemAddress:( BOOL )drawRouteToNearestAddress_
{
    if ( _drawRouteToNearestAddress == drawRouteToNearestAddress_ )
        return;

    _drawRouteToNearestAddress = drawRouteToNearestAddress_;

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

    if ( overlay_ == _routeLine )
    {
        if( _routeLineView )
        {
            [ _routeLineView removeFromSuperview ];
            _routeLineView = nil;
        }

        _routeLineView             = [ [ MKPolylineView alloc ] initWithPolyline: _routeLine ]; 
        _routeLineView.fillColor   = [ UIColor redColor ];
        _routeLineView.strokeColor = [ UIColor blueColor ];
        _routeLineView.lineWidth   = 7;

		overlayView_ = _routeLineView;
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
                                                     mapView: _mapView ];
    }
}

@end
