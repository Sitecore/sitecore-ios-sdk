#import "SCReadItemsRequest.h"

@class SCItemRecord;
@class SCApiSession;

@interface SCReadItemsRequest (SCApiSession)

-(JFFAsyncOperation)asyncOpWithFieldsForAsyncOp:( JFFAsyncOperation )asyncOp_;

-(JFFAsyncOperation)validatedLoader:( JFFAsyncOperation )loader_;

@end
