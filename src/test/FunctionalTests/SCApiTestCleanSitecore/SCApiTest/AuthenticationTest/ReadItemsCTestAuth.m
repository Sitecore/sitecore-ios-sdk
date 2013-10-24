#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderChildrenScope;

@interface ReadItemsCTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsCTestAuth

-(void)testReadItemCAllowedItemAllowedChildrenWithAllFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Allowed_Parent";
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                            fieldsNames: nil ];
            request_.scope = scope_;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
                strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword
                                                               version: SCWebApiV1 ];
                apiContext_ = strongContext_;
                apiContext_.defaultSite = @"/sitecore/shell";
                
                [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
                {
                    items_auth_ = result_items_;
                    didFinishCallback_();
                } );
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 1, @"OK" );

    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 2, @"OK" );
    SCItem* item_auth_ = items_auth_[ 0 ];
    //test item
    {   
        GHAssertTrue( item_auth_.parent == nil, @"OK" );
        GHAssertTrue( [ item_auth_.displayName isEqualToString: @"Allowed_Item" ], @"OK" );
        
        GHAssertTrue( item_auth_.allChildren == nil, @"OK" );
        GHAssertTrue( item_auth_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( [ item_auth_.readFieldsByName count ] == 
                     [ item_auth_.allFieldsByName count ], @"OK" );
    }
}

-(void)testReadItemCNotAllowedItemAllowedChildrenWithSomeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent";
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            NSSet* field_names_ = [ NSSet setWithObjects: @"Title", nil];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                            fieldsNames: field_names_ ];
            request_.scope = scope_;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
                strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword
                                                               version: SCWebApiV1 ];
                apiContext_ = strongContext_;
                apiContext_.defaultSite = @"/sitecore/shell";
                
                [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
                {
                    items_auth_ = result_items_;
                    didFinishCallback_();
                } );
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 2, @"OK" );
    SCItem* item_ = nil;
    //test item
    {
        item_ = items_auth_[ 0 ];
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
        GHAssertTrue( [ [ [ item_ fieldWithName: @"Title" ] rawValue ] isEqualToString: @"Allowed_Item" ], @"OK" );
    }
    
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}


-(void)testReadItemCWithQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/descendant::*[@@key='not_allowed_item']";
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            NSSet* field_names_ = [ NSSet new ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.fieldNames = field_names_;
            request_.request = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.scope = scope_;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
                strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword
                                                               version: SCWebApiV1 ];
                apiContext_ = strongContext_;
                apiContext_.defaultSite = @"/sitecore/shell";
                
                [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
                {
                    items_auth_ = result_items_;
                    didFinishCallback_();
                } );
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 2, @"OK" );
    SCItem* item_ = nil;
    //test item
    {
        item_ = items_auth_[ 0 ];
        GHAssertTrue( [item_.displayName isEqualToString: @"Not_Allowed_Item"], @"OK" );
    }
}

@end
