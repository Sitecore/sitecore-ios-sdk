#import "SCAsyncTestCase.h"

@interface CreateItemNegativeTest : SCAsyncTestCase
@end

@implementation CreateItemNegativeTest

static NSString* web_path_ = @"/sitecore/layout/Layouts/Test Data/Negative Tests";

-(void)testCreateManyItemsInWeb
{
    __block int readItemsCount_ = 0;
    __block NSString* path_ = @"/sitecore/layout/Layouts/Test Data/Create Edit Delete Tests";

    __block SCApiContext* apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";

    __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
    request_.itemName     = @"Many Layout Items";
    request_.itemTemplate = @"System/Layout/Layout";
    NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"/xsl/test_layout.aspx", @"Path", nil ];
    request_.fieldsRawValuesByName = fields_;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            didFinishCallback_();
        } );
    };

    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemPath: path_ ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        item_request_.scope = SCItemReaderChildrenScope;
        [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* readItems_, NSError* read_error_ )
        {
            readItemsCount_ = [ readItems_ count ];
            [ apiContext_ removeItemsWithRequest: item_request_ ]( ^( NSArray* readItems_, NSError* read_error_ )
            {
                didFinishCallback_();
            } );
        } );
    };
    for (int i=0; i<100; i++)
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
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];
        
        request_.itemName     = @"";
        request_.itemTemplate = @"Mobile SDK/Mobile Map";
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error_ )
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
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
    
}
 
-(void)testCreateItemWithEmptyPath
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: @"" ];
        
        request_.itemName     = @"ItemEmptyPath";
        request_.itemTemplate = @"System/Layout/Layout Folder";
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error_ )
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
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCInvalidPathError class ] ], @"OK" );
    
}

-(void)testCreateItemWithInvalidPath
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: @"content/*[@sitecore]" ];
        
        request_.itemName     = @"ItemInvalidPath";
        request_.itemTemplate = @"System/Layout/Layout Folder";
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error_ )
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
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCInvalidPathError class ] ], @"OK" );
    
}

-(void)testCreateItemWithInvalidTemplate
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];
        
        request_.itemName     = @"ItemInvalidTemplate";
        request_.itemTemplate = @"System/Layout/Layout Invalid";
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error_ )
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
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
    
}

-(void)testCreateItemWithInvalidFields
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];
        
        request_.itemName     = @"ItemInvalidFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Path", @"__Source", nil ];
        NSArray* names_ = [ NSArray arrayWithObjects: @"Path", @"__Source", nil];
        NSArray* values_ = [ NSArray arrayWithObjects: @"< =^@__$^= >", @"< =^@__$^= >", nil];
        NSDictionary* field_values_ = [ NSDictionary dictionaryWithObjects: values_ forKeys: names_ ];
        request_.fieldsRawValuesByName = field_values_;
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId 
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
        item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
        [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
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

-(void)testCreateItemWithManyFields
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: @"creator"
                                        password: @"creator" ];

    apiContext_.defaultDatabase = @"web";

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];

        request_.itemName     = @"ItemManyFields";
        request_.itemTemplate = @"Test Templates/Many Fields";
        request_.fieldNames   = nil;

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            NSLog( @"fields: %@", [ item_ readFieldsByName ] );
            response_error_ = error_;
            NSMutableArray* fields = [ NSMutableArray new ];
            for ( NSString* key_ in [ item_ readFieldsByName ] ) 
            {
                SCField* fld_ = [ [ item_ readFieldsByName ] objectForKey: key_ ];
                fld_.rawValue = @"raaaaaaaaw! :P";
                [ fields addObject: fld_ ];
            }
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            [ item_ saveItem ]( ^( id saved_result_, NSError* error_ )
            {
                item_ = saved_result_;
                NSLog( @"fields: %@", [ item_ readFieldsByName ] );
                NSLog( @"item: %@", item_ );
                didFinishCallback_();
            } );
        } );
    };

    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId 
                                                                           fieldsNames: nil ];
        item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
        [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
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
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( response_error_ == nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"raaaaaaaaw! :P" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"Test Templates/Many Fields" ], @"OK" );
    
    NSLog( @"item_.readFieldsByName: %@", [item_ readFieldsByName] );
    NSLog( @"item_.readFieldsByName: %d", [item_.readFieldsByName count ] );
    GHAssertTrue( [ item_.readFieldsByName count ] == 39, @"OK" );

    GHAssertTrue( [ [ [ item_ fieldWithName:@"a" ] rawValue ] isEqualToString: @"raaaaaaaaw! :P" ], @"OK" );
}

-(void)testCreateItemWithEmptyFields
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];
        
        request_.itemName     = @"ItemEmptyFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Path", @"__Source", nil ];
        NSArray* names_ = [ NSArray arrayWithObjects: @"Path", @"__Source", nil];
        NSArray* values_ = [ NSArray arrayWithObjects: @"", @"", nil];
        NSDictionary* field_values_ = [ NSDictionary dictionaryWithObjects: values_ forKeys: names_ ];
        request_.fieldsRawValuesByName = field_values_;
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error_ )
                                                         {
                                                             item_ = result_;
                                                             response_error_ = error_;
                                                             didFinishCallback_();
                                                         } );
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId 
                                                                           fieldsNames: [ NSSet setWithObjects: @"Path", @"__Source", nil ] ];
        item_request_.flags = SCItemReaderRequestIngnoreCache | SCItemReaderRequestReadFieldsValues;
        [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
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
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];
        
        request_.itemName     = @"ItemNotExistedFields";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Not Existed", @"Not Existed Too", nil ];
        NSArray* names_ = [ NSArray arrayWithObjects: @"Not Existed", @"Not Existed Too", nil];
        NSArray* values_ = [ NSArray arrayWithObjects: @"Value", @"Value", nil];
        NSDictionary* field_values_ = [ NSDictionary dictionaryWithObjects: values_ forKeys: names_ ];
        request_.fieldsRawValuesByName = field_values_;
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error_ )
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

-(void)testCreateItemWithoutCreatePermission
{
    __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* read_item_ = nil;
    __block NSError* response_error_ = nil;
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: @"sitecore\\nocreate"
                                        password: @"nocreate" ];
    
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];
        
        request_.itemName     = @"ItemWithoutCreatePermission";
        request_.itemTemplate = @"System/Layout/Layout";
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error_ )
        {
            item_ = result_;
            response_error_ = error_;
            didFinishCallback_();
        } );
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        [ apiContext_ itemReaderForItemPath: web_path_ ]( ^( id read_item_result_, NSError* read_error_ )
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
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
}

-(void)testCreateItemInCoreWithoutSecurityAccess
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSError* response_error_ = nil;
    __block NSString* path_ = web_path_;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiLogin
                                            password: SCWebApiPassword ];
        
        apiContext_.defaultDatabase = @"core";
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
        
        request_.itemName     = @"Layout Item in Core";
        request_.itemTemplate = @"System/Layout/Layout";
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"/xsl/test_layout.aspx", @"Path", nil ];
        request_.fieldsRawValuesByName = fields_;
        request_.fieldNames = [ NSSet setWithObject: @"Path" ];
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            item_ = result;
            response_error_ = error;
            didFinishCallback_();
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

     GHAssertTrue( apiContext_ == nil, @"OK" );
     GHAssertTrue( response_error_ != nil, @"OK" );
     NSLog( @"response: %@", response_error_ );
     GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
     
}


@end
