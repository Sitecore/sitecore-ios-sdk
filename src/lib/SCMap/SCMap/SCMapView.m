#import "SCMapView.h"

#import "SCMapViewLogic.h"

@interface SCMapView () < MKMapViewDelegate >

-(void)initialize;

@end

@implementation SCMapView
{
    MKMapView* _mapView;
    SCMapViewLogic* _logic;
    CLLocationDistance _regionRadius;
}

@synthesize delegate = _delegate;

@dynamic mapType
, region
, centerCoordinate
, visibleMapRect
, zoomEnabled
, scrollEnabled
, showsUserLocation
, userLocation
, userTrackingMode
, userLocationVisible
, annotations
, selectedAnnotations
, annotationVisibleRect;

-(void)dealloc
{
    _mapView.delegate = nil;
}

-(id)initWithFrame:( CGRect )frame_
{
    self = [ super initWithFrame: frame_ ];

    if ( self )
    {
        [ self initialize ];
    }

    return self;
}

-(id)initWithCoder:( NSCoder* )decoder_
{
    self = [ super initWithCoder: decoder_ ];

    if ( self )
    {
        [ self initialize ];
    }

    return self;
}

-(void)initialize
{
    _mapView = [ [ MKMapView alloc ] initWithFrame: self.frame ];
    _mapView.delegate = self;
    [ self addSubviewAndScale: _mapView ];

    _logic = [ [ SCMapViewLogic alloc ] initWithMapView: _mapView ];
}

-(id)forwardingTargetForSelector:( SEL )aSelector
{
    return _mapView;
}

- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated
{
    [ _mapView setRegion: region animated: animated ];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated
{
    [ _mapView setCenterCoordinate: coordinate animated: animated ];
}

- (MKCoordinateRegion)regionThatFits:(MKCoordinateRegion)region
{
    return [ _mapView regionThatFits: region ];
}

- (void)setVisibleMapRect:(MKMapRect)mapRect animated:(BOOL)animate
{
    [ _mapView setVisibleMapRect: mapRect animated: animate ];
}

- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect
{
    return [ _mapView mapRectThatFits: mapRect ];
}

- (void)setVisibleMapRect:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate
{
    [ _mapView setVisibleMapRect: mapRect edgePadding: insets animated: animate ];
}

- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets
{
    return [ _mapView mapRectThatFits: mapRect edgePadding: insets ];
}

- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view
{
    return [ _mapView convertCoordinate: coordinate toPointToView: view ];
}

- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view
{
    return [ _mapView convertPoint: point toCoordinateFromView: view ];
}

- (CGRect)convertRegion:(MKCoordinateRegion)region toRectToView:(UIView *)view
{
    return [ _mapView convertRegion: region toRectToView: view ];
}

- (MKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view
{
    return [ _mapView convertRect: rect toRegionFromView: view ];
}

- (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    [ _mapView setUserTrackingMode: mode animated: animated ];
}

- (void)addAnnotation:(id <MKAnnotation>)annotation
{
    [ _mapView addAnnotation: annotation ];
}

- (void)addAnnotations:(NSArray *)annotations
{
    [ _mapView addAnnotations: annotations ];
}

- (void)removeAnnotation:(id <MKAnnotation>)annotation
{
    [ _mapView removeAnnotation: annotation ];
}

- (void)removeAnnotations:(NSArray *)annotations
{
    [ _mapView removeAnnotations: annotations ];
}

-(NSSet*)annotationsInMapRect:( MKMapRect )mapRect_
{
    return [ _mapView annotationsInMapRect: mapRect_ ];
}

- (MKAnnotationView *)viewForAnnotation:(id< MKAnnotation >)annotation
{
    return [ _mapView viewForAnnotation: annotation ];
}

- (MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier
{
    return [ _mapView dequeueReusableAnnotationViewWithIdentifier: identifier ];
}

- (void)selectAnnotation:(id <MKAnnotation>)annotation animated:(BOOL)animated
{
    [ _mapView selectAnnotation: annotation animated: animated ];
}

- (void)deselectAnnotation:(id <MKAnnotation>)annotation animated:(BOOL)animated
{
    [ _mapView deselectAnnotation: annotation animated: animated ];
}

#pragma mark MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if ( [ self.delegate respondsToSelector: @selector( mapView:regionWillChangeAnimated: ) ] )
        [ self.delegate mapView: self regionWillChangeAnimated: animated ];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ( [ self.delegate respondsToSelector: @selector( mapView:regionDidChangeAnimated: ) ] )
        [ self.delegate mapView: self regionDidChangeAnimated: animated ];
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    if ( [ self.delegate respondsToSelector: @selector( mapViewWillStartLoadingMap: ) ] )
        [ self.delegate mapViewWillStartLoadingMap: self ];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if ( [ self.delegate respondsToSelector: @selector( mapViewDidFinishLoadingMap: ) ] )
        [ self.delegate mapViewDidFinishLoadingMap: self ];
}

-(void)mapViewDidFailLoadingMap:( MKMapView* )mapView_ withError:( NSError* )error_
{
    if ( [ self.delegate respondsToSelector: @selector( mapViewDidFailLoadingMap:withError: ) ] )
        [ self.delegate mapViewDidFailLoadingMap: self withError: error_ ];
}

-(MKAnnotationView*)mapView:( MKMapView* )mapView_ viewForAnnotation:( id< MKAnnotation > )annotation_
{
    MKAnnotationView* annotationView_ = [ _logic viewForAnnotation: annotation_ ];
    if ( annotationView_ )
        return annotationView_;

    if ( [ self.delegate respondsToSelector: @selector( mapView:viewForAnnotation: ) ] )
        return [ self.delegate mapView: self viewForAnnotation: annotation_ ];

    return nil;
}

-(void)mapView:( MKMapView* )mapView didAddAnnotationViews:( NSArray* )views_
{
    NSArray* leftViews_ = [ _logic didAddAnnotationViews: views_ ];
    if ( [ leftViews_ count ] == 0 )
        return;

    if ( [ self.delegate respondsToSelector: @selector( mapView:didAddAnnotationViews: ) ] )
        [ self.delegate mapView: self didAddAnnotationViews: views_ ];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view_ calloutAccessoryControlTapped:(UIControl *)control_
{
    [ _logic didTappedCalloutAccessoryControl: control_ inAnnotationView: view_ ];

    if ( [ self.delegate respondsToSelector: @selector( mapView:annotationView:calloutAccessoryControlTapped: ) ] )
        [ self.delegate mapView: self annotationView: view_ calloutAccessoryControlTapped: control_ ];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ( [ self.delegate respondsToSelector: @selector( mapView:didSelectAnnotationView: ) ] )
        [ self.delegate mapView: self didSelectAnnotationView: view ];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ( [ self.delegate respondsToSelector: @selector( mapView:didDeselectAnnotationView: ) ] )
        [ self.delegate mapView: self didDeselectAnnotationView: view ];
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    if ( [ self.delegate respondsToSelector: @selector( mapViewWillStartLocatingUser: ) ] )
        [ self.delegate mapViewWillStartLocatingUser: self ];
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    if ( [ self.delegate respondsToSelector: @selector( mapViewDidStopLocatingUser: ) ] )
        [ self.delegate mapViewDidStopLocatingUser: self ];
}

-(void)mapView:( MKMapView* )mapView_ didUpdateUserLocation:( MKUserLocation* )userLocation_
{
    [ _logic didUpdateUserLocation: userLocation_ ];

    if ( [ self.delegate respondsToSelector: @selector( mapView:didUpdateUserLocation: ) ] )
        [ self.delegate mapView: self didUpdateUserLocation: userLocation_ ];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if ( [ self.delegate respondsToSelector: @selector( mapView:didFailToLocateUserWithError: ) ] )
        [ self.delegate mapView: self didFailToLocateUserWithError: error ];
}

-(void)mapView:( MKMapView* )mapView
annotationView:( MKAnnotationView* )view
didChangeDragState:( MKAnnotationViewDragState )newState 
  fromOldState:( MKAnnotationViewDragState )oldState
{
    if ( [ self.delegate respondsToSelector: @selector( mapView:annotationView:didChangeDragState:fromOldState: ) ] )
        [ self.delegate mapView: self annotationView: view didChangeDragState: newState fromOldState: oldState ];
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView_ = [ _logic viewForOverlay: overlay ];
    if ( overlayView_ )
        return overlayView_;

    if ( [ self.delegate respondsToSelector: @selector( mapView:viewForOverlay: ) ] )
        return [ self.delegate mapView: self viewForOverlay: overlay ];

    return nil;
}

-(void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    if ( [ self.delegate respondsToSelector: @selector( mapView:didAddOverlayViews: ) ] )
        [ self.delegate mapView: self didAddOverlayViews: overlayViews ];
}

-(void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    if ( [ self.delegate respondsToSelector: @selector( mapView:didChangeUserTrackingMode:animated: ) ] )
        [ self.delegate mapView: self didChangeUserTrackingMode: mode animated: animated ];
}

@end

@implementation SCMapView (OverlaysAPI)

@dynamic overlays;

-(void)addOverlay:(id <MKOverlay>)overlay
{
    [ _mapView addOverlay: overlay ];
}

-(void)addOverlays:(NSArray *)overlays
{
    [ _mapView addOverlays: overlays ];
}

-(void)removeOverlay:(id <MKOverlay>)overlay
{
    [ _mapView removeOverlay: overlay ];
}

-(void)removeOverlays:(NSArray *)overlays
{
    [ _mapView removeOverlays: overlays ];
}

-(void)insertOverlay:(id <MKOverlay>)overlay atIndex:(NSUInteger)index
{
    [ _mapView insertOverlay: overlay atIndex: index ];
}

-(void)exchangeOverlayAtIndex:( NSUInteger )index1 withOverlayAtIndex:( NSUInteger )index2
{
    [ _mapView exchangeOverlayAtIndex: index1 withOverlayAtIndex: index2 ];
}

-(void)insertOverlay:(id <MKOverlay>)overlay aboveOverlay:(id <MKOverlay>)sibling
{
    [ _mapView insertOverlay: overlay aboveOverlay: sibling ];
}

-(void)insertOverlay:(id <MKOverlay>)overlay belowOverlay:(id <MKOverlay>)sibling
{
    [ _mapView insertOverlay: overlay belowOverlay: sibling ];
}

-(MKOverlayView *)viewForOverlay:(id <MKOverlay>)overlay
{
    return [ _mapView viewForOverlay: overlay ];
}

@end

@implementation SCMapView (SitecoreAPI)

-(SCMapViewResultHandler)didLoadedAnnotationsHandler
{
    return _logic.didLoadedAnnotationsHandler;
}

-(void)setDidLoadedAnnotationsHandler:( SCMapViewResultHandler )didLoadedAnnotationsHandler_
{
    _logic.didLoadedAnnotationsHandler = didLoadedAnnotationsHandler_;
}

-(BOOL)drawRouteToNearestAddress
{
    return _logic.drawRouteToNearestAddress;
}

-(void)setDrawRouteToNearestAddress:( BOOL )drawRouteToNearestAddress_
{
    _logic.drawRouteToNearestAddress = drawRouteToNearestAddress_;
}

-(CLLocationDistance)regionRadius
{
    return _logic.regionRadius;
}

-(void)setRegionRadius:( CLLocationDistance )regionRadius_
{
    _logic.regionRadius = regionRadius_;
}

-(void)addItemsAnnotationsForQuery:( NSString* )query_
                        apiContext:( SCApiContext* )apiContext_
                           handler:( void(^)( NSError* ) )handler_
{
    [ _logic addItemsAnnotationsForQuery: query_
                              apiContext: apiContext_
                                 handler: handler_ ];
}

-(void)addItemsAnnotationsWithPath:( NSString* )path_
                        apiContext:( SCApiContext* )apiContext_
                           handler:( void(^)( NSError* ) )handler_
{
    [ _logic addItemsAnnotationsWithPath: path_
                              apiContext: apiContext_
                                 handler: handler_ ];
}

@end

@implementation SCMapView (SitecoreAPIPrivate)

-(void)addAddressesAnnotations:( NSArray* )addresses_
{
    [ _logic addAddressesAnnotations: addresses_ ];
}

@end
