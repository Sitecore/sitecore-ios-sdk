#import "SCAsyncTestCase.h"

#import "TestingRequestFactory.h"

@interface CreateItemPositiveTest_Shell : SCAsyncTestCase
@end

@implementation CreateItemPositiveTest_Shell

-(void)testCreateNormalItem_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSDictionary* read_fields_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultSite = @"/sitecore/shell";
        apiContext_.defaultDatabase = @"master";

        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Normal Item";
            request_.itemTemplate = @"Common/Folder";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"__Editor", @"__Editor"
                                                                                   , nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObjects: @"__Editor", nil ];

            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
            {
                item_ = result;
                NSLog( @"items fields: %@", item_.readFieldsByName );
                read_fields_ = item_.readFieldsByName;
                didFinishCallback_();
            } );
        };
        
        void (^delete_block_)(JFFSimpleBlock) = [ TestingRequestFactory doRemoveAllTestItemsFromMasterForContext: apiContext_ ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                               selector: _cmd ];
    }
    
    // Items have been deleted
    GHAssertTrue( apiContext_ != nil, @"OK" ); // retained by item
    
    GHAssertTrue( item_ != nil, @"OK" );
    
    BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Normal Item" ];
    GHAssertTrue( displayNameOk, @"OK" );
    
    GHAssertEqualStrings( [ item_ itemTemplate ], @"Common/Folder", @"template mismatch" );
    GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
    
    id editorValue = [ [ read_fields_ objectForKey: @"__Editor" ] rawValue ];
    GHAssertEqualStrings( editorValue, @"__Editor", @"editorValue mismatch" );
}

-(void)testCreateItemWithoutFields_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        
        apiContext_ = strongContext_;
    
        apiContext_.defaultSite = @"/sitecore/shell";
        apiContext_.defaultDatabase = @"web";

        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Item Without Fields";
            request_.itemTemplate = @"Common/Folder";

            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error )
            {
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
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( item_ != nil, @"OK" );
    
    GHAssertEqualStrings( [ item_ displayName ], @"Item Without Fields", @"display name mismatch %@", [ item_ displayName ] );
    
    GHAssertEqualStrings( [ item_ itemTemplate ], @"Common/Folder", @"itemTemplate name mismatch %@", [ item_ itemTemplate ] );


    GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
}

-(void)testCreateSpecialDeviceItem_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSDictionary* read_fields_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
    
        apiContext_.defaultDatabase = @"web";
        apiContext_.defaultSite = @"/sitecore/shell";
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
                item_ = result;
                read_fields_ = [ item_ readFieldsByName ];
                didFinishCallback_();
            } );
        };

        void (^delete_block_)(JFFSimpleBlock) = [ TestingRequestFactory doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( item_ != nil, @"OK" );

    BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"device_name" ];
    GHAssertTrue( displayNameOk, @"OK" );
    
    GHAssertEqualStrings([ item_ itemTemplate ], @"System/Layout/Device", @"itemTemplate mismatch" );
    NSLog( @"read_fields_: %@", read_fields_);
    GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );

    GHAssertEqualStrings( [ [ read_fields_ objectForKey: @"__Display name" ] rawValue ], @"device_name", @"raw display name mismatch" );
}

-(void)testCreateSpecialFolderItem_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    
    __block NSDictionary* read_fields_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";
        apiContext_.defaultSite = @"/sitecore/shell";

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
                item_ = result;
                read_fields_ = [ item_ readFieldsByName ];
                didFinishCallback_();
            } );
        };
        
        void (^delete_block_)(JFFSimpleBlock) = [ TestingRequestFactory doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    
    BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Folder Display Name" ];
    GHAssertTrue( displayNameOk, @"OK" );

    GHAssertEqualStrings( [ item_ itemTemplate ], @"Common/Folder", @"template mismatch" );

    NSLog( @"items field value: %@", [ [ read_fields_ objectForKey: @"__Display name" ] rawValue ] );
    GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
    GHAssertEqualStrings( [ [ read_fields_ objectForKey: @"__Display name" ] rawValue ], @"Folder Display Name", @"raw display name mismatch" );
}

-(void)testCreateSpecialLayoutInWebItem_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSDictionary* readFields_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";
        apiContext_.defaultSite = @"/sitecore/shell";

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
                item_ = result;
                readFields_ = item_.readFieldsByName;
                didFinishCallback_();
            } );
        };

        void (^deleteBlock_)(JFFSimpleBlock) = [ TestingRequestFactory doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: deleteBlock_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( item_ != nil, @"OK" );
    
    BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Layout Item" ];
    GHAssertTrue( displayNameOk, @"OK" );
    
    GHAssertEqualStrings( [ item_ itemTemplate ], @"System/Layout/Layout", @"OK" );

    NSLog( @"items field value: %@", [ [ readFields_ objectForKey: @"Path" ] fieldValue ] );
    NSLog( @"item_.readFieldsByName: %@", readFields_ );
    GHAssertTrue( [ readFields_ count ] == 1, @"OK" );
    GHAssertEqualStrings( [ [ readFields_ objectForKey: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx", @"OK" );
}



-(void)testCreateTwoItemsInWeb_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    __block NSUInteger readItemsCount_ = 0;
    __block NSDictionary* fieldsByName_ = nil;
    __block NSDictionary* fields2ByName_ = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";
        apiContext_.defaultSite = @"/sitecore/shell";

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
                item_ = result;
                fieldsByName_ = [ item_ readFieldsByName ];
                [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
                {
                    item2_ = result;
                    fields2ByName_ = [ item_ readFieldsByName ];
                    didFinishCallback_();
                } );
            } );
        };
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: SCCreateItemPath ];
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            item_request_.scope = SCItemReaderChildrenScope;
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
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );

    //first item
    GHAssertTrue( item_ != nil, @"OK" );
    
    BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Two Layout Items" ];
    GHAssertTrue( displayNameOk, @"OK" );

    GHAssertEqualStrings( [ item_ itemTemplate ], @"System/Layout/Layout", @"OK" );

    NSLog( @"items field value: %@", [ [ fieldsByName_ objectForKey: @"Path" ] fieldValue ] );

    GHAssertTrue( [ fieldsByName_ count ] == 1, @"OK" );
    GHAssertEqualStrings( [ [ fieldsByName_ objectForKey: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx", @"OK" );

    //second item
    GHAssertTrue( item_ != nil, @"OK" );
    
    displayNameOk = [ [ item2_ displayName ] hasPrefix: @"Two Layout Items 1" ];
    GHAssertTrue( displayNameOk, @"OK" );
    GHAssertEqualStrings( [ item2_ itemTemplate ], @"System/Layout/Layout" , @"OK" );
    
    NSLog( @"items field value: %@", [ [ fields2ByName_ objectForKey: @"Path" ] fieldValue ] );
    
    GHAssertTrue( [ fields2ByName_ count ] == 1, @"OK" );
    GHAssertEqualStrings( [ [ fields2ByName_ objectForKey: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx" , @"OK" );
}

-(void)testCreateItemsIerarhyInWeb_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";
        apiContext_.defaultSite = @"/sitecore/shell";

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
                item_ = result_;
                request_.request = item_.path;
                NSLog( @"readFieldsByName: %@", [item_ readFieldsByName ] );
                [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
                {
                    item2_ = result;
                    NSLog( @"readFieldsByName: %@", [item_ readFieldsByName ] );
                    NSLog( @"readFieldsByName2: %@", [item2_ readFieldsByName ] );
                    didFinishCallback_();
                } );
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    GHAssertTrue( apiContext_ != nil, @"OK" );

    //first item
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );

    NSLog( @"readFieldsByName: %@", [item_ readFieldsByName ] );
    NSLog( @"readFieldsByName2: %@", [item2_ readFieldsByName ] );
    GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
    
    BOOL displayNameOk = [ [ item_ displayName ] hasPrefix: @"Layout Display" ];
    GHAssertTrue( displayNameOk, @"OK" );

    GHAssertEqualStrings( [ [ item_ fieldWithName: @"__Display name" ] fieldValue ] , @"Layout Display", @"OK" );

    //second item
    GHAssertTrue( item2_ != nil, @"OK" );
    GHAssertEqualStrings( [ item2_ itemTemplate ], @"System/Layout/Layout", @"OK" );
    GHAssertTrue( [ item2_.readFieldsByName count ] == 1, @"OK" );
    
    displayNameOk = [ [ item2_ displayName ] hasPrefix: @"Layout Display" ];
    GHAssertTrue( displayNameOk, @"OK" );

    GHAssertEqualStrings( [ [ item2_ fieldWithName: @"__Display name" ] fieldValue ] , @"Layout Display", @"OK" );
}

@end
