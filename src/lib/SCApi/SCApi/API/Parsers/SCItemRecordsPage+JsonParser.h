#import <JFFAsyncOperations/JFFAsyncOperations.h>

#import "SCItemRecordsPage.h"

@class SCExtendedApiContext;
@protocol SCItemSource;


@interface SCItemRecordsPage (JsonParser)

+(JFFAsyncOperationBinder)itemRecordsWithResponseData:( NSData* )responseData_
                                           apiContext:( SCExtendedApiContext* )apiContext_
                                   forRequestedSource:( id<SCItemSource> )requestedSource_;

@end
