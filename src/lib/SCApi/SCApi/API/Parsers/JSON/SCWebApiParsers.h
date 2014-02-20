#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import <Foundation/Foundation.h>

#include "JSBlocksDefinitions.h"

@class SCExtendedApiSession;
@protocol SCItemSource;


#ifdef __cplusplus
extern "C" {
#endif

JFFAsyncOperation webApiJSONAnalyzer( NSURL* url_, NSData* data_ );

JFFAsyncOperationBinder deleteItemsJSONResponseParser( NSData* responseData_ );

SCAsyncBinderForURL itemsJSONResponseAnalyzerWithApiSessionAndRequest( SCExtendedApiSession* apiSession_,                                    id<SCItemSource> requestedSource_ );

#ifdef __cplusplus
}
#endif
