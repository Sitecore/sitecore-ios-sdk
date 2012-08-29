#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>
#include <SitecoreMobileSDK/SCItemReaderScopeType.h>
#include <SitecoreMobileSDK/SCItemReaderRequestType.h>

#import <Foundation/Foundation.h>

@class SCApiContext;
@class SCEditItemsRequest;
@class SCCreateItemRequest;
@class SCItemsReaderRequest;
@class SCCreateMediaItemRequest;

// TODO : store password securely.
// Password ivar is a potential exploit

@interface SCRemoteApi : NSObject

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_;

-(JFFAsyncOperation)imageLoaderForSCMediaPath:( NSString* )path_
                                cacheLifeTime:( NSTimeInterval )cacheLifeTime_;

-(JFFAsyncOperation)itemsReaderWithRequest:( SCItemsReaderRequest* )request_
                                apiContext:( SCApiContext* )apiContext_;

-(JFFAsyncOperation)itemCreatorWithRequest:( SCCreateItemRequest* )createItemRequest_
                                apiContext:( SCApiContext* )apiContext_;

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )editItemsRequest_
                                    apiContext:( SCApiContext* )apiContext_;

-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCItemsReaderRequest* )removeItemsRequest_
                                      apiContext:( SCApiContext* )apiContext_;

-(JFFAsyncOperation)mediaItemCreatorWithRequest:( SCCreateMediaItemRequest* )createMediaItemRequest_
                                     apiContext:( SCApiContext* )apiContext_;

-(JFFAsyncOperation)renderingHTMLLoaderForRenderingId:( NSString* )rendereringId_
                                             sourceId:( NSString* )sourceId_
                                           apiContext:( SCApiContext* )apiContext_;

@end
