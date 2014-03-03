#import "SCAsyncTestCase.h"

@interface NoItemErrorTestExtended : SCAsyncTestCase
@end

@implementation NoItemErrorTestExtended

-(void)testPagedItemReaderWithWrongPath
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
                request_.requestType = SCReadItemRequestItemPath;
                request_.scope       = SCReadItemChildrenScope;
                request_.request     = @"/sitecore/content/WrongItem/";
                request_.pageSize    = 2;

                pagedItems_ = [ SCPagedItems pagedItemsWithApiSession: apiContext_
                                                              request: request_ ];
            
                SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
                {
                    item_error_ = (SCApiError*) error_;
                    didFinishCallback_();
                };

                SCExtendedAsyncOp loader = [ pagedItems_ extendedItemReaderForIndex: 0 ];
                loader(nil, nil, doneHandler);
            
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
}

-(void)testPagedItemsCountReaderWithWrongID
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.requestType = SCReadItemRequestItemId;
            request_.scope       = SCReadItemChildrenScope;
            request_.request     = @"{AAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA}";
            request_.pageSize    = 1;
            
            pagedItems_ = [ SCPagedItems pagedItemsWithApiSession: apiContext_
                                                          request: request_ ];
            
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                item_error_ = (SCApiError*) error_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ pagedItems_ extendedItemsTotalCountReader ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidItemIdError  class ] ] == TRUE, @"OK" );
}

-(void)testItemChildrenRequestWithWrongQuery
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
   
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.request = @"/sitecore/content/Home/WrongItem/*[@@templatename='WrongTemplate']";
            request_.scope = SCReadItemChildrenScope;
            request_.requestType = SCReadItemRequestQuery;
            request_.fieldNames = [ NSSet new ];
        
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                products_items_ = items_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 0, @"OK" );
    
}

-(void)testItemSelfRequestWithWrongPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = 
            [ SCReadItemsRequest requestWithItemPath: @"/sitecore/content/WrongItem/"
                                           fieldsNames: nil
                                                 scope: SCReadItemSelfScope ];
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                products_items_ = items_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ == nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 0, @"OK" );
    
}

-(void)testItemParentRequestWithWrongId
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block SCApiError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = 
            [ SCReadItemsRequest requestWithItemId: @"{AAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA}"
                                         fieldsNames: [ NSSet new ]
                                               scope: SCReadItemParentScope ];
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                products_items_ = items_;
                response_error_ = (SCApiError*)error_;
                didFinishCallback_();
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ == nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ == nil, @"OK" );
    GHAssertTrue( response_error_  != nil, @"OK" );
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCInvalidItemIdError class ] ] == TRUE, @"OK" );
} 

-(void)testItemWithWrongPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
            
            item_ = [ apiContext_.extendedApiSession itemWithPath: @"/sitecore/content/WrongItem/"
                                                       itemSource: contextSource ];
            didFinishCallback_();
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
}

-(void)testItemForItemWrongPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error_ )
            {
                item_error_ = (SCApiError*) error_;
                item_ = result;
                did_finish_callback_();
            };
            
            SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: @"/sitecore/content/WrongItem/"
                                        itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
}

-(void)testItemForItemWrongId
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* itemError_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                itemError_ = (SCApiError*) error_;
                item_ = result_;
                didFinishCallback_();
            };
            
            SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemId: @"{AAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAA}"
                                        itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( itemError_ != nil, @"OK" );
    NSLog(@"item_error_: %@", itemError_);
    GHAssertTrue( [ itemError_ isKindOfClass: [ SCInvalidItemIdError class ] ] == TRUE, @"OK" );
}

-(void)testItemForItemWrongIdWithFieldNames
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* itemError_ = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                itemError_ = (SCApiError*) error_;
                item_ = result_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader =
            [ apiContext_.extendedApiSession readItemOperationForFieldsNames: [ NSSet new ]
                                                              itemPath: @"/sitecore/content/WrongItem/"
                                                            itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( itemError_ != nil, @"OK" );
    GHAssertTrue( [ itemError_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
}

-(void)testItemForItemWrongPathWithFieldNames
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
                {
                    item_error_ = (SCApiError*) error_;
                    item_ = result_;
                    did_finish_callback_();
                };
                
                SCExtendedAsyncOp loader =
                [ apiContext_.extendedApiSession readItemOperationForFieldsNames: [ NSSet new ]
                                                                    itemId: @"{AAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAA}"
                                                                itemSource: contextSource ];
                loader(nil, nil, doneHandler);
                
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidItemIdError class ] ] == TRUE, @"OK" );
}

@end
