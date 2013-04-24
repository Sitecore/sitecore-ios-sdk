#import "SCAsyncTestCase.h"

@interface InvalidPathErrorTest : SCAsyncTestCase
@end

@implementation InvalidPathErrorTest

-(void)testItemWithNilPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCError* item_error_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath: nil ]( ^( id result_, NSError* error_ )
            {
                item_error_ = (SCError*) error_;
                item_ = result_;
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testItemWithFieldsNamesWithEmptyPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCError* itemError_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderWithFieldsNames: [ NSSet new ]
                                           itemPath: @"" ]( ^( id result_, NSError* error_ )
            {
                itemError_ = (SCError*) error_;
                item_ = result_;
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( itemError_ != nil, @"OK" );
    GHAssertTrue( [ itemError_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testChildrenWithInvalidPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSDictionary* items_ = nil;
    __block SCError* itemError_ = nil;

    @autoreleasepool
    {
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ childrenReaderWithItemPath: @"./[" ]( ^( id result_, NSError* error_ )
            {
                itemError_ = (SCError*) error_;
                items_ = result_;
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    //GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( items_ == nil, @"OK" );
    GHAssertTrue( itemError_ != nil, @"OK" );
    GHAssertTrue( [ itemError_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testPagedItemSCWithInvalidPath
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCError* item_error_ = nil;
    //__block NSNumber* items_count_ = 0;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemPath;
        request_.scope       = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        request_.request     = @"./[.//";
        request_.flags       = SCItemReaderRequestReadFieldsValues;
        request_.fieldNames  = nil;
        request_.pageSize    = 50;
        
        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        [ pagedItems_ itemReaderForIndex: 0 ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            item_error_ = (SCError*)error_;
            didFinishCallback_();
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testPagedItemsCountSCWithNilPath
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCError* item_error_ = nil;
    __block NSNumber* items_count_ = 0;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemPath;
        request_.scope       = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        request_.request     = nil;
        request_.flags       = SCItemReaderRequestReadFieldsValues;
        request_.fieldNames  = nil;
        request_.pageSize    = 50;
        
        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
        {
            items_count_ = result_;
            item_error_ = (SCError*)error_;
            didFinishCallback_();
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( items_count_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}

-(void)testItemChildrenRequestWithNilQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block SCError* item_error_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request = nil;
            request_.scope = SCItemReaderChildrenScope;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames = [ NSSet new ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                item_error_ = (SCError*)error_;
                products_items_ = items_;
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    NSLog(@"products_items_: %@", products_items_);
    GHAssertTrue( [ products_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ products_items_ objectAtIndex: 0 ];
    GHAssertTrue( [ [ item_ displayName ] isEqualToString: @"Nicam" ], @"OK" );
    GHAssertTrue( item_error_ == nil, @"OK" );
    
}

-(void)testItemSelfRequestWithEmptyQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block SCError* item_error_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request = @"";
            request_.scope = SCItemReaderSelfScope;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames = nil;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                 item_error_ = (SCError*)error_;
                 products_items_ = items_;
                 didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSLog(@"products_items_: %@", products_items_);
    GHAssertTrue( [ products_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ products_items_ objectAtIndex: 0 ];
    GHAssertTrue( [ [ item_ displayName ] isEqualToString: @"Nicam" ], @"OK" );
    GHAssertTrue( item_error_ == nil, @"OK" );
}

-(void)testImageLoaderForSCMediaPathWithInvalidPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block id value_ = nil;
    __block SCError* value_error_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ imageLoaderForSCMediaPath:  @"~/media/Images/wrong_image" ]( ^( id result_, NSError* error_ )
            {
                value_ = result_;
                value_error_ = (SCError*)error_;
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSLog( @"value: %@", value_ );
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( value_ == nil, @"OK" );
    GHAssertTrue( value_error_ != nil, @"OK" );
    GHAssertTrue( [ value_error_ isKindOfClass: [ SCNotImageFound class ] ] == TRUE, @"OK" );
}

@end
