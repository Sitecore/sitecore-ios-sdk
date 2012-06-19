//
//  SCMapView.h
//  SCMapView
//
//  Important: The MapKit framework uses Google services to provide map data. Use of this class and 
//  the associated interfaces binds you to the Google Maps/Google Earth API terms of service. You can
//  find these terms of service at http://code.google.com/apis/maps/iphone/terms.html
//
//  Copyright (c) 2009-2011, Apple Inc. All rights reserved.
//

#import <MapKit/MKAnnotationView.h>
#import <MapKit/MKFoundation.h>
#import <MapKit/MKGeometry.h>
#import <MapKit/MKTypes.h>
#import <MapKit/MKOverlay.h>
#import <MapKit/MKOverlayView.h>
#import <MapKit/MKPointAnnotation.h>
#import <MapKit/MKPolygon.h>
#import <MapKit/MKPolyline.h>
#import <MapKit/MKCircle.h>
#import <MapKit/MKPolygonView.h>
#import <MapKit/MKPolylineView.h>
#import <MapKit/MKCircleView.h>
#import <MapKit/MKMapView.h>

@class MKUserLocation;
@class SCApiContext;

@protocol SCMapViewDelegate;

@interface SCMapView : UIView <NSCoding>

@property(nonatomic,weak) IBOutlet id <SCMapViewDelegate> delegate;

// Changing the map type or region can cause the map to start loading map content.
// The loading delegate methods will be called as map content is loaded.
@property(nonatomic) MKMapType mapType;

// Region is the coordinate and span of the map.
// Region may be modified to fit the aspect ratio of the view using regionThatFits:.
@property(nonatomic) MKCoordinateRegion region;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated;

// centerCoordinate allows the coordinate of the region to be changed without changing the zoom level.
@property(nonatomic) CLLocationCoordinate2D centerCoordinate;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

// Returns a region of the aspect ratio of the map view that contains the given region, with the same center point.
- (MKCoordinateRegion)regionThatFits:(MKCoordinateRegion)region;

// Access the visible region of the map in projected coordinates.
@property(nonatomic) MKMapRect visibleMapRect;
- (void)setVisibleMapRect:(MKMapRect)mapRect animated:(BOOL)animate;

// Returns an MKMapRect modified to fit the aspect ratio of the map.
- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect;

// Edge padding is the minumum padding on each side around the specified MKMapRect.
- (void)setVisibleMapRect:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate;
- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets;

- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;
- (CGRect)convertRegion:(MKCoordinateRegion)region toRectToView:(UIView *)view;
- (MKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

// Disable user interaction from zooming or scrolling the map, or both.
@property(nonatomic,getter=isZoomEnabled) BOOL zoomEnabled;
@property(nonatomic,getter=isScrollEnabled) BOOL scrollEnabled;

// Set to YES to add the user location annotation to the map and start updating its location
@property(nonatomic) BOOL showsUserLocation;

// The annotation representing the user's location
@property(nonatomic,readonly) MKUserLocation *userLocation;

@property(nonatomic) MKUserTrackingMode userTrackingMode NS_AVAILABLE(NA, 5_0);
- (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0);

// Returns YES if the user's location is displayed within the currently visible map region.
@property(nonatomic,readonly,getter=isUserLocationVisible) BOOL userLocationVisible;

// Annotations are models used to annotate coordinates on the map. 
// Implement mapView:viewForAnnotation: on SCMapViewDelegate to return the annotation view for each annotation.
- (void)addAnnotation:(id <MKAnnotation>)annotation;
- (void)addAnnotations:(NSArray *)annotations;

- (void)removeAnnotation:(id <MKAnnotation>)annotation;
- (void)removeAnnotations:(NSArray *)annotations;

@property(nonatomic,readonly) NSArray *annotations;
- (NSSet *)annotationsInMapRect:(MKMapRect)mapRect NS_AVAILABLE(NA, 4_2);

// Currently displayed view for an annotation; returns nil if the view for the annotation isn't being displayed.
- (MKAnnotationView *)viewForAnnotation:(id <MKAnnotation>)annotation;

// Used by the delegate to acquire an already allocated annotation view, in lieu of allocating a new one.
- (MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

// Select or deselect a given annotation.  Asks the delegate for the corresponding annotation view if necessary.
- (void)selectAnnotation:(id <MKAnnotation>)annotation animated:(BOOL)animated;
- (void)deselectAnnotation:(id <MKAnnotation>)annotation animated:(BOOL)animated;
@property(nonatomic,copy) NSArray *selectedAnnotations;

// annotationVisibleRect is the visible rect where the annotations views are currently displayed.
// The delegate can use annotationVisibleRect when animating the adding of the annotations views in mapView:didAddAnnotationViews:
@property(nonatomic,readonly) CGRect annotationVisibleRect;

@end

@interface SCMapView (OverlaysAPI)

// Overlays are models used to represent areas to be drawn on top of the map.
// This is in contrast to annotations, which represent points on the map.
// Implement -mapView:viewForOverlay: on SCMapViewDelegate to return the view for each overlay.
- (void)addOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);
- (void)addOverlays:(NSArray *)overlays NS_AVAILABLE(NA, 4_0);

- (void)removeOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);
- (void)removeOverlays:(NSArray *)overlays NS_AVAILABLE(NA, 4_0);

- (void)insertOverlay:(id <MKOverlay>)overlay atIndex:(NSUInteger)index NS_AVAILABLE(NA, 4_0);
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2 NS_AVAILABLE(NA, 4_0);

- (void)insertOverlay:(id <MKOverlay>)overlay aboveOverlay:(id <MKOverlay>)sibling NS_AVAILABLE(NA, 4_0);
- (void)insertOverlay:(id <MKOverlay>)overlay belowOverlay:(id <MKOverlay>)sibling NS_AVAILABLE(NA, 4_0);

@property(nonatomic, readonly) NSArray *overlays NS_AVAILABLE(NA, 4_0);

// Currently displayed view for overlay; returns nil if the view has not been created yet.
- (MKOverlayView *)viewForOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);

@end

@interface SCMapView (SitecoreAPI)

@property(nonatomic) CLLocationDistance regionRadius;
@property(nonatomic) BOOL drawRouteToNearestAddress;

- (void)addItemsAnnotationsForQuery:(NSString *)query
                         apiContext:(SCApiContext *)apiContext
                            handler:(void(^)(NSError *))handler;

- (void)addItemsAnnotationsWithPath:(NSString *)path
                         apiContext:(SCApiContext *)apiContext
                            handler:(void(^)(NSError *))handler;

typedef void (^SCMapViewResultHandler)(NSArray *annotations, NSError *error);
@property(nonatomic,copy) SCMapViewResultHandler didLoadedAnnotationsHandler;

@end

@protocol SCMapViewDelegate <NSObject>
@optional

- (void)mapView:(SCMapView *)mapView regionWillChangeAnimated:(BOOL)animated;
- (void)mapView:(SCMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

- (void)mapViewWillStartLoadingMap:(SCMapView *)mapView;
- (void)mapViewDidFinishLoadingMap:(SCMapView *)mapView;
- (void)mapViewDidFailLoadingMap:(SCMapView *)mapView withError:(NSError *)error;

// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
- (MKAnnotationView *)mapView:(SCMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

// mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
// The delegate can implement this method to animate the adding of the annotations views.
// Use the current positions of the annotation views as the destinations of the animation.
- (void)mapView:(SCMapView *)mapView didAddAnnotationViews:(NSArray *)views;

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
- (void)mapView:(SCMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

- (void)mapView:(SCMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(NA, 4_0);
- (void)mapView:(SCMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(NA, 4_0);

- (void)mapViewWillStartLocatingUser:(SCMapView *)mapView NS_AVAILABLE(NA, 4_0);
- (void)mapViewDidStopLocatingUser:(SCMapView *)mapView NS_AVAILABLE(NA, 4_0);
- (void)mapView:(SCMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(NA, 4_0);
- (void)mapView:(SCMapView *)mapView didFailToLocateUserWithError:(NSError *)error NS_AVAILABLE(NA, 4_0);

- (void)mapView:(SCMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState 
   fromOldState:(MKAnnotationViewDragState)oldState NS_AVAILABLE(NA, 4_0);

- (MKOverlayView *)mapView:(SCMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);

// Called after the provided overlay views have been added and positioned in the map.
- (void)mapView:(SCMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews NS_AVAILABLE(NA, 4_0);

- (void)mapView:(SCMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0);

@end
