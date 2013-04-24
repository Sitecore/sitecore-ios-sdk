#import <JFFAsyncOperations/AsyncOperartionsBuilder/JFFAsyncOperationInterface.h>
#import <Foundation/Foundation.h>

@class CLGeocoder;

@interface JFFAsyncOperationGeocoderBase : NSObject < JFFAsyncOperationInterface >

@property ( nonatomic, readonly ) CLGeocoder* geocoder;

@end

