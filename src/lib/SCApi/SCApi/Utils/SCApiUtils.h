#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import <Foundation/Foundation.h>

#include "JSBlocksDefinitions.h"

@class SCCreateMediaItemRequest;

JFFAsyncOperation firstItemFromArrayReader( JFFAsyncOperation loader_ );

JFFAsyncOperation asyncOpWithValidPath( JFFAsyncOperationBinder binder_, NSString* path_ );
JFFAsyncOperation asyncOpWithValidIds( JFFAsyncOperationBinder binder_, NSArray* ids_ );

JFFAsyncOperation itemRecordsPageToItemsPage( JFFAsyncOperation asyncOp_ );

JFFAsyncOperation itemPageToItems( JFFAsyncOperation loader_ );

JFFAsyncOperation scDataURLResponseLoader( NSURL* url_
                                          , NSString* login_
                                          , NSString* password_
                                          , NSData* httpBody_
                                          , NSString* httpMethod_
                                          , NSDictionary* headers_ );

JFFAsyncOperationBinder createMediaItemRequestDataLoader( SCCreateMediaItemRequest* request_
                                                         , NSString* login_
                                                         , NSString* password_ );

