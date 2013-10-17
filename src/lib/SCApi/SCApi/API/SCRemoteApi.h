#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>
#include <SitecoreMobileSDK/SCItemReaderScopeType.h>
#include <SitecoreMobileSDK/SCItemReaderRequestType.h>

#import <Foundation/Foundation.h>

@class SCExtendedApiContext;
@class SCEditItemsRequest;
@class SCCreateItemRequest;
@class SCItemsReaderRequest;
@class SCCreateMediaItemRequest;
@class SCTriggeringRequest;
@class SCHTMLReaderRequest;

@class SCWebApiUrlBuilder;
@class SCParams;

// TODO : store password securely.
// Password ivar is a potential exploit

@interface SCRemoteApi : NSObject

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
       urlBuilder:( SCWebApiUrlBuilder* )urlBuilder_;

-(NSString*)host;
-(NSString*)login;

-(JFFAsyncOperation)credentialsCheckerForSite:( NSString* )site;

-(JFFAsyncOperation)imageLoaderForSCMediaPath:( NSString* )path_
                                cacheLifeTime:( NSTimeInterval )cacheLifeTime_;

-(JFFAsyncOperation)imageLoaderForSCMediaPath:( NSString* )path_
                                cacheLifeTime:( NSTimeInterval )cacheLifeTime_
                                       params:( SCParams* )params_;

-(JFFAsyncOperation)itemsReaderWithRequest:( SCItemsReaderRequest* )request_
                                apiContext:( SCExtendedApiContext* )apiContext_;

-(JFFAsyncOperation)itemCreatorWithRequest:( SCCreateItemRequest* )createItemRequest_
                                apiContext:( SCExtendedApiContext* )apiContext_;

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )editItemsRequest_
                                    apiContext:( SCExtendedApiContext* )apiContext_;

-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCItemsReaderRequest* )removeItemsRequest_
                                      apiContext:( SCExtendedApiContext* )apiContext_;

-(JFFAsyncOperation)mediaItemCreatorWithRequest:( SCCreateMediaItemRequest* )createMediaItemRequest_
                                     apiContext:( SCExtendedApiContext* )apiContext_;

-(JFFAsyncOperation)renderingHTMLLoaderForRequest:( SCHTMLReaderRequest* )request_
                                       apiContext:( SCExtendedApiContext* )apiContext_;

-(JFFAsyncOperation)triggerLoaderWithRequest:( SCTriggeringRequest* )request_;
@end
