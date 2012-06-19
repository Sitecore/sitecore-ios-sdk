#import "SCItemsReaderRequest.h"

@class SCItemRecord;
@class SCApiContext;

@interface SCItemsReaderRequest (SCApiContext)

-(JFFAsyncOperation)asyncOpWithFieldsForAsyncOp:( JFFAsyncOperation )asyncOp_;

-(JFFAsyncOperation)validatedLoader:( JFFAsyncOperation )loader_;

@end
