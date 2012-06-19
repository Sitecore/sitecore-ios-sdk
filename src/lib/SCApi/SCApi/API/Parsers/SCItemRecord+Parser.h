#import "SCItemRecord.h"

@class SCApiContext;

@interface SCItemRecord (Parser)

+(JFFAsyncOperationBinder)itemRecordWithApiContext:( SCApiContext* )apiContext_;

@end
