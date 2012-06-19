#import <JFFAsyncOperations/JFFAsyncOperations.h>

#import "SCItemRecordsPage.h"

@class SCApiContext;

@interface SCItemRecordsPage (JsonParser)

+(JFFAsyncOperationBinder)itemRecordsWithResponseData:( NSData* )responseData_
                                           apiContext:( SCApiContext* )apiContext_;

@end
