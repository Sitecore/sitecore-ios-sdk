#import "SCAsyncTestCase.h"

static SCReadItemScopeType scope_ = SCReadItemSelfScope | SCReadItemChildrenScope;

@interface ReadItemsSCTestAuthExtended : SCAsyncTestCase
@end

@implementation ReadItemsSCTestAuthExtended

-(void)testReadItemSCWithAllowedItemNotAllowedChildren
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    __block SCItemSourcePOD* contextSource = nil;
    __block SCItemSourcePOD* adminSource = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Allowed_Parent/Allowed_Item";
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                            fieldsNames: nil ];
            request_.scope = scope_;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
                request_.request = path_;
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                adminSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
                
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
    }
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 2, @"OK" );
    SCItem* self_item_ = nil;
    //test item relations
    {
        self_item_ = items_[ 0 ];  
        GHAssertTrue( self_item_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( self_item_.allChildren != nil, @"OK" );
        GHAssertTrue( self_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_.readChildren count ] == 1, @"OK" );
        SCItem* child_item_ = items_[ 1 ];
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_, @"OK" );
        GHAssertTrue( [ child_item_.displayName isEqualToString: @"Allowed_Child" ], @"OK" );
    }
     
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 3, @"OK" );
    SCItem* self_item_auth_ = [ apiContext_.extendedApiSession itemWithPath: path_
                                                                 itemSource: adminSource ];
    //test item relations
    {    
        GHAssertTrue( self_item_auth_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( self_item_auth_.allChildren != nil, @"OK" );
        GHAssertTrue( self_item_auth_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_auth_.allChildren count ] == 2, @"OK" );
        SCItem* child_item_ = items_auth_[ 2 ];
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_auth_, @"OK" );
    }
}

-(void)testReadItemSCWithNotAllowedItemAndChildren
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    __block SCItemSourcePOD* contextSource = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent";
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                            fieldsNames: nil ];
            request_.scope = scope_;
            request_.fieldNames = [ NSSet new ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
                request_.request = path_;
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
                
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
    }
    
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 3, @"OK" );
    SCItem* self_item_auth_ = [ apiContext_.extendedApiSession itemWithPath: path_
                                                                 itemSource: contextSource ];
    //test item relations
    {    
        GHAssertTrue( self_item_auth_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( self_item_auth_.allChildren != nil, @"OK" );
        GHAssertTrue( self_item_auth_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_auth_.allChildren count ] == 2, @"OK" );
        SCItem* child_item_ = items_auth_[ 2 ];
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_auth_, @"OK" );
    }
}

//Item Security: access to Item is deny, access to Children is Deny for not authorized user
-(void)testReadItemSCAuthWithQuery
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;

    NSString* path_ = @"/sitecore/content/Home/*[@@key='not_allowed_parent']";

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCReadItemsRequest* request_ = [SCReadItemsRequest new ];
        request_.fieldNames = [ NSSet new ];
        request_.requestType = SCReadItemRequestQuery;
        request_.scope = scope_;
        request_.request = path_;
        
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
    }
    
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );

    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );

    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 1, @"OK" );
    SCItem* self_item_auth_ = items_auth_[ 0 ];     
    GHAssertTrue( self_item_auth_.allFieldsByName == nil, @"OK" );
    GHAssertTrue( [ self_item_auth_.displayName isEqualToString: @"Not_Allowed_Parent" ], @"OK" );
}

@end