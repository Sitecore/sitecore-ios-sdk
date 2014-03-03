#import "SCPagedItems.h"

#import "SCError.h"
#import "SCItemsPage.h"
#import "SCApiSession.h"
#import "SCExtendedApiSession.h"
#import "SCReadItemsRequest.h"

@interface SCExtendedApiSession (SCPagedItems)

-(JFFAsyncOperation)privateItemsPageLoaderWithRequest:( SCReadItemsRequest * )request_;

@end

@interface SCPagedItems ()

@property ( nonatomic ) SCApiSession * apiSession;
@property ( nonatomic ) NSMutableDictionary* itemsByPageNumber;

@end

@implementation SCPagedItems
{
    NSNumber* _totalItemsCount;
    SCReadItemsRequest * _requestTemplate;
}

-(id)initWithApiSession:( SCApiSession * )apiSession_
                request:( SCReadItemsRequest * )request_
{
    self = [ super init ];

    if ( self )
    {
        _apiSession        = apiSession_;
        _requestTemplate   = [ request_ copy ];
        _itemsByPageNumber = [ NSMutableDictionary new ];
    }

    return self;
}

+(id)pagedItemsWithApiSession:(SCApiSession *)apiSession_
                     pageSize:(NSUInteger)pageSize_
                        query:(NSString *)query_
{
    SCReadItemsRequest * request_ = [SCReadItemsRequest new];
    request_.request     = query_;
    request_.requestType = SCReadItemRequestQuery;
    request_.pageSize    = pageSize_;
    request_.fieldNames  = [ NSSet new ];

    return [ self pagedItemsWithApiSession: apiSession_
                                   request: request_ ];
}

+(id)pagedItemsWithApiSession:( SCApiSession * )apiSession_
                      request:( SCReadItemsRequest * )request_
{
    NSParameterAssert( apiSession_ );
    NSParameterAssert( request_.pageSize != 0 );

    return [ [ self alloc ] initWithApiSession: apiSession_
                                       request: request_ ];
}

-(NSUInteger)pageSize
{
    return _requestTemplate.pageSize;
}

-(JFFAsyncOperation)pageLoaderForPage:( NSUInteger )pageNumber_
{
    SCReadItemsRequest * request_ = [ _requestTemplate copy ];
    request_.page = pageNumber_;

    JFFAsyncOperation loader_ = ^( JFFAsyncOperationProgressHandler progressCallback_
                                  , JFFCancelAsyncOperationHandler cancelCallback_
                                  , JFFDidFinishAsyncOperationHandler doneCallback_ )
    {
        JFFAsyncOperation loader_ = [ _apiSession.extendedApiSession privateItemsPageLoaderWithRequest: request_ ];

        JFFAsyncOperationBinder totalCountBinder_ = asyncOperationBinderWithAnalyzer( ^id( SCItemsPage* page_
                                                                                          , NSError **error_)
        {
           if ( page_ )
               self->_totalItemsCount = @( page_.totalCount );

           return page_.items;
        });
        loader_ = bindSequenceOfAsyncOperations( loader_, totalCountBinder_, nil );

        return loader_( progressCallback_
                       , cancelCallback_
                       , doneCallback_ );
    };

    JFFPropertyPath* propertPath_ = [ [ JFFPropertyPath alloc ] initWithName: @"itemsByPageNumber"
                                                                         key: @( pageNumber_ ) ];
    return [ self asyncOperationForPropertyWithPath: propertPath_
                                     asyncOperation: loader_ ];
}

-(SCItem*)itemForIndex:( NSUInteger )index_
{
    if ( 0 == self.pageSize )
    {
        NSLog( @"[!!!WARNING!!!] : [SCPagedItems itemForIndex:] - division by zero" );
        return nil;
    }
    
    NSNumber* page_       = @( index_ / self.pageSize );
    NSArray* itemsPage_   = self->_itemsByPageNumber[ page_ ];
    NSUInteger pageIndex_ = index_ % self.pageSize;
    if ( [ itemsPage_ count ] > pageIndex_ )
    {
        return itemsPage_[ pageIndex_ ];
    }
    return nil;
}

-(JFFAsyncOperation)itemLoaderForIndex:( NSUInteger )index_
{
    JFFAsyncOperation pageLoader_ = [ self pageLoaderForPage: index_ / self.pageSize ];

    JFFAnalyzer analyzer_ = ^id( NSArray* items_, NSError **error_ )
    {
        if ( 0 != self.pageSize )
        {
            NSUInteger pageIndex_ = index_ % self.pageSize;

            if ( [ items_ count ] > pageIndex_ )
            {
                return items_[ pageIndex_ ];
            }
        }
        else
        {
            NSLog( @"[!!!WARNING!!!] : [SCPagedItems itemLoaderForIndex:] - division by zero" );
            return nil;
        }
        
        [ [ SCNoItemError new ] setToPointer: error_ ];
        return nil;
    };

    JFFAsyncOperationBinder parsePagesBinder_ =  asyncOperationBinderWithAnalyzer( analyzer_ );

    return bindSequenceOfAsyncOperations( pageLoader_, parsePagesBinder_, nil );
}

-(SCAsyncOp)itemsTotalCountReader
{
    return asyncOpWithJAsyncOp( [ self extendedItemsTotalCountReader ] );
}

-(SCExtendedAsyncOp)extendedItemsTotalCountReader
{
    JFFAsyncOperation loader_ = [ self itemLoaderForIndex: 0 ];
    loader_ = asyncOperationWithChangedResult( loader_, ^id( id result_ ) { return _totalItemsCount; } );
    return loader_;
}


-(SCAsyncOp)itemReaderForIndex:( NSUInteger )index_
{
    return asyncOpWithJAsyncOp( [ self itemLoaderForIndex: index_ ] );
}

-(SCExtendedAsyncOp)extendedItemReaderForIndex:( NSUInteger )index_
{
    return [ self itemLoaderForIndex: index_ ];
}

@end
