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
 Active area radius which will be used as the amount of north-to-south and east-to-west distance  (measured in meters) to build map region. 
 User location will be used as the region center.
 */
@property(nonatomic) CLLocationDistance regionRadius;

/**
 Specify YES to draw route to nearest address. Route will be drawn after calling one of the -(void)addItemsAnnotations... methods to the nearest to user location address from the result set.
 */
@property(nonatomic) BOOL drawRouteToNearestAddress;

/**
 Adds annotations with items from query.
  
 @param query the querry to receive set of items based on the "Mobile Address" template. Example: "/sitecore/content/home/child::*[@@templatename='Mobile Address']"
 @param apiSession obejct of SCApiSession type
 @param handler result handler, will be invoked when items downloading and geocoding procedures will be finished. Error will be nil, if all operation will be successful, in other case error will contaign appropriate error object.
 */
- (void)addItemsAnnotationsForQuery:(NSString *)query
                         apiSession:(SCApiSession *)apiSession
                            handler:(void(^)(NSError *))handler;
/**
 Adds annotations with items from path.
 
 @param path the path to items based on the "Mobile Address" template.  Example: "/sitecore/content/home/"
 @param apiSession obejct of SCApiSession type
 @param handler result handler, will be invoked when items downloading and geocoding procedures will be finished. Error will be nil, if all operation will be successful, in other case error will contaign appropriate error object.
 */
- (void)addItemsAnnotationsWithPath:(NSString *)path
                         apiSession:(SCApiSession *)apiSession
                            handler:(void(^)(NSError *))handler;

/**
 Handler type to catch the result of annotations loading process.
 
 @param annotations will contaign array of CLPlacemarks objects.
 @param error wil contaign error object if operation will not be successeful or nil in other case.
 */
typedef void (^SCMapViewResultHandler)(NSArray *annotations, NSError *error);
/**
 Handler to catch the result of annotations loading process.
 */
@property(nonatomic,copy) SCMapViewResultHandler didLoadedAnnotationsHandler;

/**
 The camera used for determining the appearance of the map.
 
 @param camera MKMapCamera object.
 */
-(void)setCamera:(id)camera;

/**
 The camera used for determining the appearance of the map.
 
 @param camera MKMapCamera object.
 @param animated Specify YES if you want the change in viewing angle to be animated or NO if you want the map to reflect the changes without animations.
 */
-(void)setCamera:(id)camera
        animated:(BOOL)animated;

@end
