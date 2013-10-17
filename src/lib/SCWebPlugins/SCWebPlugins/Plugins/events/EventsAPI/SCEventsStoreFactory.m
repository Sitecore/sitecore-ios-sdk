#import "SCEventsStoreFactory.h"

@implementation SCEventsStoreFactory

+(void)asyncEventsStoreWithSuccessBlock:( SCEventStoreSuccessCallback )onSuccess_
                          errorCallback:( SCEventStoreErrorCallback )onFailure_;
{
    NSParameterAssert( nil != onSuccess_ );
    NSParameterAssert( nil != onFailure_ );
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSError *accesserror = nil;
    
    [ eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,
                                                                          NSError *accesserror) {
    
        if ( granted )
        {
            onSuccess_ ( eventStore );
        }
        else
        {
            //TODO: @igk make special error class
            NSError *error = [ NSError errorWithDomain: @"Access not granted"
                                                  code: 0
                                              userInfo: nil ];
            onFailure_ ( error );
        }
        
    }];
    
    if ( accesserror )
     {
         onFailure_ (accesserror);
     }

}


@end
