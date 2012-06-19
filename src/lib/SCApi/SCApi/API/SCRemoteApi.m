#import "SCRemoteApi.h"

#import "SCError.h"
#import "SCApiContext.h"
#import "SCEditItemsRequest.h"
#import "SCCreateItemRequest.h"

#import "SCWebApiParsers.h"
#import "SCApiUtils.h"
#import "SCSmartDataLoaders.h"

#import "SCSrvResponseCaches.h"

#import "NSURL+URLWithItemsReaderRequest.h"
#import "NSData+EditFieldsBodyWithFieldsDict.h"

#import <JFFCache/JFFCache.h>

@interface SCRemoteApi ()

//JTODO use imagesCache in JFFImageCache
@property ( nonatomic ) NSCache* imagesCache;

@end

@implementation SCRemoteApi
{
    NSString* _host;
    NSString* _login;
    NSString* _password;
}

@synthesize imagesCache = _imagesCache;

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
{
    self = [ super init ];

    if ( self )
    {
        _host        = host_;
        _login       = login_;
        _password    = password_;
        _imagesCache = [ NSCache new ];
    }

    return self;
}

-(JFFAsyncOperationBinder)scDataLoaderWithHttpBodyAndURL:( NSData* )httpBody_
{
    return ^JFFAsyncOperation( NSURL* url_ )
    {
        return scDataURLResponseLoader( url_, _login, _password, httpBody_, nil, nil );
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
        NSString* host_ = [ [ _host pathComponents ] noThrowObjectAtIndex: 0 ];
        url_ = [ NSString stringWithFormat: @"http://%@/~/media%@.ashx", host_, path_ ];
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
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        return [ NSURL URLWithItemsReaderRequest: request_
                                            host: _host ];
    };

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiCntext( apiContext_ );

    id< SCDataCache > cache_ = nil;
    if ( !( request_.flags & SCItemReaderRequestIngnoreCache ) )
    {
        cache_ = sharedSrvResponseCache();
    }

    id(^keyForURL_)(NSURL*) = ^id( NSURL* url_ )
    {
        NSString* str_ = [ url_ description ];
        str_ = [ str_ stringByAppendingFormat: @"&login=%@"   , _login    ?: @"" ];
        str_ = [ str_ stringByAppendingFormat: @"&password=%@", _password ?: @"" ];
        return str_;
    };

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
                                                host: _host ];

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
    NSDictionary* headers_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                              @"application/x-www-form-urlencoded", @"Content-Type"
                              , nil ];

    return scDataURLResponseLoader( url_
                                   , _login
                                   , _password
                                   , httpBody_
                                   , httpMethod_
                                   , headers_ );
}

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )editItemsRequest_
                                    apiContext:( SCApiContext* )apiContext_
{
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        return [ NSURL URLToEditItemsWithRequest: editItemsRequest_
                                            host: _host ];
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
                                            host: _host ];
    };

    JFFAsyncOperationBinder dataLoaderForURL_ = ^JFFAsyncOperation( NSURL* url_ )
    {
        return scDataURLResponseLoader( url_, _login, _password, nil, @"DELETE", nil );
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
                                                  host: _host
                                            apiContext: apiContext_ ];
    };

    JFFAsyncOperationBinder dataLoaderForURL_ = createMediaItemRequestDataLoader( request_
                                                                                 , _login
                                                                                 , _password );

    SCAsyncBinderForURL analyzerForData_ = itemsJSONResponseAnalyzerWithApiCntext( apiContext_ );

    return scSmartDataLoader( urlBuilder_, dataLoaderForURL_, analyzerForData_ );
}

//STODO!! refactor and test!!!
-(JFFAsyncOperation)renderingHTMLLoaderForRenderingId:( NSString* )rendereringId_
                                             sourceId:( NSString* )sourceId_
                                           apiContext:( SCApiContext* )apiContext_
{
    JFFAsyncOperationBinder parser_ = ^JFFAsyncOperation( id serverData_ )
    {
        JFFSyncOperation loadDataBlock_ = ^id( NSError** outError_ )
        {
            NSString* result_ = [ [ NSString alloc ] initWithData: serverData_ encoding: NSUTF8StringEncoding ];
            if ( !result_ )
            {
                SCInvalidResponseFormatError* error_ = [ SCInvalidResponseFormatError error ];
                error_.responseData = serverData_;
                [ error_ setToPointer: outError_ ];
                return nil;
            }
            return result_;
        };

        return asyncOperationWithSyncOperation( loadDataBlock_ );
    };

    NSURL* url_ = [ NSURL URLToGetRenderingHTMLLoaderForRenderingId: rendereringId_
                                                           sourceId: sourceId_ 
                                                               host: _host
                                                         apiContext: apiContext_ ];

    if ( !url_ )
        return asyncOperationWithError( [ SCError error ] );

    return bindSequenceOfAsyncOperations( [ self scDataLoaderWithURL ]( url_ )
                                         , parser_
                                         , nil );
}

@end
