#import "SCSmartDataLoaders.h"

#import "SCError.h"

#import "SCSrvResponseCaches.h"

JFFAsyncOperation scSmartDataLoader( NSURL*(^urlBuilder_)(void)
                                    , JFFAsyncOperationBinder dataLoaderForURL_
                                    , SCAsyncBinderForURL analyzerForData_ )
{
    return scSmartDataLoaderWithCache( urlBuilder_
                                      , dataLoaderForURL_
                                      , analyzerForData_
                                      , nil
                                      , nil
                                      , 0. );
}

JFFAsyncOperation scSmartDataLoaderWithCache( NSURL*(^urlBuilder_)(void)
                                             , JFFAsyncOperationBinder dataLoaderForURL_
                                             , SCAsyncBinderForURL analyzerForData_
                                             , id< SCDataCache > cache_
                                             , id(^keyForURL_)(NSURL*)
                                             , NSTimeInterval lifeTime_ )
{
    urlBuilder_       = [ urlBuilder_       copy ];
    dataLoaderForURL_ = [ dataLoaderForURL_ copy ];
    analyzerForData_  = [ analyzerForData_  copy ];
    keyForURL_        = [ keyForURL_        copy ];

    return ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                    , JFFCancelAsyncOperationHandler cancelCallback_
                                    , JFFDidFinishAsyncOperationHandler doneCallback_ )
    {
        NSURL* url_ = urlBuilder_();
        NSLog( @"start load data with url: %@", url_ );

        SCAsyncBinderForURL analyzerForData2_ = ^JFFAsyncOperationBinder( NSURL* url_ )
        {
            JFFAsyncOperationBinder binder_ = analyzerForData_( url_ );
            return ^JFFAsyncOperation( NSData* result_ )
            {
                NSString* responseStr_ = [ [ NSString alloc ] initWithData: result_ encoding: NSUTF8StringEncoding ];
                NSLog( @"finish load data: %@ for url: %@", responseStr_, url_ );
                return binder_( result_ );
            };
        };

        JFFSmartUrlDataLoaderFields* args_ = [ JFFSmartUrlDataLoaderFields new ];
        
        args_.loadDataIdentifier        = urlBuilder_();
        args_.dataLoaderForIdentifier  = dataLoaderForURL_;
        args_.analyzerForData   = analyzerForData2_;
        args_.cache             = (id< JFFRestKitCache >)cache_;
        args_.cacheKeyForIdentifier    = keyForURL_;
        args_.cacheDataLifeTimeInSeconds = lifeTime_;


        JFFAsyncOperation loader_ = jSmartDataLoaderWithCache( args_ );

        JFFChangedErrorBuilder errorBuilder_ = ^NSError*(NSError* error_)
        {
            if ( [ error_ isMemberOfClass: [ JFFRestKitError class ] ] )
            {
                return [ SCApiError new ];
            }

            return error_;
        };

        loader_ = asyncOperationWithChangedError( loader_, errorBuilder_ );

        return loader_( progressCallback_
                       , cancelCallback_
                       , doneCallback_ );
    };
}

JFFAsyncOperation imageLoaderForURLString( NSString* urlString_
                                          , NSTimeInterval cacheLifeTime_ )
{
    NSURL*(^urlBuilder_)(void) = ^NSURL*()
    {
        //STODO remove stringByReplacingPercentEscapesUsingEncoding
        NSString* url_ = [ urlString_ stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
        url_ = [ url_ stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
        return [ NSURL URLWithString: url_ ];
    };

    JFFAsyncOperationBinder dataLoaderForURL_ = ^JFFAsyncOperation( NSURL* url_ )
    {
        return asyncOperationWithChangedError(
            dataURLResponseLoader( url_, nil, nil ),
            ^NSError* (NSError *error)
            {
                SCNotImageFound* result = [ SCNotImageFound new ];
                result.underlyingError = error;
                
                return result;
            } );
    };

    SCAsyncBinderForURL analyzerForData_ = ^JFFAsyncOperationBinder( NSURL* url_ )
    {
        JFFAnalyzer analyzer_ = ^id( id data_, NSError** outError_ )
        {
            //STODO parse in separate thread ???
            id result_ = [ UIImage imageWithData: data_ ];

            if ( !result_ && outError_ )
            {
                SCNotImageFound* error_ = [ SCNotImageFound new ];
                error_.responseData = data_;
                *outError_ = error_;
            }

            return result_;
        };
        return asyncOperationBinderWithAnalyzer( analyzer_ );
    };

    id< SCDataCache > cache_ = [ SCSrvResponseCachesFactory sharedSrvResponseCache ];

    JFFAsyncOperation loader_ =  scSmartDataLoaderWithCache( urlBuilder_
                                                             , dataLoaderForURL_
                                                             , analyzerForData_
                                                             , cache_
                                                             , nil
                                                             , cacheLifeTime_ );

    JFFChangedErrorBuilder errorBuilder_ = ^NSError*(NSError* error_)
    {
        if ( [ error_ isMemberOfClass: [ SCApiError class ] ] )
            return [ SCInvalidPathError new ];

        return error_;
    };
    loader_ = asyncOperationWithChangedError( loader_, errorBuilder_ );

    return loader_;
}

SCAsyncOp imageReaderForURLString( NSString* urlString_
                                  , NSTimeInterval cacheLifeTime_ )
{
    JFFAsyncOperation loader_ = imageLoaderForURLString( urlString_
                                                        , cacheLifeTime_ );
    return asyncOpWithJAsyncOp( loader_ );
}
