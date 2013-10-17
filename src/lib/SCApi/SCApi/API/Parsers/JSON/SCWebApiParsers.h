#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import <Foundation/Foundation.h>

#include "JSBlocksDefinitions.h"

@class SCExtendedApiContext;
@protocol SCItemSource;


#ifdef __cplusplus
extern "C" {
#endif

JFFAsyncOperation webApiJSONAnalyzer( NSURL* url_, NSData* data_ );

JFFAsyncOperationBinder deleteItemsJSONResponseParser( NSData* responseData_ );

SCAsyncBinderForURL itemsJSONResponseAnalyzerWithApiContextAndRequest( SCExtendedApiContext* apiContext_,                                    id<SCItemSource> requestedSource_ );

#ifdef __cplusplus
}
#endif
