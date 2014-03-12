#import "SCAsyncTestCase.h"

static SCReadItemScopeType scope_ = SCReadItemChildrenScope | SCReadItemParentScope;

@interface ReadItemsCPTestAuthExtended : SCAsyncTestCase
@end

@implementation ReadItemsCPTestAuthExtended

-(void)testReadItemCPAllowedItemNotAllowedChildrenParent
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent/Allowed_Item";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        request_.flags = SCReadItemRequestIngnoreCache;
        
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
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    
    
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    //test item relations
    for (SCItem* item_ in items_ )
    { 
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.parent == nil, @"OK" );
    }
    
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 3, @"OK" );
    //test item relations
    for (SCItem* item_ in items_auth_ )
    {    
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.parent == nil, @"OK" );
    }
}

-(void)testReadItemCPAllowedItemParentNotAllowedChildren
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Allowed_Parent/Allowed_Item";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
        request_.flags = SCReadItemRequestIngnoreCache;
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
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
            
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    
    
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );

     GHAssertTrue( [ items_ count ] == 2, @"OK" );
     //test item relations
     for (SCItem* item_ in items_ )
     { 
         GHAssertTrue( [ item_.readFields count ] == 0, @"OK" );
         GHAssertTrue( item_.readChildren == nil, @"OK" );
         GHAssertTrue( item_.parent == nil, @"OK" );
     }
    
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 3, @"OK" );
    //test item relations
    for (SCItem* item_ in items_auth_ )
    {    
        GHAssertTrue( item_.allFields == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.parent == nil, @"OK" );
    }
}

-(void)testReadItemCPNotAllowedItemAllowedChildrenParent
{
    __block NSArray* items_ = nil;
    

    __weak __block SCApiSession* apiContext_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        NSString* path_ = @"/sitecore/content/Home/Allowed_Parent/Not_Allowed_Item";
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
                apiContext_ = strongContext_;
                
                SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                                fieldsNames: [ NSSet new ] ];
                request_.scope = scope_;
                request_.flags = SCReadItemRequestIngnoreCache;
            
                SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
                {
                    items_ = result_items_;
                    request_.request = path_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
                loader(nil, nil, doneHandler);
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];        
    }
    
    NSLog( @"items_: %@", items_ );

    GHAssertTrue( apiContext_ == nil, @"OK" );
    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}

@end