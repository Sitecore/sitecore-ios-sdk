#import "SCRemoteApi.h"

#import "SCError.h"
#import "SCExtendedApiSession.h"
#import "SCEditItemsRequest.h"
#import "SCCreateItemRequest.h"

#import "SCWebApiParsers.h"
#import "SCApiUtils.h"
#import "SCSmartDataLoaders.h"

#import "SCSrvResponseCaches.h"
#import "SCUploadMediaItemRequest.h"

#import "NSURL+URLWithItemsReaderRequest.h"
#import "NSData+EditFieldsBodyWithFieldsDict.h"
#import "SCSitecoreCredentials+XMLParser.h"
#import "NSString+MultipartFormDataBoundary.h"
#import "NSData+MultipartFormDataWithBoundary.h"

#import "SCTriggeringImplRequest.h"
#import "SCTriggerExecutor.h"

#import "SCWebApiUrlBuilder.h"
#import "SCParams.h"
#import "SCParams+UrlBuilder.h"


#import "SCWebApiConfig.h"
#import "SCItemCreatorUrlBuilder.h"
#import "SCReaderRequestUrlBuilder.h"
#import "SCCreateMediaRequestUrlBuilder.h"

#import "SCReadItemsRequest+SCItemSource.h"
#import "SCUploadMediaItemRequest+SCItemSource.h"

#import "SCActionsUrlBuilder.h"
#import "SCWebApiConfig.h"

#import "SCHTMLRenderingRequestUrlBuilder.h"

@interface SCRemoteApi ()

//JTODO use imagesCache in JFFImageCache
@property ( nonatomic ) NSCache* imagesCache;
@property ( nonatomic ) SCSitecoreCredentials* credentials;

@end

@implementation SCRemoteApi
{
    NSString* _host;
    NSString* _login;
    NSString* _password;
    
    SCWebApiUrlBuilder* _urlBuilder;
    SCActionsUrlBuilder* _actionBuilder;
}

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
       urlBuilder:( SCWebApiUrlBuilder* )urlBuilder_
{
    self = [ super init ];

    if ( self )
    {
        self->_host        = host_;
        self->_login       = login_;
        self->_password    = password_;
        self->_urlBuilder = urlBuilder_;

        // @adk
        // TODO : stop using SCWebApiUrlBuilder
        // TODO : refactor and use dependency injection for SCActionsUrlBuilder
        self->_actionBuilder =
        [ [ SCActionsUrlBuilder alloc ] initWithHost: host_
                                       webApiVersion: self->_urlBuilder.webApiVersion
                                       restApiConfig: [ SCWebApiConfig webApiV1Config ] ];

        self->_imagesCache = [ NSCache new ];
    }

    return self;
}

-(JFFAsyncOperation)checkCredentialsOperationForSite:( NSString* )site
{
    NSString* strCredentialsCheckerAction = [ self->_actionBuilder urlToCheckCredentialsForSite: site ];
    NSURL* credentialsCheckerAction = [ NSURL URLWithString: strCredentialsCheckerAction ];
    
    JFFAsyncOperation checkAuthLoader = [ self authedApiResponseDataLoaderForURL: credentialsCheckerAction
                                                                        httpBody: nil
                                                                      httpMethod: @"GET"
                                                                         headers: nil ];
    JFFAsyncOperationBinder parseBinder = ^JFFAsyncOperation( NSData* downloadResult )
    {
        NSParameterAssert( [ downloadResult isKindOfClass: [ NSData class ] ] );
        JFFAsyncOperation blockResult = webApiJSONAnalyzer( credentialsCheckerAction, downloadResult );
        
        JFFAsyncOperation resultStub = asyncOperationWithResult( [ NSNull null ] );
        
        return sequenceOfAsyncOperationsArray( @[blockResult, resultStub] );
    };

    JFFAsyncOperation result = bindSequenceOfAsyncOperationsArray( checkAuthLoader, @[parseBinder] );
    return result;
}

-(JFFAsyncOperation)credentioalsLoader
{
    JFFAsyncOperation credentioalsLoader_ = nil;


    if ( [ self->_login length ] == 0 )
    {
        credentioalsLoader_ = ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                                       , JFFCancelAsyncOperationHandler cancelCallback_
                                                       , JFFDidFinishAsyncOperationHandler doneCallback_ )
        {
            SCSitecoreCredentials* credentials_ = [ SCSitecoreCredentials new ];
            JFFAsyncOperation loader_ = asyncOperationWithResult( credentials_ );
            return loader_(progressCallback_, cancelCallback_, doneCallback_ );
        };
    }
    else
    {
#if IS_ENCRYPTION_ENABLED
        NSString* publicKeyUrl = [ self->_actionBuilder urlToGetPublicKey ];
        NSURL* credentioalsURL_ = [ NSURL URLWithString: publicKeyUrl ];
        credentioalsLoader_ = scDataURLResponseLoader( credentioalsURL_, nil, nil, nil, nil );

        credentioalsLoader_ = asyncOperationWithChangedError( credentioalsLoader_,
        ^NSError*( NSError *error )
        {
            SCEncryptionError* newError = [ [ SCEncryptionError alloc ] initWithDescription: @"Credentials not received" code: 2 ];
            newError.underlyingError = error;
            
            return newError;
        } );
        
        JFFAsyncOperationBinder xmlAnalizer_ = asyncOperationBinderWithAnalyzer( ^id( NSData* xmlData_, NSError** error_ )
        {
            SCSitecoreCredentials* credentials_ = [ SCSitecoreCredentials sitecoreCredentialsWithXMLData: xmlData_
                                                                                                   error: error_ ];
            if ( credentials_ )
            {
                credentials_.login    = self->_login;
                credentials_.password = self->_password;
            }
            return credentials_;
        } );

        credentioalsLoader_ = bindSequenceOfAsyncOperations( credentioalsLoader_
                                                            , xmlAnalizer_
                                                            , nil );
#else
        SCSitecoreCredentials* cred = [ SCSitecoreCredentials new ];
        {
            cred.login    = self->_login;
            cred.password = self->_password;
        }
        credentioalsLoader_ = asyncOperationWithResult( cred );
#endif
    }

    return [ self asyncOperationForPropertyWithName: @"credentials"
                                     asyncOperation: credentioalsLoader_ ];
}

-(JFFAsyncOperation)authedApiResponseDataLoaderForURL:( NSURL* )url_
                                             httpBody:( NSData* )httpBody_
                                           httpMethod:( NSString* )httpMethod_
                                              headers:( NSDictionary* )headers_
{
    JFFAsyncOperation credentioalsLoader_ = [ self credentioalsLoader ];

    JFFAsyncOperationBinder secondLoaderBinder_ = ^JFFAsyncOperation( SCSitecoreCredentials* credentials_ )
    {
        return scDataURLResponseLoader( url_, credentials_, httpBody_, httpMethod_, headers_ );
    };

    return bindSequenceOfAsyncOperations( credentioalsLoader_
                                         , secondLoaderBinder_
                                         , nil );
}

-(JFFAsyncOperationBinder)scDataLoaderWithHttpBodyAndURL:( NSData* )httpBody_
{
    return ^JFFAsyncOperation( NSURL* url_ )
    {
        return [ self authedApiResponseDataLoaderForURL: url_
                                               httpBody: httpBody_
                                             httpMethod: nil
                                                headers: nil ];
    };
}

-(JFFAsyncOperationBinder)scDataLoaderWithURL
{
    return [ self scDataLoaderWithHttpBodyAndURL: nil ];
}

-(JFFAsyncOperation)uploadOperationForSCMediaPath:( NSString* )path_
                                cacheLifeTime:( NSTimeInterval )cacheLifeTime_
{
    return [ self uploadOperationForSCMediaPath: path_
                              cacheLifeTime: cacheLifeTime_
                                     params: nil ];
}

-(JFFAsyncOperation)uploadOperationForSCMediaPath:( NSString* )path_
                                cacheLifeTime:( NSTimeInterval )cacheLifeTime_
                                       params:( SCParams* )params_
{
    NSString* url_ = [ self->_urlBuilder urlStringForMediaItemAtPath: path_
                                                                host: self->_host
                                                        resizeParams: params_ ];

    JFFAsyncOperation loader_ = imageLoaderForURLString( url_, cacheLifeTime_ );
    JFFPropertyPath* propertyPath_ = [ [ JFFPropertyPath alloc ] initWithName: @"imagesCache"
                                                                          key: url_ ];

    return [ self asyncOperationForPropertyWithPath: propertyPath_
                                     asyncOperation: loader_ ];
}

-(JFFAsyncOperation)readItemsOperationWithRequest:( SCReadItemsRequest * )request_
                                apiSession:( SCExtendedApiSession* )apiSession_
{
    NSLog(@"lifeTimeInCache %f", request_.lifeTimeInCache);

    SCReaderRequestUrlBuilder* builder = [ self urlBuilderForReaderRequest: request_ ];
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        NSString* result = [ builder getRequestUrl ];
        return [ NSURL URLWithString: result ];
    };

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiSessionAndRequest( apiSession_, request_ );

    id< SCDataCache > cache_ = nil;
    if ( !( request_.flags & SCReadItemRequestIngnoreCache ) )
    {
        cache_ = [ SCSrvResponseCachesFactory sharedSrvResponseCache ];
    }

    id(^keyForURL_)(NSURL*) = ^id( NSURL* url_ )
    {
        NSString* str_ = [ url_ description ];
        str_ = [ str_ stringByAppendingFormat: @"&login=%@"   , self->_login    ?: @"" ];
        return str_;
    };

    NSLog(@"lifeTimeInCache %f", request_.lifeTimeInCache);
    return scSmartDataLoaderWithCache( urlBuilder_
                                      , [ self scDataLoaderWithURL ]
                                      , analyzerForData_
                                      , cache_
                                      , keyForURL_
                                      , request_.lifeTimeInCache );
}

-(JFFAsyncOperation)createItemsOperationWithRequest:( SCCreateItemRequest* )createItemRequest_
                                apiSession:( SCExtendedApiSession* )apiSession_
{
    SCItemCreatorUrlBuilder* builder = [ self urlBuilderForCreateItemRequest: createItemRequest_ ];
    NSString* result = [ builder getRequestUrl ];
    NSURL* url_ = [ NSURL URLWithString: result ];
    
    
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        return url_;
    };

    NSData* httpBody_ = [ NSData editFieldsBodyWithFieldsDict: createItemRequest_.fieldsRawValuesByName
                                                          url: url_ ];

    JFFAsyncOperationBinder dataLoaderForURL_ = [ self scDataLoaderWithHttpBodyAndURL: httpBody_ ];

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiSessionAndRequest( apiSession_, createItemRequest_ );

    return scSmartDataLoader( urlBuilder_, dataLoaderForURL_, analyzerForData_ );
}

-(JFFAsyncOperation)jsonDataLoaderForEditItemsRequest:( SCEditItemsRequest* )editItemsRequest_
                                                  url:( NSURL* )url_
{
    NSData* httpBody_ = [ NSData editFieldsBodyWithFieldsDict: editItemsRequest_.fieldsRawValuesByName
                                                          url: url_ ];

    NSString* httpMethod_  = @"PUT";
    NSDictionary* headers_ = @{ @"Content-Type" : @"application/x-www-form-urlencoded" };

    return [ self authedApiResponseDataLoaderForURL: url_
                                           httpBody: httpBody_
                                         httpMethod: httpMethod_
                                            headers: headers_ ];
}

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )editItemsRequest_
                                    apiSession:( SCExtendedApiSession* )apiSession_
{
    SCReaderRequestUrlBuilder* builder = [ self urlBuilderForReaderRequest: editItemsRequest_ ];
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        NSString* result = [ builder getRequestUrl ];
        return [ NSURL URLWithString: result ];
    };

    JFFAsyncOperationBinder dataLoaderForURL_ = ^JFFAsyncOperation( NSURL* url_ )
    {
        return [ self jsonDataLoaderForEditItemsRequest: editItemsRequest_
                                                    url: url_ ];
    };

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiSessionAndRequest( apiSession_, editItemsRequest_ );

    return scSmartDataLoader( urlBuilder_, dataLoaderForURL_, analyzerForData_ );
}

-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCReadItemsRequest * )removeItemsRequest_
                                      apiSession:( SCExtendedApiSession* )apiSession_;
{
    SCReaderRequestUrlBuilder* builder = [ self urlBuilderForReaderRequest: removeItemsRequest_ ];
    
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        NSString* result = [ builder getRequestUrl ];
        return [ NSURL URLWithString: result ];
    };
    
    
    JFFAsyncOperationBinder dataLoaderForURL_ = ^JFFAsyncOperation( NSURL* url_ )
    {
        return [ self authedApiResponseDataLoaderForURL: url_
                                               httpBody: nil
                                             httpMethod: @"DELETE"
                                                headers: nil ];
    };

    JFFAsyncOperationBinder(^analyzerForData_)( NSURL* ) =
    ^JFFAsyncOperationBinder( NSURL* url_ )
    {
        return ^JFFAsyncOperation( NSData* responseData_ )
        {
            JFFAsyncOperation loader_ = webApiJSONAnalyzer( url_, responseData_ );

            return bindSequenceOfAsyncOperations( loader_
                                                 , deleteItemsJSONResponseParser( responseData_ )
                                                 , nil );
        };
    };

    return scSmartDataLoader( urlBuilder_, dataLoaderForURL_, analyzerForData_ );
}

-(JFFAsyncOperation)uploadMediaOperationWithRequest:( SCUploadMediaItemRequest * )request_
                                     apiSession:( SCExtendedApiSession* )apiSession_
{
    SCCreateMediaRequestUrlBuilder* builder = [ self urlBuilderForCreateMediaRequest: request_ ];
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        NSString* result = [ builder getRequestUrl ];
        return [ NSURL URLWithString: result ];
    };

    JFFAsyncOperationBinder dataLoaderForURL_ = ^JFFAsyncOperation( NSURL* url_ )
    {
        NSString* boundaryId_     = [ NSString multipartFormDataBoundary ];
        NSString* boundaryHeader_ = [ [ NSString alloc ] initWithFormat: @"multipart/form-data; boundary=%@", boundaryId_ ];

        NSData* httpBody_ = [ request_.mediaItemData multipartFormDataWithBoundary: boundaryId_
                                                                          fileName: request_.fileName
                                                                       contentType: request_.contentType ];

        NSDictionary* headers_ = @{ @"Content-Type" : boundaryHeader_ };

        return [ self authedApiResponseDataLoaderForURL: url_
                                               httpBody: httpBody_
                                             httpMethod: @"POST"
                                                headers: headers_ ];
    };

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiSessionAndRequest( apiSession_, request_ );

    return scSmartDataLoader( urlBuilder_, dataLoaderForURL_, analyzerForData_ );
}

-(JFFAsyncOperation)renderingHTMLLoaderForRequest:( SCGetRenderingHtmlRequest * )request_
                                       apiSession:( SCExtendedApiSession* )apiSession_
{
    SCHTMLRenderingRequestUrlBuilder *urlBuilder = [ self urlBuilderForHTMLRenderingRequest: request_ ];
    
    NSString* urlString = [ urlBuilder getRequestUrl ];
    // NSLog( @"[renderingHTMLLoaderForRequest] : %@", urlString );
    
    NSURL * url_ = [ NSURL URLWithString: urlString ];
    
    return [ self renderingWithUrl: url_ ];

}

-(JFFAsyncOperation)triggerLoaderWithRequest:( SCTriggeringRequest* )request_
{
    
    return [ SCTriggerExecutor triggerLoaderWithRequest: request_
                                                   host: self->_host ];
}

-(JFFAsyncOperation)renderingWithUrl:( NSURL * )url_
{
    if ( !url_ )
    {
        // TODO : add a proper internal error class
        return asyncOperationWithError( [ SCApiError new ] );
    }
    
    JFFAsyncOperationBinder parser_ = ^JFFAsyncOperation( NSData* serverData_ )
    {
        JFFSyncOperation loadDataBlock_ = ^id( NSError** outError_ )
        {
            NSParameterAssert( [ serverData_ isKindOfClass: [ NSData class ] ] );
            
            NSString* result_ = [ [ NSString alloc ] initWithData: serverData_
                                                         encoding: NSUTF8StringEncoding ];
            if ( !result_ )
            {
                SCInvalidResponseFormatError* error_ = [ SCInvalidResponseFormatError new ];
                error_.responseData = serverData_;
                [ error_ setToPointer: outError_ ];
                return nil;
            }
            return result_;
        };
        
        return asyncOperationWithSyncOperation( loadDataBlock_ );
    };
    
    if ( !url_ )
    {
        return asyncOperationWithError( [ SCApiError new ] );
    }
    
    return bindSequenceOfAsyncOperations( [ self scDataLoaderWithURL ]( url_ )
                                         , parser_
                                         , nil );
}

-(SCHTMLRenderingRequestUrlBuilder*)urlBuilderForHTMLRenderingRequest:( SCGetRenderingHtmlRequest * )request
{
    SCHTMLRenderingRequestUrlBuilder* builder =
    [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: self->_host
                                                webApiVersion:self->_urlBuilder.webApiVersion
                                                restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                      request:request ];
    
    return builder;
}

-(SCReaderRequestUrlBuilder*)urlBuilderForReaderRequest:( SCReadItemsRequest * )request
{
    SCReaderRequestUrlBuilder* builder =
    [ [ SCReaderRequestUrlBuilder alloc ] initWithHost: self->_host
                                         webApiVersion: self->_urlBuilder.webApiVersion
                                         restApiConfig: [ SCWebApiConfig webApiV1Config ]
                                               request: request ];
    
    return builder;
}

-(SCCreateMediaRequestUrlBuilder*)urlBuilderForCreateMediaRequest:( SCUploadMediaItemRequest * )request
{
    SCCreateMediaRequestUrlBuilder* builder =
    [ [ SCCreateMediaRequestUrlBuilder alloc ] initWithHost: self->_host
                                              webApiVersion: self->_urlBuilder.webApiVersion
                                              restApiConfig: [ SCWebApiConfig webApiV1Config ]
                                                    request: request ];
    
    return builder;
}

-(SCItemCreatorUrlBuilder*)urlBuilderForCreateItemRequest:( SCCreateItemRequest* )request
{
    SCItemCreatorUrlBuilder* builder =
    [ [ SCItemCreatorUrlBuilder alloc ] initWithHost: self->_host
                                       webApiVersion: self->_urlBuilder.webApiVersion
                                       restApiConfig: [ SCWebApiConfig webApiV1Config ]
                                             request: request ];
    
    return builder;
}

-(NSString*)host
{
    return self->_host;
}

-(NSString*)login
{
    return self->_login;
}

@end
