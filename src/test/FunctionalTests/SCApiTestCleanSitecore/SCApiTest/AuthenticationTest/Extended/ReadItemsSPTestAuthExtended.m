#import "SCAsyncTestCase.h"
static SCItemReaderScopeType scope_ = SCItemReaderSelfScope | SCItemReaderParentScope;

@interface ReadItemsSPTestAuthExtended : SCAsyncTestCase
@end

@implementation ReadItemsSPTestAuthExtended

-(void)testReadItemSPWithAllowedItemNotAllowedParent
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent/Allowed_Item";
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = path_;
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            };
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
        loader(nil, nil, doneHandler);

    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
     NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );

    SCItem* self_item_ = items_[ 0 ];
    //test item relations
    {    
        GHAssertTrue( self_item_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( self_item_.readChildren == nil, @"OK" );
        GHAssertTrue( self_item_.parent == nil, @"OK" );
    }
    //test get items (without auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 2, @"OK" );

    SCItem* self_item_auth_ = items_auth_ [ 1 ];
    SCItem* parent_item_ = items_auth_ [ 0 ];
    
    //test item relations
    {
        GHAssertTrue( self_item_auth_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( self_item_auth_.readChildren == nil, @"OK" );
        GHAssertTrue( parent_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( self_item_auth_.parent == parent_item_, @"OK" );
    }
}

-(void)testReadItemSPWithNotAllowedItemAndParent
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent/Not_Allowed_Item";
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = path_;
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            };
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    
    //test get items (without auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 2, @"OK" );
    
    SCItem* self_item_auth_ = items_auth_ [ 1 ];
    SCItem* parent_item_ = items_auth_ [ 0 ];
    
    //test item relations
    {
        GHAssertTrue( self_item_auth_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( self_item_auth_.readChildren == nil, @"OK" );
        GHAssertTrue( parent_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( self_item_auth_.parent == parent_item_, @"OK" );
    }
}


-(void)testReadItemSPWithNotAllowedItemAllowedParent
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Allowed_Parent/Not_Allowed_Item";
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = path_;
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            };
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    
    //test get items (without auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 2, @"OK" );
    
    SCItem* self_item_auth_ = items_auth_ [ 1 ];
    SCItem* parent_item_ = items_auth_ [ 0 ];
    
    //test item relations
    {
        GHAssertTrue( self_item_auth_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( self_item_auth_.readChildren == nil, @"OK" );
        GHAssertTrue( parent_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( self_item_auth_.parent == parent_item_, @"OK" );
    }

}

@end