#import "SCItemRecord.h"

@class SCExtendedApiSession;
@protocol SCItemSource;


@interface SCItemRecord (Parser)

+(JFFAsyncOperationBinder)itemRecordWithApiSession:( SCExtendedApiSession* )apiSession_
                                forRequestedSource:( id<SCItemSource> )requestedSource_;

@end
