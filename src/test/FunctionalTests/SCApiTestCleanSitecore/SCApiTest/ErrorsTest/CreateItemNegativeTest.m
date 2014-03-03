#import "SCAsyncTestCase.h"

@interface CreateItemNegativeTest : SCAsyncTestCase
@end

@implementation CreateItemNegativeTest


-(void)testCreateManyItemsInWeb
{
    __block NSUInteger readItemsCount_ = 0;
    __block NSString* path_ = SCCreateItemPath;

    __block SCApiSession* apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
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
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
        {
            didFinishCallback_();
        } );
    };

    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: path_ ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        item_request_.scope = SCItemReaderChildrenScope;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* readItems_, NSError* read_error_ )
        {
            readItemsCount_ = [ readItems_ count ];
            [ apiContext_ deleteItemsOperationWithRequest: item_request_ ]( ^( NSArray* readItems_, NSError* read_error_ )
            {
                didFinishCallback_();
            } );
        } );
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"";
        request_.itemTemplate = @"System/Layout/Layout";
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: @"" ];
        
        request_.itemName     = @"ItemEmptyPath";
        request_.itemTemplate = @"System/Layout/Layout Folder";
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: @"content/*[@sitecore]" ];
        
        request_.itemName     = @"ItemInvalidPath";
        request_.itemTemplate = @"System/Layout/Layout Folder";
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemInvalidTemplate";
        request_.itemTemplate = @"System/Layout/Layout Invalid";
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
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
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
                                                         {
                                                             item_ = result_;
                                                             response_error_ = error_;
                                                             didFinishCallback_();
                                                         } );
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        GHAssertTrue( item_.itemId != nil, @"item should exist" );
        if ( item_.itemId != nil )
        {
            SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: item_.itemId
                                                                               fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
            item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
            [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
                  {
                      if ( [ read_items_ count ] > 0 )
                          item_ = [ read_items_ objectAtIndex: 0 ];
                      didFinishCallback_();
                  } );
        }
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
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
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: item_.itemId 
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
        item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
                item_ = [ read_items_ objectAtIndex: 0 ];
            didFinishCallback_();                                                  
        } );
    }; 
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
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
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;

    // @adk - sitecore/admin ---> extranet/anonymous
    // Do not add "/sitecore/shell" website
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
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
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
         {
             item_ = result_;
             response_error_ = error_;
             didFinishCallback_();
         } );
    };
   
    __block BOOL itemCreated = YES;
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        if (!item_)
        {
            itemCreated = NO;
            didFinishCallback_();
        }
        else
        {
            SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: item_.itemId
                                                                               fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
            item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
            [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
            {
                if ( [ read_items_ count ] > 0 )
                {
                    item_ = [ read_items_ objectAtIndex: 0 ];
                }
                
                didFinishCallback_();
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( itemCreated, @"item wasn't created" );
    
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
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
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
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
           item_ = result_;
           response_error_ = error_;
           didFinishCallback_();
        } );
    };
    
    __block BOOL itemCreated = YES;
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        if (!item_)
        {
            itemCreated = NO;
            didFinishCallback_();
        }
        else
        {
            SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: item_.itemId
                                                                               fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
            item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
            [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
            {
              if ( [ read_items_ count ] > 0 )
              {
                  item_ = [ read_items_ objectAtIndex: 0 ];
              }
              
              didFinishCallback_();
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( itemCreated, @"item wasn't created" );
    
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
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
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
                                                         {
                                                             item_ = result_;
                                                             response_error_ = error_;
                                                             didFinishCallback_();
                                                         } );
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
        //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( response_error_ == nil, @"OK" );
        GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemNotExistedFields" ], @"OK" );
        GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
        
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );;
    }
}

-(void)testCreateItemWithNotExistedFields_Shell
{
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
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
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* read_item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                  login: SCWebApiNocreateLogin
                                               password: SCWebApiNocreatePassword];
    
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemWithoutCreatePermission";
        request_.itemTemplate = @"System/Layout/Layout";
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
                                                         {
                                                             item_ = result_;
                                                             response_error_ = error_;
                                                             didFinishCallback_();
                                                         } );
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        [ apiContext_ readItemOperationForItemPath: SCCreateItemPath ]( ^( id read_item_result_, NSError* read_error_ )
                                                                {
                                                                    read_item_ = read_item_result_;
                                                                    didFinishCallback_();
                                                                } );
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
    __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* read_item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                  login: SCWebApiNocreateLogin
                                               password: SCWebApiNocreatePassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
        
        request_.itemName     = @"ItemWithoutCreatePermission";
        request_.itemTemplate = @"System/Layout/Layout";
        
        [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        [ apiContext_ readItemOperationForItemPath: SCCreateItemPath ]( ^( id read_item_result_, NSError* read_error_ )
        {
            read_item_ = read_item_result_;
            didFinishCallback_();                                                  
        } );
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
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    __block NSString* path_ = SCCreateItemPath;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiNocreateLogin
                                                          password: SCWebApiNocreatePassword
                                                           version: SCWebApiV1 ];
            apiContext_ = strongContext_;
            
            apiContext_.defaultDatabase = @"core";
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
            
            request_.itemName     = @"Layout Item in Core";
            request_.itemTemplate = @"System/Layout/Layout";
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"/xsl/test_layout.aspx", @"Path", nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.fieldNames = [ NSSet setWithObject: @"Path" ];
            
            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
            {
                item_ = result;
                response_error_ = error;
                didFinishCallback_();
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
     GHAssertTrue( apiContext_ == nil, @"OK" );
     GHAssertTrue( response_error_ != nil, @"OK" );
     NSLog( @"response: %@", response_error_ );
     SCCreateItemError* castedError_ = (SCCreateItemError*)response_error_;
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        // ALR can be failed for Web API 1.0 because of issue 393416 fixed on CMS 7.1
        GHAssertTrue( [ castedError_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
    }
    else
    {
        GHAssertTrue( [ castedError_.underlyingError isMemberOfClass: [ SCResponseError class ] ], @"OK" );
        
        SCResponseError* underlyingError = (SCResponseError*)castedError_.underlyingError;
        GHAssertTrue( underlyingError.statusCode == 403, @"error code mismatch" );
    }
}

-(void)testCreateItemInCoreWithoutSecurityAccess_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    __block NSString* path_ = SCCreateItemPath;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiNoAccessLogin
                                                          password: SCWebApiNoAccessPassword
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
            
            [ apiContext_ createItemsOperationWithRequest: request_ ]( ^( id result, NSError* error )
                                                             {
                                                                 item_ = result;
                                                                 response_error_ = error;
                                                                 didFinishCallback_();
                                                             } );
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
        // ALR can be failed because of issue 397233
        // ALR can be failed for Web API 1.0 because of issue 393416 fixed on CMS 7.1
        GHAssertTrue( [ castedError_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
        
    }
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( [ castedError_ isMemberOfClass: [ SCCreateItemError class ] ], @"OK" );
    }
}

@end
