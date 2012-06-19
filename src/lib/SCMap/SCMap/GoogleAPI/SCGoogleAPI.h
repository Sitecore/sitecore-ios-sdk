#import <Foundation/Foundation.h>

#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

@interface SCGoogleAPI : NSObject

+(JFFAsyncOperation)routePointsReaderForStartLocation:( CLLocationCoordinate2D )orign_
                                          destination:( CLLocationCoordinate2D )destination_;

@end
