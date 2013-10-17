#import <Foundation/Foundation.h>
#include <EventKit/EventKit.h>

typedef void(^SCEventStoreSuccessCallback)( EKEventStore* store_ );
typedef void(^SCEventStoreErrorCallback)( NSError* error_ );

@interface SCEventsStoreFactory : NSObject

+(void)asyncEventsStoreWithSuccessBlock:( SCEventStoreSuccessCallback )onSuccess_
                          errorCallback:( SCEventStoreErrorCallback )onFailure_;

@end
