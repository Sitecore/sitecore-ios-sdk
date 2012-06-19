#import <SCApi/SmartDataLoaders/SCDataCache.h>

#import <Foundation/Foundation.h>

#import <SCApi/Utils/JSBlocksDefinitions.h>

JFFAsyncOperation scSmartDataLoader( NSURL*(^urlBuilder_)(void)
                                    , JFFAsyncOperationBinder dataLoaderForURL_
                                    , SCAsyncBinderForURL analyzerForData_ );

JFFAsyncOperation scSmartDataLoaderWithCache( NSURL*(^urlBuilder_)(void)
                                             , JFFAsyncOperationBinder dataLoaderForURL_
                                             , SCAsyncBinderForURL analyzerForData_
                                             , id< SCDataCache > cache_
                                             , id(^keyForURL_)(NSURL*)
                                             , NSTimeInterval lifeTime_ );

JFFAsyncOperation imageLoaderForURLString( NSString* urlString_
                                          , NSTimeInterval cacheLifeTime_ );
SCAsyncOp imageReaderForURLString( NSString* urlString_
                                  , NSTimeInterval cacheLifeTime_ );
