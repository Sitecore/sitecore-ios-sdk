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
    JFFSmartUrlDataLoaderFields* args_ = [ JFFSmartUrlDataLoaderFields new ];
    args_.urlBuilder        = urlBuilder_;
    args_.dataLoaderForURL  = dataLoaderForURL_;
    args_.analyzerForData   = analyzerForData_;
    args_.cache             = (id< JFFRestKitCache >)cache_;
    args_.cacheKeyForURL    = keyForURL_;
    args_.cacheDataLifeTime = lifeTime_;

    JFFAsyncOperation loader_ = jSmartDataLoaderWithCache( args_ );

    JFFChangedErrorBuilder errorBuilder_ = ^NSError*(NSError* error_)
    {
        if ( [ error_ isMemberOfClass: [ JFFRestKitNoURLError class ] ] )
            return [ SCError error ];

        return error_;
    };

    return asyncOperationWithChangedError( loader_, errorBuilder_ );
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
        return dataURLResponseLoader( url_, nil, nil );
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

    id< SCDataCache > cache_ = sharedSrvResponseCache();

    JFFAsyncOperation loader_ =  scSmartDataLoaderWithCache( urlBuilder_
                                                             , dataLoaderForURL_
                                                             , analyzerForData_
                                                             , cache_
                                                             , nil
                                                             , cacheLifeTime_ );

    JFFChangedErrorBuilder errorBuilder_ = ^NSError*(NSError* error_)
    {
        if ( [ error_ isMemberOfClass: [ SCError class ] ] )
            return [ SCInvalidPathError error ];

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
