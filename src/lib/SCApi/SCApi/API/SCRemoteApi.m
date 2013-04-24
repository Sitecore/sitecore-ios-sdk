#import "SCRemoteApi.h"

#import "SCError.h"
#import "SCApiContext.h"
#import "SCEditItemsRequest.h"
#import "SCCreateItemRequest.h"

#import "SCWebApiParsers.h"
#import "SCApiUtils.h"
#import "SCSmartDataLoaders.h"

#import "SCSrvResponseCaches.h"
#import "SCCreateMediaItemRequest.h"

#import "NSURL+URLWithItemsReaderRequest.h"
#import "NSData+EditFieldsBodyWithFieldsDict.h"
#import "SCSitecoreCredentials+XMLParser.h"
#import "NSString+MultipartFormDataBoundary.h"
#import "NSData+MultipartFormDataWithBoundary.h"

#import "SCTriggeringImplRequest.h"
#import "SCTriggerExecutor.h"

//#import <JFFCache/JFFCache.h>

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
}

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
{
    self = [ super init ];

    if ( self )
    {
        self->_host        = host_;
        self->_login       = login_;
        self->_password    = password_;
        self->_imagesCache = [ NSCache new ];
    }

    return self;
}

-(JFFAsyncOperation)credentioalsLoader
{
    JFFAsyncOperation credentioalsLoader_;

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
        NSURL* credentioalsURL_ = [ NSURL URLToGetSecureKeyForHost: self->_host ];
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

-(JFFAsyncOperation)imageLoaderForSCMediaPath:( NSString* )path_
                                cacheLifeTime:( NSTimeInterval )cacheLifeTime_
{
    path_ = [ path_ stringWithCutPrefix: @"/sitecore/media library" ];

    NSString* url_ = nil;
    if ( [ path_ length ] != 0 )
    {
        NSString* host_ = [ [ self->_host pathComponents ] noThrowObjectAtIndex: 0 ];
        url_ = [ [ NSString alloc ] initWithFormat: @"http://%@/~/media%@.ashx", host_, path_ ];
    }

    JFFAsyncOperation loader_ = imageLoaderForURLString( url_, cacheLifeTime_ );
    JFFPropertyPath* propertyPath_ = [ [ JFFPropertyPath alloc ] initWithName: @"imagesCache"
                                                                          key: path_ ];

    return [ self asyncOperationForPropertyWithPath: propertyPath_
                                     asyncOperation: loader_ ];
}

-(JFFAsyncOperation)itemsReaderWithRequest:( SCItemsReaderRequest* )request_
                                apiContext:( SCApiContext* )apiContext_
{
    NSLog(@"lifeTimeInCache %f", request_.lifeTimeInCache);
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        return [ NSURL URLWithItemsReaderRequest: request_
                                            host: self->_host ];
    };

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiCntext( apiContext_ );

    id< SCDataCache > cache_ = nil;
    if ( !( request_.flags & SCItemReaderRequestIngnoreCache ) )
    {
        cache_ = [ SCSrvResponseCachesFactory sharedSrvResponseCache ];
    }

    id(^keyForURL_)(NSURL*) = ^id( NSURL* url_ )
    {
        NSString* str_ = [ url_ description ];
        str_ = [ str_ stringByAppendingFormat: @"&login=%@"   , self->_login    ?: @"" ];
        str_ = [ str_ stringByAppendingFormat: @"&password=%@", self->_password ?: @"" ];
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

-(JFFAsyncOperation)itemCreatorWithRequest:( SCCreateItemRequest* )createItemRequest_
                                apiContext:( SCApiContext* )apiContext_
{
    NSURL* url_ = [ NSURL URLToCreateItemWithRequest: createItemRequest_
                                                host: self->_host ];

    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        return url_;
    };

    NSData* httpBody_ = [ NSData editFieldsBodyWithFieldsDict: createItemRequest_.fieldsRawValuesByName
                                                          url: url_ ];

    JFFAsyncOperationBinder dataLoaderForURL_ = [ self scDataLoaderWithHttpBodyAndURL: httpBody_ ];

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiCntext( apiContext_ );

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
                                    apiContext:( SCApiContext* )apiContext_
{
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        return [ NSURL URLToEditItemsWithRequest: editItemsRequest_
                                            host: self->_host ];
    };

    JFFAsyncOperationBinder dataLoaderForURL_ = ^JFFAsyncOperation( NSURL* url_ )
    {
        return [ self jsonDataLoaderForEditItemsRequest: editItemsRequest_
                                                    url: url_ ];
    };

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiCntext( apiContext_ );

    return scSmartDataLoader( urlBuilder_, dataLoaderForURL_, analyzerForData_ );
}

-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCItemsReaderRequest* )removeItemsRequest_
                                      apiContext:( SCApiContext* )apiContext_;
{
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        return [ NSURL URLToEditItemsWithRequest: removeItemsRequest_
                                            host: self->_host ];
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

-(JFFAsyncOperation)mediaItemCreatorWithRequest:( SCCreateMediaItemRequest* )request_
                                     apiContext:( SCApiContext* )apiContext_
{
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        return [ NSURL URLToCreateMediaItemWithRequest: request_
                                                  host: self->_host
                                            apiContext: apiContext_ ];
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

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiCntext( apiContext_ );

    return scSmartDataLoader( urlBuilder_, dataLoaderForURL_, analyzerForData_ );
}

//STODO!! refactor and test!!!
-(JFFAsyncOperation)renderingHTMLLoaderForRenderingId:( NSString* )rendereringId_
                                             sourceId:( NSString* )sourceId_
                                           apiContext:( SCApiContext* )apiContext_
{

    NSURL* url_ = [ NSURL URLToGetRenderingHTMLLoaderForRenderingId: rendereringId_
                                                           sourceId: sourceId_ 
                                                               host: self->_host
                                                         apiContext: apiContext_ ];

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
        return asyncOperationWithError( [ SCError new ] );
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
        return asyncOperationWithError( [ SCError new ] );
    
    return bindSequenceOfAsyncOperations( [ self scDataLoaderWithURL ]( url_ )
                                         , parser_
                                         , nil );
}

@end
