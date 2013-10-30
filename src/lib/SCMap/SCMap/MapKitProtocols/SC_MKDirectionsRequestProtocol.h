#import <Foundation/Foundation.h>

@class MKMapItem;

@protocol SC_MKDirectionsRequestProtocol <NSObject>

- (MKMapItem *)source;
- (void)setSource:(MKMapItem *)source;

- (MKMapItem *)destination;
- (void)setDestination:(MKMapItem *)destination;


 // Default is MKDirectionsTransportTypeAny
-(NSUInteger)transportType;
-(void)setTransportType:(NSUInteger)newValue;

// if YES and there is more than one reasonable way to route from source to destination, allow the route server to return multiple routes. Default is NO.
-(BOOL)requestsAlternateRoutes;
-(void)setRequestsAlternateRoutes:(BOOL)newValue;


// Set either departure or arrival date to hint to the route server when the trip will take place.
-(NSDate *)departureDate;
-(void)setDepartureDate:(NSDate *)newValue;

-(NSDate *)arrivalDate;
-(void)setArrivalDate:(NSDate *)newValue;

@end
