#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>
#import <SitecoreMobileSDK/SCReadItemsScopeType.h>
#import <SitecoreMobileSDK/SCReadItemsRequestType.h>
#import <Foundation/Foundation.h>

@class SCExtendedApiSession;
@class SCEditItemsRequest;
@class SCCreateItemRequest;
@class SCReadItemsRequest;
@class SCUploadMediaItemRequest;
@class SCTriggeringRequest;
@class SCGetRenderingHtmlRequest;

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

-(JFFAsyncOperation)checkCredentialsOperationForSite:( NSString* )site;

-(JFFAsyncOperation)imageLoaderForSCMediaPath:( NSString* )path_
                                cacheLifeTime:( NSTimeInterval )cacheLifeTime_;

-(JFFAsyncOperation)imageLoaderForSCMediaPath:( NSString* )path_
                                cacheLifeTime:( NSTimeInterval )cacheLifeTime_
                                       params:( SCParams* )params_;

-(JFFAsyncOperation)readItemsOperationWithRequest:( SCReadItemsRequest * )request_
                                apiSession:( SCExtendedApiSession* )apiSession_;

-(JFFAsyncOperation)createItemsOperationWithRequest:( SCCreateItemRequest* )createItemRequest_
                                apiSession:( SCExtendedApiSession* )apiSession_;

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )editItemsRequest_
                                    apiSession:( SCExtendedApiSession* )apiSession_;

-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCReadItemsRequest * )removeItemsRequest_
                                      apiSession:( SCExtendedApiSession* )apiSession_;

-(JFFAsyncOperation)uploadMediaOperationWithRequest:( SCUploadMediaItemRequest * )createMediaItemRequest_
                                     apiSession:( SCExtendedApiSession* )apiSession_;

-(JFFAsyncOperation)renderingHTMLLoaderForRequest:( SCGetRenderingHtmlRequest * )request_
                                       apiSession:( SCExtendedApiSession* )apiSession_;

-(JFFAsyncOperation)triggerLoaderWithRequest:( SCTriggeringRequest* )request_;
@end
