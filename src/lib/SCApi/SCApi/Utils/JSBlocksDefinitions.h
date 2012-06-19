#ifndef SC_API_JS_BLOCKS_DEFINITIONS_HEADER_INCLUDED
#define SC_API_JS_BLOCKS_DEFINITIONS_HEADER_INCLUDED

#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

@class NSURL;

typedef JFFAsyncOperationBinder(^SCAsyncBinderForURL)( NSURL* );

#endif //SC_API_JS_BLOCKS_DEFINITIONS_HEADER_INCLUDED
