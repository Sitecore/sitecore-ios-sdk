#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderSelfScope;
NSString* not_allowed_path_ext = @"/sitecore/content/home/Not_Allowed_Parent";
NSString* allowed_path_ext = @"/sitecore/content/home/Allowed_Parent";

@interface ReadItemsSTestAuthExtended : SCAsyncTestCase
@end

@implementation ReadItemsSTestAuthExtended

-(void)testReadNotAllowedItemWithAllFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
 
    @autoreleasepool
    {
    __block SCApiSession* strongContext_  = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: not_allowed_path_ext
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
        {
            items_auth_ = result_items_;
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
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
    GHAssertTrue( apiContext_ == nil, @"OK" );

    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 1, @"OK" );
    SCItem* item_ = nil;
    //test product item
    {
        item_ = items_auth_[ 0 ];
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( [ item_.displayName isEqualToString: @"Not_Allowed_Parent" ], @"OK" );

        GHAssertTrue( item_.allChildren == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );

        GHAssertTrue( item_.allFieldsByName != nil, @"OK" );

        GHAssertTrue( [ item_.allFieldsByName count ] == [ item_.readFieldsByName count ], @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == SCAllFieldsCount, @"OK" );
    }
    
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}

-(void)testReadAllowedItemWithSomeFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_         = nil;
    __block NSArray* items_auth_    = nil;

 
    @autoreleasepool
    {
    __block SCApiSession* strongContext_  = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        NSSet* field_names_ = [ NSSet setWithObjects: @"Title", nil];
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: allowed_path_ext
                                                                        fieldsNames: field_names_ ];
        request_.scope = scope_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
        {
            items_auth_ = result_items_;
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
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
    
    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 1, @"OK" );
    SCItem* item_ = nil;
    //test product item
    {
        item_ = items_auth_[ 0 ];
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( [ item_.displayName isEqualToString: @"Allowed_Parent" ], @"OK" );
        
        GHAssertTrue( item_.allChildren == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
        GHAssertTrue( [ [ [ item_ fieldWithName: @"Title" ] rawValue ] isEqualToString: @"Allowed_Parent" ], @"OK" );
    }
    
    //test get item without auth
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    SCItem* item_without_auth_ = items_auth_[ 0 ];
    GHAssertTrue( [ item_without_auth_ isEqual: item_ ], @"OK" );
}

-(void)testReadItemSWithNoFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_parent_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent/Allowed_Item";
 
    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
        request_.scope = scope_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            SCReadItemsRequest* parent_request_ = [ SCReadItemsRequest requestWithItemPath: not_allowed_path_ext
                                                                                   fieldsNames: [ NSSet new ] ];
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_parent_, NSError* error_ )
            {
                items_parent_ = result_items_parent_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession readItemsOperationWithRequest: parent_request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_parent_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );

    //test get item with auth
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    SCItem* item_ = nil;
    //test product item
    {
        item_ = items_[ 0 ];
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( [ item_.displayName isEqualToString: @"Allowed_Item" ], @"OK" );
        
        GHAssertTrue( item_.allChildren == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
    }
    
    //test get item parent
    GHAssertTrue( [ items_parent_ count ] == 0, @"OK" );

}

-(void)testReadItemSWithQuery
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
 
    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
        request_.scope       = scope_;
        request_.fieldNames  = [ NSSet new ];
        request_.requestType = SCItemReaderRequestQuery;
        request_.request = @"/sitecore/content/descendant::*[@@key='allowed_parent']";
        SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader1(nil, nil, doneHandler1);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    NSLog( @"items_: %@", items_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get item without auth
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    SCItem* item_ = nil;
    //test item
    {
        item_ = items_[ 0 ];      
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( [ item_.displayName isEqualToString: @"Allowed_Parent" ], @"OK" );
    
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
    }
}

@end
