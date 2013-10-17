#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderChildrenScope | SCItemReaderParentScope;

@interface ReadItemsCPTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsCPTestAuth

-(void)testReadItemCPAllowedItemNotAllowedChildrenParent
{
    __block SCApiContext* strongContext_  = nil;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent/Allowed_Item";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        request_.flags = SCItemReaderRequestIngnoreCache;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = path_;
            strongContext_ = [[SCApiContext alloc ] initWithHost: SCWebApiHostName
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
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    //test item relations
    for (SCItem* item_ in items_ )
    { 
        GHAssertNil( item_.readChildren, @"OK" );
        GHAssertNil( item_.parent      , @"OK" );
    }
    
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 3, @"OK" );
    //test item relations
    for (SCItem* item_ in items_auth_ )
    {
        NSArray* readChildren = item_.readChildren;
        SCItem* parent = item_.parent;
        
        GHAssertNil( readChildren, @"OK" );
        GHAssertNil( parent      , @"OK" );
    }
}

-(void)testReadItemCPAllowedItemParentNotAllowedChildren
{
    __block SCApiContext* strongContext_  = nil;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Allowed_Parent/Allowed_Item";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
        request_.flags = SCItemReaderRequestIngnoreCache;
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
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );

     GHAssertTrue( [ items_ count ] == 2, @"OK" );
     //test item relations
     for (SCItem* item_ in items_ )
     { 
         GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
         GHAssertTrue( item_.readChildren == nil, @"OK" );
         GHAssertTrue( item_.parent == nil, @"OK" );
     }
    
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 3, @"OK" );
    //test item relations
    for (SCItem* item_ in items_auth_ )
    {    
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.parent == nil, @"OK" );
    }
}

-(void)testReadItemCPNotAllowedItemAllowedChildrenParent
{
    __block NSArray* items_ = nil;
    

    __weak __block SCApiContext* apiContext_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_  = nil;
        NSString* path_ = @"/sitecore/content/Home/Allowed_Parent/Not_Allowed_Item";
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
                apiContext_ = strongContext_;
                
                SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                                fieldsNames: [ NSSet new ] ];
                request_.scope = scope_;
                request_.flags = SCItemReaderRequestIngnoreCache;
                
                [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
                 {
                     items_ = result_items_;
                     request_.request = path_;
                     didFinishCallback_();
                 } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];        
    }
    
    NSLog( @"items_: %@", items_ );

    GHAssertTrue( apiContext_ == nil, @"OK" );
    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}

@end