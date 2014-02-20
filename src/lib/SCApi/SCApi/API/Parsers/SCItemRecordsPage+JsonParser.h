#import <JFFAsyncOperations/JFFAsyncOperations.h>

#import "SCItemRecordsPage.h"

@class SCExtendedApiSession;
@protocol SCItemSource;


@interface SCItemRecordsPage (JsonParser)

+(JFFAsyncOperationBinder)itemRecordsWithResponseData:( NSData* )responseData_
                                           apiSession:( SCExtendedApiSession* )apiSession_
                                   forRequestedSource:( id<SCItemSource> )requestedSource_;

@end
