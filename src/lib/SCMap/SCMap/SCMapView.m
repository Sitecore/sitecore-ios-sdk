#import "SCMapView.h"

#import "SCMapViewLogic.h"

@interface SCMapView () < MKMapViewDelegate >

-(void)initialize;

@end

@implementation SCMapView
{
    SCMapViewLogic* _logic;
    id<MKMapViewDelegate> _externalDelegate;
    
    Class _MKPolylineRendererClass;
}

-(id)init
{
    self = [ super init ];
    
    if ( self )
    {
        [ self initialize ];
    }
    
    return self;
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
    if ( [ ESFeatureAvailabilityChecker isPolyLineMapOverlayRendererAvailable ] )
    {
        self->_MKPolylineRendererClass = NSClassFromString(@"MKPolylineRenderer");
    }
    
    self.delegate = self;
    self->_logic = [ [ SCMapViewLogic alloc ] initWithMapView: self ];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    if ( ![ ESFeatureAvailabilityChecker isPolyLineMapOverlayRendererAvailable ] )
    {
        return nil;
    }

    id<SC_MKPolylineRendererProtocol> renderer =
    [ [ self->_MKPolylineRendererClass alloc ] initWithOverlay: overlay ];
    {
        [renderer setLineWidth: 3.0];
        [renderer setStrokeColor: [UIColor blueColor] ];
    }
    
    return renderer;
}

//@igk spike, to save backward compatibility
-(void)setDelegate:(id<MKMapViewDelegate>)delegate
{
    if (delegate == self)
    {
        [super setDelegate:delegate];
    }
    else
    {
        self->_externalDelegate = delegate;
    }
}

-(id<MKMapViewDelegate>)delegate
{
    return self->_externalDelegate;
}

-(MKAnnotationView*)mapView:( MKMapView* )mapView_ viewForAnnotation:( id< MKAnnotation > )annotation_
{
    MKAnnotationView* annotationView_ = [ _logic viewForAnnotation: annotation_ ];
    if ( annotationView_ )
        return annotationView_;

    if ( [ self->_externalDelegate respondsToSelector: @selector( mapView:viewForAnnotation: ) ] )
        return [ self->_externalDelegate mapView: self viewForAnnotation: annotation_ ];

    return nil;
}

-(void)mapView:( MKMapView* )mapView didAddAnnotationViews:( NSArray* )views_
{
    NSArray* leftViews_ = [ _logic didAddAnnotationViews: views_ ];
    if ( [ leftViews_ count ] == 0 )
        return;

    if ( [ self->_externalDelegate respondsToSelector: @selector( mapView:didAddAnnotationViews: ) ] )
        [ self->_externalDelegate mapView: self didAddAnnotationViews: views_ ];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view_ calloutAccessoryControlTapped:(UIControl *)control_
{
    [ _logic didTappedCalloutAccessoryControl: control_ inAnnotationView: view_ ];

    if ( [ self->_externalDelegate respondsToSelector: @selector( mapView:annotationView:calloutAccessoryControlTapped: ) ] )
        [ self->_externalDelegate mapView: self annotationView: view_ calloutAccessoryControlTapped: control_ ];
}

-(void)mapView:( MKMapView* )mapView_ didUpdateUserLocation:( MKUserLocation* )userLocation_
{
    [ _logic didUpdateUserLocation: userLocation_ ];

    if ( [ self->_externalDelegate respondsToSelector: @selector( mapView:didUpdateUserLocation: ) ] )
        [ self->_externalDelegate mapView: self didUpdateUserLocation: userLocation_ ];
}


-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView_ = [ _logic viewForOverlay: overlay ];
    if ( overlayView_ )
        return overlayView_;

    if ( [ self->_externalDelegate respondsToSelector: @selector( mapView:viewForOverlay: ) ] )
        return [ self->_externalDelegate mapView: self viewForOverlay: overlay ];

    return nil;
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

#ifdef __IPHONE_7_0

-(void)setCamera:(id)camera
        animated:(BOOL)animated
{
    self->_logic.regionIsAdjusted = YES;
    
    if ( [ super respondsToSelector:@selector(setCamera:animated:) ] )
    {
        [ super setCamera:camera animated:YES ];
    }
}

-(void)setCamera:(id)camera
{
   [ self setCamera:camera
           animated:YES ];
}

#else

-(void)setCamera:(id)camera
{
    NSLog(@"Maps perspective view is not suppoorted on this device!");
}

-(void)setCamera:(id)camera
        animated:(BOOL)animated
{
    NSLog(@"Maps perspective view is not suppoorted on this device!");
}

#endif

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
