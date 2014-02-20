#import "SCAsyncTestCase.h"

@interface InvalidPathErrorTest : SCAsyncTestCase
@end

@implementation InvalidPathErrorTest

-(void)testItemWithNilPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ itemReaderForItemPath: nil ]( ^( id result_, NSError* error_ )
                {
                    item_error_ = (SCApiError*) error_;
                    item_ = result_;
                    didFinishCallback_();
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testItemWithFieldsNamesWithEmptyPath
{

    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ itemReaderWithFieldsNames:[ NSSet new ]
                                               itemPath: @"" ]( ^( id result_, NSError* error_ )
                {
                    item_error_ = (SCApiError*) error_;
                    item_ = result_;
                    didFinishCallback_();
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testChildrenWithInvalidPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSDictionary* items_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            [ apiContext_ childrenReaderWithItemPath: @"./[" ]( ^( id result_, NSError* error_ )
            {
                item_error_ = (SCApiError*) error_;
                items_ = result_;
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( items_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testPagedItemSCWithInvalidPath
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiSession* apiContext_ = nil;
    
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.requestType = SCItemReaderRequestItemPath;
            request_.scope       = SCItemReaderSelfScope | SCItemReaderChildrenScope;
            request_.request     = @"./[.//";
            request_.flags       = SCItemReaderRequestReadFieldsValues;
            request_.fieldNames  = nil;
            request_.pageSize    = 50;
            
            pagedItems_ = [ SCPagedItems pagedItemsWithApiSession: apiContext_
                                                          request: request_ ];
            [ pagedItems_ itemReaderForIndex: 0 ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                item_error_ = (SCApiError*)error_;
                didFinishCallback_();
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testPagedItemsCountSCWithNilPath
{
    __block SCPagedItems* pagedItems_;
    

    __weak __block SCApiSession* apiContext_ = nil;
    
    __block SCApiError* item_error_ = nil;
    __block NSNumber* items_count_ = 0;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.requestType = SCItemReaderRequestItemPath;
            request_.scope       = SCItemReaderSelfScope | SCItemReaderChildrenScope;
            request_.request     = nil;
            request_.flags       = SCItemReaderRequestReadFieldsValues;
            request_.fieldNames  = nil;
            request_.pageSize    = 50;
            
            pagedItems_ = [ SCPagedItems pagedItemsWithApiSession: apiContext_
                                                          request: request_ ];
            [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
            {
                items_count_ = result_;
                item_error_ = (SCApiError*)error_;
                didFinishCallback_();
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( items_count_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testItemChildrenRequestWithNilQuery
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
                request_.request = nil;
                request_.scope = SCItemReaderChildrenScope;
                request_.requestType = SCItemReaderRequestQuery;
                request_.fieldNames = [ NSSet new ];
                [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    items_ = result_items_;
                    didFinishCallback_();
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    NSLog( @"items: %@", items_ );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    SCItem* item_ = [ items_ objectAtIndex: 0 ];
    GHAssertTrue( [ [ item_ displayName ] isEqualToString: SCHomeDisplayName ], @"OK" );
    GHAssertTrue( item_error_ == nil, @"OK" );

    
}

-(void)testItemSelfRequestWithEmptyQuery
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
     __block SCApiSession* strongContext_  = nil;       
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.request = @"";
            request_.scope = SCItemReaderSelfScope;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames = nil;
            [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                 item_error_ = (SCApiError*)error_;
                 items_ = result_items_;
                 didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    NSLog(@"items_: %@", items_);
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    SCItem* item_ = [ items_ objectAtIndex: 0 ];
    GHAssertTrue( [ [ item_ displayName ] isEqualToString: SCHomeDisplayName ], @"OK" );
    GHAssertTrue( item_error_ == nil, @"OK" );
}

-(void)testImageLoaderForSCMediaPathWithInvalidPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block id value_ = nil;
    __block SCApiError* value_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ imageLoaderForSCMediaPath:  @"~/media/Images/wrong_image" ]( ^( id result_, NSError* error_ )
                {
                    value_ = result_;
                    value_error_ = (SCApiError*)error_;
                    didFinishCallback_();
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( value_ == nil, @"OK" );
    GHAssertTrue( value_error_ != nil, @"OK" );
    GHAssertTrue( [ value_error_ isKindOfClass: [ SCNotImageFound class ] ] == TRUE, @"OK" );
}

@end
