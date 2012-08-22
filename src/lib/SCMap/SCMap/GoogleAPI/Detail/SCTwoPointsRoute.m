#import "SCTwoPointsRoute.h"

@implementation SCTwoPointsRoute

+(id)routeWithOrigin:( CLLocationCoordinate2D )origin_
         destination:( CLLocationCoordinate2D )destination_
{
    SCTwoPointsRoute* route_ = [ self new ];

    route_.origin      = origin_;
    route_.destination = destination_;

    return route_;
}

@end
