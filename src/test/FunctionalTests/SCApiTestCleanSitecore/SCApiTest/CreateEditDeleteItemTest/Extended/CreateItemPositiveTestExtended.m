#import "SCAsyncTestCase.h"

@interface CreateItemPositiveTestExtended : SCAsyncTestCase
@end

@implementation CreateItemPositiveTestExtended

-(void)testCreateNormalItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSDictionary* read_fields_ = nil;
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
            
            SCDidFinishAsyncOperationHandler doneHandler =  ^( id result, NSError* error )
                                             {
                                                 createError = error;
                                                 item_ = result;
                                                 NSLog( @"items fields: %@", item_.readFieldsByName );
                                                 read_fields_ = item_.readFieldsByName;
                                                 didFinishCallback_();
                                             } ;
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession createItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
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
        
        id editorValue = [ [ read_fields_ objectForKey: @"__Editor" ] rawValue ];
        GHAssertEqualStrings( editorValue, @"__Editor", @"editorValue mismatch" );
    }
    else
    {
        //FIXME: @igk [new webApi] sitecore/admin should became extranet/anonymous, access error expected
        GHAssertNil( item_, @"item created without proper permissions" );
        
        GHAssertTrue( [createError isMemberOfClass: [ SCCreateItemError class] ], @"error class mismatch" );
        SCCreateItemError* castedCreateError = (SCCreateItemError*)createError;
        
        GHAssertTrue( [ castedCreateError.underlyingError isMemberOfClass: [ SCResponseError class] ], @"error class mismatch" );
        
        SCResponseError* castedError = (SCResponseError*)castedCreateError.underlyingError;
        GHAssertTrue( 403 == castedError.statusCode, @"status code mismatch" );
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

            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error )
            {
                createError = error;
                item_ = result_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession createItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
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
        
        
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
        
    }
    else
    {
        //FIXME: @igk [new webApi] sitecore/admin should became extranet/anonymous, access error expected
        GHAssertNil( item_, @"item created without proper permissions" );
        
        GHAssertTrue( [createError isMemberOfClass: [ SCCreateItemError class] ], @"error class mismatch" );
        SCCreateItemError* castedCreateError = (SCCreateItemError*)createError;
        
        GHAssertTrue( [ castedCreateError.underlyingError isMemberOfClass: [ SCResponseError class] ], @"error class mismatch" );
        
        SCResponseError* castedError = (SCResponseError*)castedCreateError.underlyingError;
        GHAssertTrue( 403 == castedError.statusCode, @"status code mismatch" );
    }

}

-(void)testCreateSpecialDeviceItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSDictionary* read_fields_ = nil;
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
            
            SCDidFinishAsyncOperationHandler doneHandler =  ^( id result, NSError* error )
                                                            {
                                                                createError = error;
                                                                item_ = result;
                                                                read_fields_ = [ item_ readFieldsByName ];
                                                                didFinishCallback_();
                                                            } ;
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession createItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
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
        
        GHAssertEqualStrings( [ [ read_fields_ objectForKey: @"__Display name" ] rawValue ], @"device_name", @"raw display name mismatch" );
    }
    else
    {
        //FIXME: @igk [new webApi] sitecore/admin should became extranet/anonymous, access error expected
        GHAssertNil( item_, @"item created without proper permissions" );
        
        GHAssertTrue( [createError isMemberOfClass: [ SCCreateItemError class] ], @"error class mismatch" );
        SCCreateItemError* castedCreateError = (SCCreateItemError*)createError;
        
        GHAssertTrue( [ castedCreateError.underlyingError isMemberOfClass: [ SCResponseError class] ], @"error class mismatch" );
        
        SCResponseError* castedError = (SCResponseError*)castedCreateError.underlyingError;
        GHAssertTrue( 403 == castedError.statusCode, @"status code mismatch" );
    }
}

-(void)testCreateSpecialFolderItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    
    __block NSDictionary* read_fields_ = nil;
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
            
            SCDidFinishAsyncOperationHandler doneHandler =  ^( id result, NSError* error )
                                                            {
                                                                createError = error;
                                                                item_ = result;
                                                                read_fields_ = [ item_ readFieldsByName ];
                                                                didFinishCallback_();
                                                            } ;
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession createItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
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
        
        NSLog( @"items field value: %@", [ [ read_fields_ objectForKey: @"__Display name" ] rawValue ] );
        GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ read_fields_ objectForKey: @"__Display name" ] rawValue ], @"Folder Display Name", @"raw display name mismatch" );
    }
    else
    {
        //FIXME: @igk [new webApi] sitecore/admin should became extranet/anonymous, access error expected
        GHAssertNil( item_, @"item created without proper permissions" );
        
        GHAssertTrue( [createError isMemberOfClass: [ SCCreateItemError class] ], @"error class mismatch" );
        SCCreateItemError* castedCreateError = (SCCreateItemError*)createError;
        
        GHAssertTrue( [ castedCreateError.underlyingError isMemberOfClass: [ SCResponseError class] ], @"error class mismatch" );
        
        SCResponseError* castedError = (SCResponseError*)castedCreateError.underlyingError;
        GHAssertTrue( 403 == castedError.statusCode, @"status code mismatch" );
    }
}

-(void)testCreateSpecialLayoutInWebItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSDictionary* readFields_ = nil;
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
            
            SCDidFinishAsyncOperationHandler doneHandler =^( id result, NSError* error )
            {
                createError = error;
                item_ = result;
                readFields_ = item_.readFieldsByName;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession createItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
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
        
        NSLog( @"items field value: %@", [ [ readFields_ objectForKey: @"Path" ] fieldValue ] );
        NSLog( @"item_.readFieldsByName: %@", readFields_ );
        GHAssertTrue( [ readFields_ count ] == 1, @"OK" );
        GHAssertEqualStrings( [ [ readFields_ objectForKey: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx", @"OK" );
        
    }
    else
    {
        //FIXME: @igk [new webApi] sitecore/admin should became extranet/anonymous, access error expected
        GHAssertNil( item_, @"item created without proper permissions" );
        
        GHAssertTrue( [createError isMemberOfClass: [ SCCreateItemError class] ], @"error class mismatch" );
        SCCreateItemError* castedCreateError = (SCCreateItemError*)createError;
        
        GHAssertTrue( [ castedCreateError.underlyingError isMemberOfClass: [ SCResponseError class] ], @"error class mismatch" );
        
        SCResponseError* castedError = (SCResponseError*)castedCreateError.underlyingError;
        GHAssertTrue( 403 == castedError.statusCode, @"status code mismatch" );
    }
}



-(void)testCreateTwoItemsInWeb
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
            request_.site = @"/sitecore/shell";
            
            SCDidFinishAsyncOperationHandler mainDoneHandler = ^( id result, NSError* error )
            {
                item_ = result;
                fieldsByName_ = [ item_ readFieldsByName ];
                SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
                {
                    item2_ = result;
                    fields2ByName_ = [ item_ readFieldsByName ];
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession createItemsOperationWithRequest: request_ ];
                loader(nil, nil, doneHandler);
            };
            
            SCExtendedAsyncOp mainLoader = [ apiContext_.extendedApiSession createItemsOperationWithRequest: request_ ];
            mainLoader(nil, nil, mainDoneHandler);
        };
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: SCCreateItemPath ];
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            item_request_.scope = SCItemReaderChildrenScope;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* readItems_, NSError* read_error_ )
            {
                readItemsCount_ = [ readItems_ count ];
                didFinishCallback_();
            };

            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: item_request_ ];
            loader(nil, nil, doneHandler);
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
    
    displayNameOk = [ [ item2_ displayName ] hasPrefix: @"Two Layout Items" ];
    GHAssertTrue( displayNameOk, @"OK" );
    GHAssertEqualStrings( [ item2_ itemTemplate ], @"System/Layout/Layout" , @"OK" );
    
    NSLog( @"items field value: %@", [ [ fields2ByName_ objectForKey: @"Path" ] fieldValue ] );
    
    GHAssertTrue( [ fields2ByName_ count ] == 1, @"OK" );
    GHAssertEqualStrings( [ [ fields2ByName_ objectForKey: @"Path" ] fieldValue ], @"/xsl/test_layout.aspx" , @"OK" );
}

-(void)testCreateItemsIerarhyInWeb
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

        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Layout Items Ierarchy";
            request_.itemTemplate = @"System/Layout/Layout";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"Layout Display", @"__Display name", nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObject: @"__Display name" ];
            request_.site = @"/sitecore/shell";
            
            SCDidFinishAsyncOperationHandler mainDoneHandler = ^( id result_, NSError* error )
            {
                item_ = result_;
                request_.request = item_.path;
                NSLog( @"readFieldsByName: %@", [item_ readFieldsByName ] );
                SCDidFinishAsyncOperationHandler donHandler = ^( id result, NSError* error )
                {
                    item2_ = result;
                    NSLog( @"readFieldsByName: %@", [item_ readFieldsByName ] );
                    NSLog( @"readFieldsByName2: %@", [item2_ readFieldsByName ] );
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession createItemsOperationWithRequest: request_ ];
                loader(nil, nil, donHandler);
            };
            
            SCExtendedAsyncOp mainLoader = [ apiContext_.extendedApiSession createItemsOperationWithRequest: request_ ];
            mainLoader(nil, nil, mainDoneHandler);
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
