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

#import <MapKit/MKMapView.h>

@class SCApiSession;

@interface SCMapView : MKMapView

@end

@interface SCMapView (SitecoreAPI)

/**
 Active area radius
 */
@property(nonatomic) CLLocationDistance regionRadius;
/**
 Set YES to draw route to nearest address
 */
@property(nonatomic) BOOL drawRouteToNearestAddress;

/**
 Adds annotations with items from query
 */
- (void)addItemsAnnotationsForQuery:(NSString *)query
                         apiSession:(SCApiSession *)apiSession
                            handler:(void(^)(NSError *))handler;
/**
 Adds annotations with items from path
 */
- (void)addItemsAnnotationsWithPath:(NSString *)path
                         apiSession:(SCApiSession *)apiSession
                            handler:(void(^)(NSError *))handler;

typedef void (^SCMapViewResultHandler)(NSArray *annotations, NSError *error);
/**
 Tells that the annotations was loaded
 */
@property(nonatomic,copy) SCMapViewResultHandler didLoadedAnnotationsHandler;

-(void)setCamera:(id)camera;
-(void)setCamera:(id)camera
        animated:(BOOL)animated;

@end
