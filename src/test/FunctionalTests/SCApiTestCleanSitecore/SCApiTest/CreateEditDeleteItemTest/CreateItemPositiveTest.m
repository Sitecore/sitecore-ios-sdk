#import "SCAsyncTestCase.h"

#import "TestingRequestFactory.h"

@interface CreateItemPositiveTest : SCAsyncTestCase
@end

@implementation CreateItemPositiveTest

-(void)testCreateNormalItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSArray* read_fields_ = nil;
    __block NSError* createError = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword ];
            apiContext_ = strongContext_;

            apiContext_.defaultDatabase = @"master";

            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Normal Item";
            request_.itemTemplate = @"Common/Folder";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"__Editor", @"__Editor"
                                                                                   , nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObjects: @"__Editor", nil ];

            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
            {
                createError = error;
                item_ = result;
                NSLog( @"items fields: %@", item_.readFields );
                read_fields_ = item_.readFields;
                didFinishCallback_();
            } );
        };
        
        void (^delete_block_)(JFFSimpleBlock) = [ TestingRequestFactory doRemoveAllTestItemsFromMasterAsSitecoreAdminForTestCase ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                               selector: _cmd ];
    }
    
    // Items have been deleted
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        GHAssertTrue( item_ != nil, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Normal Item" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings( [ item_ itemTemplate ], @"Common/Folder", @"template mismatch" );
        GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
        
        id editorValue = [ [ item_ fieldWithName: @"__Editor" ] rawValue ];
        GHAssertEqualStrings( editorValue, @"__Editor", @"editorValue mismatch" );
    }
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        GHAssertTrue( item_ != nil, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Normal Item" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings( [ item_ itemTemplate ], @"Common/Folder", @"template mismatch" );
        GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
        
        id editorValue = [ [ item_ fieldWithName: @"__Editor" ] rawValue ];
        GHAssertEqualStrings( editorValue, @"__Editor", @"editorValue mismatch" );
    }
}

-(void)testCreateItemWithoutFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;

    __block NSError* createError = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
    
        apiContext_.defaultDatabase = @"web";

        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Item Without Fields";
            request_.itemTemplate = @"Common/Folder";

            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error )
            {
                createError = error;
                item_ = result_;
                didFinishCallback_();
            } );
        };

        void (^deleteBlock_)(JFFSimpleBlock) = [ TestingRequestFactory doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase ];

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: deleteBlock_
                                               selector: _cmd ];
    }
    
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );

        GHAssertTrue( item_ != nil, @"OK" );
        
        GHAssertEqualStrings( [ item_ displayName ], @"Item Without Fields", @"display name mismatch %@", [ item_ displayName ] );
        
        GHAssertEqualStrings( [ item_ itemTemplate ], @"Common/Folder", @"itemTemplate name mismatch %@", [ item_ itemTemplate ] );


        GHAssertTrue( [ item_.readFields count ] == 0, @"OK" );
    }
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        GHAssertTrue( item_ != nil, @"OK" );
        
        GHAssertEqualStrings( [ item_ displayName ], @"Item Without Fields", @"display name mismatch %@", [ item_ displayName ] );
        
        GHAssertEqualStrings( [ item_ itemTemplate ], @"Common/Folder", @"itemTemplate name mismatch %@", [ item_ itemTemplate ] );
        
        
        GHAssertTrue( [ item_.readFields count ] == 0, @"OK" );
    }

}

-(void)testCreateSpecialDeviceItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSArray* read_fields_ = nil;
    __block NSError* createError = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
    
        apiContext_.defaultDatabase = @"web";
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Device Item";
            request_.itemTemplate = @"System/Layout/Device";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"device_name", @"__Display name", nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObject: @"__Display name" ];

            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
            {
                createError = error;
                item_ = result;
                read_fields_ = [ item_ readFields ];
                didFinishCallback_();
            } );
        };

        void (^delete_block_)(JFFSimpleBlock) = [ TestingRequestFactory doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                               selector: _cmd ];
    }
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );

        GHAssertTrue( item_ != nil, @"OK" );

        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"device_name" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings([ item_ itemTemplate ], @"System/Layout/Device", @"itemTemplate mismatch" );
        NSLog( @"read_fields_: %@", read_fields_);
        GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );

        GHAssertEqualStrings( [ [ item_ fieldWithName: @"__Display name" ] rawValue ], @"device_name", @"raw display name mismatch" );
    }
    else
    {
       //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        GHAssertTrue( item_ != nil, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"device_name" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings([ item_ itemTemplate ], @"System/Layout/Device", @"itemTemplate mismatch" );
        NSLog( @"read_fields_: %@", read_fields_);
        GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
        
        GHAssertEqualStrings( [ [ item_ fieldWithName: @"__Display name" ] rawValue ], @"device_name", @"raw display name mismatch" );
    }
}

-(void)testCreateSpecialFolderItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    
    __block NSArray* read_fields_ = nil;
    __block NSError* createError = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";

        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Folder Item";
            request_.itemTemplate = @"Common/Folder";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"Folder Display Name", @"__Display name", nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObject: @"__Display name" ];

            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
            {
                createError = error;
                item_ = result;
                read_fields_ = [ item_ readFields ];
                didFinishCallback_();
            } );
        };
        
        void (^delete_block_)(JFFSimpleBlock) = [ TestingRequestFactory doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                               selector: _cmd ];
    }
    
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( item_ != nil, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Folder Display Name" ];
        GHAssertTrue( displayNameOk, @"OK" );

        GHAssertEqualStrings( [ item_ itemTemplate ], @"Common/Folder", @"template mismatch" );

        NSLog( @"items field value: %@", [ [ item_ fieldWithName: @"__Display name" ] rawValue ] );
        GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ item_ fieldWithName: @"__Display name" ] rawValue ], @"Folder Display Name", @"raw display name mismatch" );
    }
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( item_ != nil, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Folder Display Name" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings( [ item_ itemTemplate ], @"Common/Folder", @"template mismatch" );
        
        NSLog( @"items field value: %@", [ [ item_ fieldWithName: @"__Display name" ] rawValue ] );
        GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ item_ fieldWithName: @"__Display name" ] rawValue ], @"Folder Display Name", @"raw display name mismatch" );
    }
}

-(void)testCreateSpecialLayoutInWebItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSArray* readFields_ = nil;
    __block NSError* createError = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";

        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Layout Item";
            request_.itemTemplate = @"System/Layout/Layout";
            request_.fieldNames = [ NSSet setWithObjects: @"Path", nil ];
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                                     @"/xsl/test_layout.aspx"
                                     , @"Path"
                                     , nil ];
            request_.fieldsRawValuesByName = fields_;

            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
            {
                createError = error;
                item_ = result;
                readFields_ = item_.readFields;
                didFinishCallback_();
            } );
        };

        void (^deleteBlock_)(JFFSimpleBlock) = [ TestingRequestFactory doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: deleteBlock_
                                               selector: _cmd ];
    }
    
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );

        GHAssertTrue( item_ != nil, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Layout Item" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings( [ item_ itemTemplate ], @"System/Layout/Layout", @"OK" );

        NSLog( @"items field value: %@", [ [ item_ fieldWithName: @"Path" ] fieldValue ] );
        NSLog( @"item_.readFields: %@", readFields_ );
        GHAssertTrue( [ readFields_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ item_ fieldWithName: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx", @"OK" );

    }
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        GHAssertTrue( item_ != nil, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Layout Item" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings( [ item_ itemTemplate ], @"System/Layout/Layout", @"OK" );
        
        NSLog( @"items field value: %@", [ [ item_ fieldWithName: @"Path" ] fieldValue ] );
        NSLog( @"item_.readFields: %@", readFields_ );
        GHAssertTrue( [ readFields_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ item_ fieldWithName: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx", @"OK" );
    }
}



-(void)testCreateTwoItemsInWeb
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    __block NSUInteger readItemsCount_ = 0;
    __block NSArray* fieldsByName_ = nil;
    __block NSArray* fields2ByName_ = nil;
    __block NSError* createError = nil;
    __block NSError* createError2 = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";

        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Two Layout Items";
            request_.itemTemplate = @"System/Layout/Layout";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                                     @"/xsl/test_layout.aspx"
                                     , @"Path"
                                     , nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObjects: @"Path", nil ];
            
            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
            {
                createError = error;
                item_ = result;
                fieldsByName_ = [ item_ readFields ];
                [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
                {
                    createError2 = error;
                    item2_ = result;
                    fields2ByName_ = [ item_ readFields ];
                    didFinishCallback_();
                } );
            } );
        };
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: SCCreateItemPath ];
            item_request_.flags = SCReadItemRequestIngnoreCache;
            item_request_.scope = SCReadItemChildrenScope;
            [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* readItems_, NSError* read_error_ )
            {
                readItemsCount_ = [ readItems_ count ];
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );

        //first item
        GHAssertTrue( item_ != nil, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Two Layout Items" ];
        GHAssertTrue( displayNameOk, @"OK" );

        GHAssertEqualStrings( [ item_ itemTemplate ], @"System/Layout/Layout", @"OK" );

        NSLog( @"items field value: %@", [ [ item_ fieldWithName: @"Path" ] fieldValue ] );

        GHAssertTrue( [ fieldsByName_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ item_ fieldWithName: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx", @"OK" );

        //second item
        GHAssertTrue( item_ != nil, @"OK" );
        
        displayNameOk = [ [ item2_ displayName ] hasPrefix: @"Two Layout Items 1" ];
        GHAssertTrue( displayNameOk, @"OK" );
        GHAssertEqualStrings( [ item2_ itemTemplate ], @"System/Layout/Layout" , @"OK" );
        
        NSLog( @"items field value: %@", [ [ item_ fieldWithName: @"Path" ] fieldValue ] );
        
        GHAssertTrue( [ fields2ByName_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ item2_ fieldWithName: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx" , @"OK" );
    }
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item
        GHAssertTrue( item_ != nil, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Two Layout Items" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings( [ item_ itemTemplate ], @"System/Layout/Layout", @"OK" );
        
        NSLog( @"items field value: %@", [ [ item_ fieldWithName: @"Path" ] fieldValue ] );
        
        GHAssertTrue( [ fieldsByName_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ item_ fieldWithName: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx", @"OK" );
        
        //second item
        GHAssertTrue( item_ != nil, @"OK" );
        
        displayNameOk = [ [ item2_ displayName ] hasPrefix: @"Two Layout Items 1" ];
        GHAssertTrue( displayNameOk, @"OK" );
        GHAssertEqualStrings( [ item2_ itemTemplate ], @"System/Layout/Layout" , @"OK" );
        
        NSLog( @"items field value: %@", [ [ item2_ fieldWithName: @"Path" ] fieldValue ] );
        
        GHAssertTrue( [ fields2ByName_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ item2_ fieldWithName: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx" , @"OK" );
    }
}

-(void)testCreateItemsHierarchyInWeb
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    __block NSError* createError = nil;
    __block NSError* createError2 = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";

        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Layout Items Ierarchy";
            request_.itemTemplate = @"System/Layout/Layout";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"Layout Display", @"__Display name", nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObject: @"__Display name" ];

            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error )
            {
                createError = error;
                item_ = result_;
                request_.request = item_.path ?: @"/sitecore/content/home/Layout Items Ierarchy";
                NSLog( @"readFields: %@", [item_ readFields ] );
                [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
                {
                    createError2 = error;
                    item2_ = result;
                    NSLog( @"readFields: %@", [item_ readFields ] );
                    NSLog( @"readFields2: %@", [item2_ readFields ] );
                    didFinishCallback_();
                } );
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );

        //first item
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );

        NSLog( @"readFields: %@", [item_ readFields ] );
        NSLog( @"readFields2: %@", [item2_ readFields ] );
        GHAssertTrue( [ item_.readFields count ] == 1, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Layout Display" ];
        GHAssertTrue( displayNameOk, @"OK" );

        GHAssertEqualStrings( [ [ item_ fieldWithName: @"__Display name" ] fieldValue ] , @"Layout Display", @"OK" );

        //second item
        GHAssertTrue( item2_ != nil, @"OK" );
        GHAssertEqualStrings( [ item2_ itemTemplate ], @"System/Layout/Layout", @"OK" );
        GHAssertTrue( [ item2_.readFields count ] == 1, @"OK" );
        
        displayNameOk = [ [ item2_ displayName ] hasPrefix: @"Layout Display" ];
        GHAssertTrue( displayNameOk, @"OK" );

        GHAssertEqualStrings( [ [ item2_ fieldWithName: @"__Display name" ] fieldValue ] , @"Layout Display", @"OK" );
    }
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
        
        NSLog( @"readFields: %@", [item_ readFields ] );
        NSLog( @"readFields2: %@", [item2_ readFields ] );
        GHAssertTrue( [ item_.readFields count ] == 1, @"OK" );
        
        BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Layout Display" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings( [ [ item_ fieldWithName: @"__Display name" ] fieldValue ] , @"Layout Display", @"OK" );
        
        //second item
        GHAssertTrue( item2_ != nil, @"OK" );
        GHAssertEqualStrings( [ item2_ itemTemplate ], @"System/Layout/Layout", @"OK" );
        GHAssertTrue( [ item2_.readFields count ] == 1, @"OK" );
        
        displayNameOk = [ [ item2_ displayName ] hasPrefix: @"Layout Display" ];
        GHAssertTrue( displayNameOk, @"OK" );
        
        GHAssertEqualStrings( [ [ item2_ fieldWithName: @"__Display name" ] fieldValue ] , @"Layout Display", @"OK" );
    }
}

-(void)testCreateItemsHierarchyInWebForInvalidUser
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    __block NSError* createError = nil;
    __block NSError* createError2 = nil;
    
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: @"InvalidUser"
                                                      password: @"somepassword" ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
            
            request_.itemName     = @"Layout Items IerarchyIU";
            request_.itemTemplate = @"System/Layout/Layout";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"Layout DisplayIU", @"__Display name", nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObject: @"__Display name" ];
            
            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error )
             {
                 createError = error;
                 item_ = result_;
                 request_.request = item_.path ?: @"/sitecore/content/home/Layout Items Ierarchy";
                 NSLog( @"readFields: %@", [item_ readFields ] );
                 [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
                  {
                      createError2 = error;
                      item2_ = result;
                      NSLog( @"readFields: %@", [item_ readFields ] );
                      NSLog( @"readFields2: %@", [item2_ readFields ] );
                      didFinishCallback_();
                  } );
             } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    
    {
        GHAssertNil( item_, @"item created without proper permissions" );
        
        GHAssertTrue( [createError isMemberOfClass: [ SCCreateItemError class] ], @"error class mismatch" );
        SCCreateItemError* castedCreateError = (SCCreateItemError*)createError;
        
        GHAssertTrue( [ castedCreateError.underlyingError isMemberOfClass: [ SCResponseError class] ], @"error class mismatch" );
        
        SCResponseError* castedError = (SCResponseError*)castedCreateError.underlyingError;
        GHAssertTrue( 401 == castedError.statusCode, @"status code mismatch" );
    }
    
    {
        GHAssertNil( item2_, @"item created without proper permissions" );
        
        GHAssertTrue( [createError2 isMemberOfClass: [ SCCreateItemError class] ], @"error class mismatch" );
        SCCreateItemError* castedCreateError = (SCCreateItemError*)createError2;
        
        if ( IS_ANONYMOUS_ACCESS_ENABLED )
        {
            GHAssertTrue( [ castedCreateError.underlyingError isMemberOfClass: [ SCNoItemError class] ], @"error class mismatch" );
        }
        else
        {
            GHAssertTrue( [ castedCreateError.underlyingError isMemberOfClass: [ SCResponseError class] ], @"error class mismatch" );
            
        }
    }
    
}

@end
