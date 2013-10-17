#import "SCAsyncTestCase.h"

@interface CreateItemNegativeTestExtended : SCAsyncTestCase
@end

@implementation CreateItemNegativeTestExtended


-(void)testCreateManyItemsInWeb
{
    __block NSUInteger readItemsCount_ = 0;
    __block NSString* path_ = SCCreateItemPath;

    __block SCApiContext* apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";

    __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
    request_.itemName     = @"Many Layout Items";
    request_.itemTemplate = @"System/Layout/Layout";
    NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"/xsl/test_layout.aspx", @"Path", nil ];
    request_.fieldsRawValuesByName = fields_;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
        {
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemPath: path_ ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        item_request_.scope = SCItemReaderChildrenScope;
        
        SCDidFinishAsyncOperationHandler donaHandler = ^( NSArray* readItems_, NSError* read_error_ )
        {
            readItemsCount_ = [ readItems_ count ];
            
            SCDidFinishAsyncOperationHandler donaHandler1 = ^( NSArray* readItems_, NSError* read_error_ )
            {
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiContext removeItemsWithRequest: item_request_ ];
            loader1(nil, nil, donaHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: item_request_ ];
        loader(nil, nil, donaHandler);
    };
    for (int i=0; i<100; ++i)
    {
        NSLog( @"creating item %d times", i );
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( readItemsCount_ >= 100, @"OK" );
}


-(void)testCreateItemWithEmptyName
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"";
        request_.itemTemplate = @"System/Layout/Layout";
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    
    GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
    SCCreateItemError* castedError_ = (SCCreateItemError*)response_error_;
    
    GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"OK" );
}
 
-(void)testCreateItemWithEmptyPath
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: @"" ];
        
        request_.itemName     = @"ItemEmptyPath";
        request_.itemTemplate = @"System/Layout/Layout Folder";
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    
    GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
    SCCreateItemError* castedError_ = (SCCreateItemError*)response_error_;
    
    GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCInvalidPathError class ] ], @"OK" );
}

-(void)testCreateItemWithInvalidPath
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: @"content/*[@sitecore]" ];
        
        request_.itemName     = @"ItemInvalidPath";
        request_.itemTemplate = @"System/Layout/Layout Folder";
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    
    GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
    SCCreateItemError* castedError_ = (SCCreateItemError*)response_error_;
    
    GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCInvalidPathError class ] ], @"OK" );
    
}

-(void)testCreateItemWithInvalidTemplate
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemInvalidTemplate";
        request_.itemTemplate = @"System/Layout/Layout Invalid";
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );

    GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
    SCCreateItemError* castedError_ = (SCCreateItemError*)response_error_;
    
    GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"OK" );
}

-(void)testCreateItemWithInvalidFields_Shell
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                  login: SCWebApiAdminLogin
                                               password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemInvalidFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Path", @"__Source", nil ];
        NSArray* names_ = [ NSArray arrayWithObjects: @"Path", @"__Source", nil];
        NSArray* values_ = [ NSArray arrayWithObjects: @"< =^@__$^= >", @"< =^@__$^= >", nil];
        NSDictionary* field_values_ = [ NSDictionary dictionaryWithObjects: values_ forKeys: names_ ];
        request_.fieldsRawValuesByName = field_values_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
        item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;

        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
                item_ = [ read_items_ objectAtIndex: 0 ];
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( response_error_ == nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemInvalidFields" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
    
    GHAssertTrue( [ item_.readFieldsByName count ] == 2, @"OK" );
    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
    NSLog( @"[ [ item_ fieldWithName:@'Path' ] rawValue ] : %@", [ [ item_ fieldWithName: @"Path" ] rawValue ]  );
    NSLog( @"[ [ item_ fieldWithName:@'__Source' ] rawValue ] : %@", [ [ item_ fieldWithName: @"__Source" ] rawValue ]  );
    GHAssertTrue( [ [ [ item_ fieldWithName:@"Path" ] rawValue ] isEqualToString: @"< =^@__$^= >" ], @"OK" );
    GHAssertTrue( [ [ [ item_ fieldWithName:@"__Source" ] rawValue ] isEqualToString: @"< =^@__$^= >" ], @"OK" );
}

-(void)testCreateItemWithInvalidFields
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemInvalidFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Path", @"__Source", nil ];
        NSArray* names_ = [ NSArray arrayWithObjects: @"Path", @"__Source", nil];
        NSArray* values_ = [ NSArray arrayWithObjects: @"< =^@__$^= >", @"< =^@__$^= >", nil];
        NSDictionary* field_values_ = [ NSDictionary dictionaryWithObjects: values_ forKeys: names_ ];
        request_.fieldsRawValuesByName = field_values_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId 
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
        item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
                item_ = [ read_items_ objectAtIndex: 0 ];
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
    }; 
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    if ( !IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertNil( item_, @"unexpecred item object" );
        GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"error clkass mismatch" );
        
        SCCreateItemError* castedError = (SCCreateItemError*)response_error_;
        GHAssertTrue( [ castedError.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"error clkass mismatch" );
        
        SCResponseError* responseError = (SCResponseError*)castedError.underlyingError;
        GHAssertTrue( 403 == responseError.statusCode, @"status code mismatch" );
        
        return;
    }

    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( response_error_ == nil, @"OK" );
        GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemInvalidFields" ], @"OK" );
        GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
        
        GHAssertTrue( [ item_.readFieldsByName count ] == 2, @"OK" );
        NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
        NSLog( @"[ [ item_ fieldWithName:@'Path' ] rawValue ] : %@", [ [ item_ fieldWithName: @"Path" ] rawValue ]  );
        NSLog( @"[ [ item_ fieldWithName:@'__Source' ] rawValue ] : %@", [ [ item_ fieldWithName: @"__Source" ] rawValue ]  );
        GHAssertTrue( [ [ [ item_ fieldWithName:@"Path" ] rawValue ] isEqualToString: @"< =^@__$^= >" ], @"OK" );
        GHAssertTrue( [ [ [ item_ fieldWithName:@"__Source" ] rawValue ] isEqualToString: @"< =^@__$^= >" ], @"OK" );
    }
}



-(void)testCreateItemWithEmptyFields
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                  login: SCWebApiAdminLogin
                                               password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemEmptyFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Path", @"__Source", nil ];
        NSArray* names_ = [ NSArray arrayWithObjects: @"Path", @"__Source", nil];
        NSArray* values_ = [ NSArray arrayWithObjects: @"", @"", nil];
        NSDictionary* field_values_ = [ NSDictionary dictionaryWithObjects: values_ forKeys: names_ ];
        request_.fieldsRawValuesByName = field_values_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId 
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
        item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
                item_ = [ read_items_ objectAtIndex: 0 ];
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
    }; 
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];    
    if ( !IS_ANONYMOUS_ACCESS_ENABLED)
    {
        GHAssertNil( item_, @"unexpecred item object" );
        GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"error clkass mismatch" );
        
        SCCreateItemError* castedError = (SCCreateItemError*)response_error_;
        GHAssertTrue( [ castedError.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"error clkass mismatch" );
        
        SCResponseError* responseError = (SCResponseError*)castedError.underlyingError;
        GHAssertTrue( 403 == responseError.statusCode, @"status code mismatch" );
        
        return;
    }

    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( response_error_ == nil, @"OK" );
        GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemEmptyFields" ], @"OK" );
        GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
        
        GHAssertTrue( [ item_.readFieldsByName count ] == 2, @"OK" );
        NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
        GHAssertTrue( [ [ [ item_ fieldWithName:@"Path" ] rawValue ] isEqualToString: @"" ], @"OK" );
        GHAssertTrue( [ [ [ item_ fieldWithName:@"__Source" ] rawValue ] isEqualToString: @"" ], @"OK" );
    }
}

-(void)testCreateItemWithEmptyFields_Shell
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                  login: SCWebApiAdminLogin
                                               password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemEmptyFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Path", @"__Source", nil ];
        NSArray* names_ = [ NSArray arrayWithObjects: @"Path", @"__Source", nil];
        NSArray* values_ = [ NSArray arrayWithObjects: @"", @"", nil];
        NSDictionary* field_values_ = [ NSDictionary dictionaryWithObjects: values_ forKeys: names_ ];
        request_.fieldsRawValuesByName = field_values_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
        item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
                item_ = [ read_items_ objectAtIndex: 0 ];
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( response_error_ == nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemEmptyFields" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
    
    GHAssertTrue( [ item_.readFieldsByName count ] == 2, @"OK" );
    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
    GHAssertTrue( [ [ [ item_ fieldWithName:@"Path" ] rawValue ] isEqualToString: @"" ], @"OK" );
    GHAssertTrue( [ [ [ item_ fieldWithName:@"__Source" ] rawValue ] isEqualToString: @"" ], @"OK" );
}

-(void)testCreateItemWithNotExistedFields
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                  login: SCWebApiAdminLogin
                                               password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemNotExistedFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Not Existed", @"Not Existed Too", nil ];
        NSArray* names_ = [ NSArray arrayWithObjects: @"Not Existed", @"Not Existed Too", nil];
        NSArray* values_ = [ NSArray arrayWithObjects: @"Value", @"Value", nil];
        NSDictionary* field_values_ = [ NSDictionary dictionaryWithObjects: values_ forKeys: names_ ];
        request_.fieldsRawValuesByName = field_values_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( response_error_ == nil, @"OK" );
        GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemNotExistedFields" ], @"OK" );
        GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
        
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
        NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
    }
    else
    {
        GHAssertNil( item_, @"unexpecred item object" );
        GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"error clkass mismatch" );
        
        SCCreateItemError* castedError = (SCCreateItemError*)response_error_;
        GHAssertTrue( [ castedError.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"error clkass mismatch" );
        
        SCResponseError* responseError = (SCResponseError*)castedError.underlyingError;
        GHAssertTrue( 403 == responseError.statusCode, @"status code mismatch" );
    }
}

-(void)testCreateItemWithNotExistedFields_Shell
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemNotExistedFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Not Existed", @"Not Existed Too", nil ];
        NSArray* names_ = [ NSArray arrayWithObjects: @"Not Existed", @"Not Existed Too", nil];
        NSArray* values_ = [ NSArray arrayWithObjects: @"Value", @"Value", nil];
        NSDictionary* field_values_ = [ NSDictionary dictionaryWithObjects: values_ forKeys: names_ ];
        request_.fieldsRawValuesByName = field_values_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( response_error_ == nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemNotExistedFields" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
    
    GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
}

-(void)testCreateItemWithoutCreatePermission_Shell
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* read_item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                  login: @"sitecore\\nocreate"
                                               password: @"nocreate" ];
    
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiContext contextSource ] copy ];
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemWithoutCreatePermission";
        request_.itemTemplate = @"System/Layout/Layout";
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCDidFinishAsyncOperationHandler doneHandler = ^( id read_item_result_, NSError* read_error_ )
        {
            read_item_ = read_item_result_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemReaderForItemPath: SCCreateItemPath
                                                                               itemSource: contextSource ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    NSLog( @"apiContext_: %@", apiContext_ );
    NSLog( @"response_error_: %@", response_error_ );
    GHAssertTrue( read_item_ != nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    
    GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
    SCCreateItemError* castedError_ = (SCCreateItemError*)response_error_;
    
    GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"OK" );
}

-(void)testCreateItemWithoutCreatePermission
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* read_item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                  login: @"sitecore\\nocreate"
                                               password: @"nocreate" ];
    
    apiContext_.defaultDatabase = @"web";
    SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiContext contextSource ] copy ];
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemWithoutCreatePermission";
        request_.itemTemplate = @"System/Layout/Layout";
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCDidFinishAsyncOperationHandler doneHandler = ^( id read_item_result_, NSError* read_error_ )
        {
            read_item_ = read_item_result_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemReaderForItemPath: SCCreateItemPath
                                                                               itemSource: contextSource ];
        loader(nil, nil, doneHandler);
    }; 
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        NSLog( @"apiContext_: %@", apiContext_ );
        NSLog( @"response_error_: %@", response_error_ );
        GHAssertTrue( read_item_ != nil, @"OK" );
        GHAssertTrue( item_ == nil, @"OK" );
        GHAssertTrue( response_error_ != nil, @"OK" );

        GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
        SCCreateItemError* castedError_ = (SCCreateItemError*)response_error_;
        
        GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"OK" );
    }
    else
    {
        GHAssertNil( item_, @"unexpecred item object" );
        GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"error clkass mismatch" );
        
        SCCreateItemError* castedError = (SCCreateItemError*)response_error_;
        GHAssertTrue( [ castedError.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"error clkass mismatch" );
        
        SCResponseError* responseError = (SCResponseError*)castedError.underlyingError;
        GHAssertTrue( 403 == responseError.statusCode, @"status code mismatch" );
    }
}

-(void)testCreateItemInCoreWithoutSecurityAccess
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    __block NSString* path_ = SCCreateItemPath;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiLogin
                                                          password: SCWebApiPassword
                                                           version: SCWebApiV1 ];
            apiContext_ = strongContext_;
            
            apiContext_.defaultDatabase = @"core";
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
            
            request_.itemName     = @"Layout Item in Core";
            request_.itemTemplate = @"System/Layout/Layout";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"/xsl/test_layout.aspx", @"Path", nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObject: @"Path" ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                item_ = result_;
                response_error_ = error_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
     GHAssertTrue( apiContext_ == nil, @"OK" );
     GHAssertTrue( response_error_ != nil, @"OK" );
     NSLog( @"response: %@", response_error_ );
    
    
    GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
    SCCreateItemError* castedError_ = (SCCreateItemError*)response_error_;

    
    GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"OK" );
}

-(void)testCreateItemInCoreWithoutSecurityAccess_Shell
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    __block NSString* path_ = SCCreateItemPath;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiLogin
                                                          password: SCWebApiPassword
                                                           version: SCWebApiV1 ];
            apiContext_ = strongContext_;
            
            apiContext_.defaultDatabase = @"core";
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
            
            request_.site = @"/sitecore/shell";
            request_.itemName     = @"Layout Item in Core";
            request_.itemTemplate = @"System/Layout/Layout";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"/xsl/test_layout.aspx", @"Path", nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObject: @"Path" ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                item_ = result_;
                response_error_ = error_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    NSLog( @"response: %@", response_error_ );
    
    
    GHAssertTrue( [ response_error_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
    SCCreateItemError* castedError_ = (SCCreateItemError*)response_error_;
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCNoItemError class ] ], @"OK" );
    }
    else
    {
        GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"OK" );
        
        SCResponseError* underlyingError = (SCResponseError*)castedError_.underlyingError;
        GHAssertTrue( underlyingError.statusCode == 403, @"error code mismatch" );
    }
}





@end
