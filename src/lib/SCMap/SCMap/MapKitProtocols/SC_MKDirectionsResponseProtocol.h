#import <Foundation/Foundation.h>

@class MKMapItem;

@protocol SC_MKDirectionsResponseProtocol <NSObject>

// Source and destination may be filled with additional details compared to the request object.
-(MKMapItem *)source;
-(MKMapItem *)destination;

-(NSArray *)routes; // array of MKRoute objects

@end
