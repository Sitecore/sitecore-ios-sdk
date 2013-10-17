#import "SCItemRecord.h"

@class SCExtendedApiContext;
@protocol SCItemSource;


@interface SCItemRecord (Parser)

+(JFFAsyncOperationBinder)itemRecordWithApiContext:( SCExtendedApiContext* )apiContext_
                                forRequestedSource:( id<SCItemSource> )requestedSource_;

@end
