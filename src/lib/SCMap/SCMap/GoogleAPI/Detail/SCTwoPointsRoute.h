#import <Foundation/Foundation.h>

@interface SCTwoPointsRoute : NSObject

@property ( nonatomic ) CLLocationCoordinate2D origin;
@property ( nonatomic ) CLLocationCoordinate2D destination;

+(id)routeWithOrigin:( CLLocationCoordinate2D )origin_
         destination:( CLLocationCoordinate2D )destination_;

@end
