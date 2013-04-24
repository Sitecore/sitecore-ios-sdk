#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderParentScope;

@interface ReadItemsPTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsPTestAuth

-(void)testReadItemPAllowedItemNotAllowedParentWithAllFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;

    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent/Allowed_Item";

    @autoreleasepool
    {
    __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
        apiContext_ = strongContext_;
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword ];
            apiContext_ = strongContext_;
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            });
        } );
    };
    
     [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_: %@", items_auth_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    //test get item with auth
    GHAssertTrue( [ items_auth_ count ] == 1, @"OK" );
    SCItem* item_auth_ = items_auth_[ 0 ];
    //test item
    {
        GHAssertTrue( item_auth_.parent == nil, @"OK" );
        GHAssertTrue( [ item_auth_.displayName isEqualToString: @"Not_Allowed_Parent" ], @"OK" );
        
        GHAssertTrue( item_auth_.allChildren == nil, @"OK" );
        GHAssertTrue( item_auth_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( [ item_auth_.readFieldsByName count ] ==
                     [ item_auth_.allFieldsByName count ], @"OK" );
    }

}

-(void)testReadItemPNotAllowedItemAllowedParentWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Allowed_Parent/Not_Allowed_Item";
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
        apiContext_ = strongContext_;
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword ];
            apiContext_ = strongContext_;
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            });
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_: %@", items_auth_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    //test get item with auth
    GHAssertTrue( [ items_auth_ count ] == 1, @"OK" );
    SCItem* item_auth_ = items_auth_[ 0 ];
    //test item
    {
        GHAssertTrue( item_auth_.parent == nil, @"OK" );
        GHAssertTrue( [ item_auth_.displayName isEqualToString: @"Allowed_Parent" ], @"OK" );
        GHAssertTrue( item_auth_.allChildren == nil, @"OK" );
        GHAssertTrue( item_auth_.allFieldsByName != nil, @"OK" );
    }

}

@end