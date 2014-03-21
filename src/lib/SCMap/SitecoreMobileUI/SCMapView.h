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
 Active area radius.
 */
@property(nonatomic) CLLocationDistance regionRadius;
/**
 Specify YES to draw route to nearest address.
 */
@property(nonatomic) BOOL drawRouteToNearestAddress;

/**
 Adds annotations with items from query.
  
 @param query the querry to receive set of items based on the "Mobile Address" template.
 @param apiSession obejct of SCApiSession type
 @param handler result handler
 */
- (void)addItemsAnnotationsForQuery:(NSString *)query
                         apiSession:(SCApiSession *)apiSession
                            handler:(void(^)(NSError *))handler;
/**
 Adds annotations with items from path.
 
 @param path the path to items based on the "Mobile Address" template.
 @param apiSession obejct of SCApiSession type
 @param handler result handler
 */
- (void)addItemsAnnotationsWithPath:(NSString *)path
                         apiSession:(SCApiSession *)apiSession
                            handler:(void(^)(NSError *))handler;

typedef void (^SCMapViewResultHandler)(NSArray *annotations, NSError *error);
/**
 Handler to catch the result of annotations loading process.
 */
@property(nonatomic,copy) SCMapViewResultHandler didLoadedAnnotationsHandler;

/**
 MKMapCamera object. The camera used for determining the appearance of the map.
 */
-(void)setCamera:(id)camera;

/**
 MKMapCamera object. The camera used for determining the appearance of the map.
  @param animated Specify YES if you want the change in viewing angle to be animated or NO if you want the map to reflect the changes without animations.
 */
-(void)setCamera:(id)camera
        animated:(BOOL)animated;

@end
