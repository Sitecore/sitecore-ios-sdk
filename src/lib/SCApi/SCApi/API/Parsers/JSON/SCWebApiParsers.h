#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import <Foundation/Foundation.h>

#include "JSBlocksDefinitions.h"

@class SCApiContext;

JFFAsyncOperation webApiJSONAnalyzer( NSURL* url_, NSData* data_ );

JFFAsyncOperationBinder deleteItemsJSONResponseParser( NSData* responseData_ );

SCAsyncBinderForURL itemsJSONResponseAnalyzerWithApiCntext( SCApiContext* apiContext_ );
