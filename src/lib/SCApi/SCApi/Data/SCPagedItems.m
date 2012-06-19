#import "SCPagedItems.h"

#import "SCError.h"
#import "SCItemsPage.h"
#import "SCApiContext.h"
#import "SCItemsReaderRequest.h"

@interface SCApiContext (SCPagedItems)

-(JFFAsyncOperation)privateItemsPageLoaderWithRequest:( SCItemsReaderRequest* )request_;

@end

@interface SCPagedItems ()

@property ( nonatomic ) SCApiContext* apiContext;
@property ( nonatomic ) NSMutableDictionary* itemsByPageNumber;

@end

@implementation SCPagedItems
{
    NSNumber* _totalItemsCount;
    SCItemsReaderRequest* _requestTemplate;
}

@synthesize apiContext        = _apiContext;
@synthesize itemsByPageNumber = _itemsByPageNumber;

-(id)initWithApiContext:( SCApiContext* )apiContext_
                request:( SCItemsReaderRequest* )request_
{
    self = [ super init ];

    if ( self )
    {
        _apiContext        = apiContext_;
        _requestTemplate   = [ request_ copy ];
        _itemsByPageNumber = [ NSMutableDictionary new ];
    }

    return self;
}

+(id)pagedItemsWithApiContext:(SCApiContext *)apiContext_
                     pageSize:(NSUInteger)pageSize_
                        query:(NSString *)query_
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
    request_.request     = query_;
    request_.requestType = SCItemReaderRequestQuery;
    request_.pageSize    = pageSize_;
    request_.fieldNames  = [ NSSet new ];

    return [ self pagedItemsWithApiContext: apiContext_
                                   request: request_ ];
}

+(id)pagedItemsWithApiContext:( SCApiContext* )apiContext_
                      request:( SCItemsReaderRequest* )request_
{
    NSParameterAssert( apiContext_ );
    NSParameterAssert( request_.pageSize != 0 );

    return [ [ self alloc ] initWithApiContext: apiContext_
                                       request: request_ ];
}

-(NSUInteger)pageSize
{
    return _requestTemplate.pageSize;
}

-(JFFAsyncOperation)pageLoaderForPage:( NSUInteger )pageNumber_
{
    SCItemsReaderRequest* request_ = [ _requestTemplate copy ];
    request_.page = pageNumber_;

    JFFAsyncOperation loader_ = ^( JFFAsyncOperationProgressHandler progressCallback_
                                  , JFFCancelAsyncOperationHandler cancelCallback_
                                  , JFFDidFinishAsyncOperationHandler doneCallback_ )
    {
        JFFAsyncOperation loader_ = [ _apiContext privateItemsPageLoaderWithRequest: request_ ];

        JFFAsyncOperationBinder totalCountBinder_ = asyncOperationBinderWithAnalyzer( ^id( SCItemsPage* page_
                                                                                          , NSError **error_)
        {
           if ( page_ )
               _totalItemsCount = [ NSNumber numberWithUnsignedInt: page_.totalCount ];

           return page_.items;
        });
        loader_ = bindSequenceOfAsyncOperations( loader_, totalCountBinder_, nil );

        return loader_( progressCallback_
                       , cancelCallback_
                       , doneCallback_ );
    };

    JFFPropertyPath* propertPath_ = [ [ JFFPropertyPath alloc ] initWithName: @"itemsByPageNumber"
                                                                         key: [ NSNumber numberWithInt: pageNumber_ ] ];
    return [ self asyncOperationForPropertyWithPath: propertPath_
                                     asyncOperation: loader_ ];
}

-(SCItem*)itemForIndex:( NSUInteger )index_
{
    NSNumber* page_       = [ NSNumber numberWithUnsignedInteger: index_ / self.pageSize ];
    NSArray* itemsPage_   = [ _itemsByPageNumber objectForKey: page_ ];
    NSUInteger pageIndex_ = index_ % self.pageSize;
    if ( [ itemsPage_ count ] > pageIndex_ )
    {
        return [ itemsPage_ objectAtIndex: pageIndex_ ];
    }
    return nil;
}

-(JFFAsyncOperation)itemLoaderForIndex:( NSUInteger )index_
{
    JFFAsyncOperation pageLoader_ = [ self pageLoaderForPage: index_ / self.pageSize ];

    JFFAnalyzer analyzer_ = ^id( NSArray* items_, NSError **error_ )
    {
        NSUInteger pageIndex_ = index_ % self.pageSize;

        if ( [ items_ count ] > pageIndex_ )
            return [ items_ objectAtIndex: pageIndex_ ];

        if ( error_ )
            *error_ = [ SCNoItemError new ];

        return nil;
    };

    JFFAsyncOperationBinder parsePagesBinder_ =  asyncOperationBinderWithAnalyzer( analyzer_ );

    return bindSequenceOfAsyncOperations( pageLoader_, parsePagesBinder_, nil );
}

-(SCAsyncOp)itemsTotalCountReader
{
    JFFAsyncOperation loader_ = [ self itemLoaderForIndex: 0 ];
    loader_ = asyncOperationWithChangedResult( loader_, ^id( id result_ ) { return _totalItemsCount; } );
    return asyncOpWithJAsyncOp( loader_ );
}

-(SCAsyncOp)itemReaderForIndex:( NSUInteger )index_
{
    return asyncOpWithJAsyncOp( [ self itemLoaderForIndex: index_ ] );
}

@end
