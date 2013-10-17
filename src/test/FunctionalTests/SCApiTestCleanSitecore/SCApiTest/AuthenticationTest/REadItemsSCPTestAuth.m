#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderSelfScope | SCItemReaderChildrenScope | SCItemReaderParentScope;

@interface ReadItemsSCPTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsSCPTestAuth

-(void)testReadItemSCPWithAllowedItemNotAllowedChildrenParent
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
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                            fieldsNames: [ NSSet new ] ];
            request_.scope = scope_;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
                request_.request = path_;
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
    
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 2, @"OK" );
    //test item relations
    { 
        SCItem* self_item_  = items_[ 0 ];
        SCItem* child_item_ = items_[ 1 ];

        GHAssertTrue( self_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( self_item_.parent == nil, @"OK" );
        GHAssertTrue( child_item_.readChildren == nil, @"OK" );
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_, @"OK" );
    }

    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 4, @"OK" );
    //test item relations
    {    
        SCItem* self_item_ = items_auth_ [ 1 ];
        SCItem* parent_item_ = items_auth_ [ 0 ];
        SCItem* child_item_ = items_auth_ [ 2 ];
        
        GHAssertTrue( self_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_.readChildren count ] == 2, @"OK" );
        GHAssertTrue( self_item_.parent != nil, @"OK" );
        GHAssertTrue( self_item_.parent == parent_item_, @"OK" );
        
        GHAssertTrue( parent_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( parent_item_.parent == nil, @"OK" );
        
        GHAssertTrue( child_item_.readChildren == nil, @"OK" );
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_, @"OK" );
    }
}

-(void)testReadItemSCPWithNotAllowedItemAllowedChildrenParent
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
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                            fieldsNames: [ NSSet new ] ];
            request_.scope = scope_;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
                request_.request = path_;
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
    
    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 4, @"OK" );
    //test item relations
    {
        SCItem* self_item_ = items_auth_ [ 1 ];
        SCItem* parent_item_ = items_auth_ [ 0 ];
        SCItem* child_item_ = items_auth_ [ 2 ];
        
        GHAssertTrue( self_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_.readChildren count ] == 2, @"OK" );
        GHAssertTrue( self_item_.parent != nil, @"OK" );
        GHAssertTrue( self_item_.parent == parent_item_, @"OK" );
        
        GHAssertTrue( parent_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( parent_item_.parent == nil, @"OK" );
        
        GHAssertTrue( child_item_.readChildren == nil, @"OK" );
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_, @"OK" );
    }
}


@end