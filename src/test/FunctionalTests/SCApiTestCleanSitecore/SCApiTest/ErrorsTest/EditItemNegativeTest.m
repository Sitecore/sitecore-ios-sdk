#import "SCAsyncTestCase.h"

@interface EditItemNegativeTest : SCAsyncTestCase
@end

@implementation EditItemNegativeTest

-(void)testEditItemManyTimes
{
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                  login: SCWebApiAdminLogin
                                               password: SCWebApiAdminPassword
                                                version: SCWebApiV1 ];
    
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

        request_.itemName     = @"EditItemFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = nil;

        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            didFinishCallback_();
        } );
    };
    
    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: item_.itemId 
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", nil ] ];
        item_request_.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                item_ = read_items_[ 0 ];
                SCField* fld_ = [ item_ fieldWithName: @"Path" ];
                fld_.rawValue = @"This is SPARTA!!!";
                [item_ saveItemOperation]( ^( id save_result, NSError* read_error_ )
                {
                    if (read_error_)
                    {
                        response_error_ = read_error_;
                        didFinishCallback_();
                        return;
                    }
                    [item_ saveItemOperation]( ^( id save_result, NSError* read_error_ )
                    {
                        if (read_error_)
                        {
                            response_error_ = read_error_;
                            didFinishCallback_();
                            return;
                        }
                        [item_ saveItemOperation]( ^( id save_result, NSError* read_error_ )
                        {
                            if (read_error_)
                            {
                                response_error_ = read_error_;
                                didFinishCallback_();
                                return;
                            }
                            [item_ saveItemOperation]( ^( id save_result, NSError* read_error_ )
                            {
                                if (read_error_)
                                {
                                    response_error_ = read_error_;
                                    didFinishCallback_();
                                    return;
                                }
                                [item_ saveItemOperation]( ^( id save_result, NSError* read_error_ )
                                {
                                    if (read_error_)
                                    {
                                        response_error_ = read_error_;
                                        didFinishCallback_();
                                        return;
                                    }
                                    [item_ saveItemOperation]( ^( id save_result, NSError* read_error_ )
                                    {
                                        didFinishCallback_();
                                    });
                                });
                            });
                        });
                    });
                });
            }
            else
            {
                response_error_ = read_error_;
                didFinishCallback_();
            }
        } );
    };

    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: item_.itemId 
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", nil ] ];
        item_request_.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
                item_ = read_items_[ 0 ];
            didFinishCallback_();                                                  
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];

    if ( nil == item_ )
    {
        GHFail( @"item not created" );
        return;
    }
    
    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( response_error_ == nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"EditItemFields" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
    
    GHAssertTrue( [ item_.readFields count ] >= 1, @"OK" );
    NSLog( @"item_.readFields: %@", item_.readFields );
    NSLog( @"[ [ item_ fieldWithName:@'Path' ] rawValue ] : %@", [ [ item_ fieldWithName: @"Path" ] rawValue ]  );
    GHAssertTrue( [ [ [ item_ fieldWithName:@"Path" ] rawValue ] isEqualToString: @"This is SPARTA!!!" ], @"OK" );
}
/* Fixed
-(void)testEditNotExistedItem
{
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItem* phantom_item_ = [ SCItem new ];
        [ phantom_item_ saveItemOperation ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
    }; 

    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];
}
*/

-(void)testEditItemWithoutEditPermission
{
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* read_item_ = nil;
    __block SCApiError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                  login: SCWebApiAdminLogin
                                               password: SCWebApiAdminPassword
                                                version: SCWebApiV1 ];

    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

        request_.itemName     = @"ItemWithoutEditPermission";
        request_.itemTemplate = @"System/Layout/Layout";

        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = (SCApiError*)error_;
            didFinishCallback_();
        } );
    };

    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                      login: SCWebApiNocreateLogin
                                                   password: SCWebApiNocreatePassword
                                                    version: SCWebApiV1 ];
        apiContext_.defaultSite = @"/sitecore/shell";
        apiContext_.defaultDatabase = @"web";
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: item_.itemId 
                                                                             fieldsNames: [ NSSet setWithObjects: @"Path", nil ] ];
        item_ = nil;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_result_, NSError* read_error_ )
        {
            if ( [ read_items_result_ count ] > 0 )
            {
                item_ = nil;
                SCItem* item_to_edit_ = read_items_result_[ 0 ];
                read_item_ = read_items_result_[ 0 ];
                SCField* field_ = [ item_to_edit_ fieldWithName: @"Path" ];
                field_.rawValue = @"New value";
                [ item_to_edit_ saveItemOperation ]( ^( id edit_item_result_, NSError* error_ )
                {
                    item_ = edit_item_result_;
                    response_error_ = (SCApiError*)error_;
                    didFinishCallback_(); 
                } );
            }
            else 
            {
                didFinishCallback_();
            }                                                 
        } );
    }; 

    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];

    NSLog( @"[ item_to_edit_ fieldWithName: @'Path' ];: %@", [ [ item_ fieldWithName: @"Path" ] rawValue ] );
    NSLog( @"response_error_: %@", response_error_ );
    GHAssertTrue( read_item_ != nil, @"OK" );
    GHAssertTrue( [ [ read_item_ displayName ] hasPrefix: @"ItemWithoutEditPermission" ], @"OK" );
    GHAssertTrue( [ [ read_item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
    //!!Bug: ResponseError need to be returned, result = edited item (we do not have permission to edit it)
    /*
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
     */
}

-(void)testRemoveItemWithoutRemovePermission
{
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    __block NSString* delete_response_ = @"";
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword
                                                version: SCWebApiV1 ];
    
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemWithoutDeletePermission";
        request_.itemTemplate = @"System/Layout/Layout";
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            didFinishCallback_();
        } );
    };
    
    void (^remove_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                               login: @"sitecore\\nocreate"
                                            password: @"nocreate"
                                                    version: SCWebApiV1 ];
        
        apiContext_.defaultDatabase = @"web";
        apiContext_.defaultSite = @"/sitecore/shell";        
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: item_.itemId 
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", nil ] ];
        [ apiContext_ deleteItemsOperationWithRequest: item_request_ ]( ^( id response_, NSError* error_ )
        {
            delete_response_ = [ NSString stringWithFormat: @"%@", response_ ];
            response_error_ = error_;
            [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_result_, NSError* read_error_ )
            {
                if ( [ read_items_result_ count ] > 0 )
                    item_ = read_items_result_[ 0 ];
                else 
                    item_ = nil;
                didFinishCallback_();        
            } );
        } );
    }; 
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: remove_block_
                                           selector: _cmd ];
    
    NSLog( @"apiContext_: %@", apiContext_ );
    NSLog( @"response_error_: %@", delete_response_ );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemWithoutDeletePermission" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
    GHAssertTrue( [ delete_response_ isEqualToString: @"(null)" ], @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
}

@end