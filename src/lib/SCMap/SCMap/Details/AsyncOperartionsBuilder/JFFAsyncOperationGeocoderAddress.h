#import "JFFAsyncOperationGeocoderBase.h"

@class CLRegion;

@interface JFFAsyncOperationGeocoderAddress : JFFAsyncOperationGeocoderBase

@property ( nonatomic ) NSString* address;
@property ( nonatomic ) CLRegion* region;

@end
