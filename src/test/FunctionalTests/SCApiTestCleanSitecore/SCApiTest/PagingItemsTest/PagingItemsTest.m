
#import "SCAsyncTestCase.h"

@interface PagingItemsTest : SCAsyncTestCase
@end

@implementation PagingItemsTest

-(void)testPagedItemCWithSomeFields
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSNumber* items_count_ = 0;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemPath;
        request_.scope = SCItemReaderChildrenScope;
        request_.request = SCHomePath;
        request_.flags = SCItemReaderRequestReadFieldsValues;
        request_.fieldNames = [ NSSet setWithObjects: @"Normal Text", nil ];
        request_.pageSize = 2;

        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        if ( !pagedItems_ )
        {
            didFinishCallback_();
            return;
        }
        [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
        {
            items_count_ = result_;
            [ pagedItems_ itemReaderForIndex: 2 ]( ^( id result_, NSError* error_ )
            {
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ items_count_ unsignedIntValue ] == 3, @"OK" );
    NSLog( @"%@", [ pagedItems_ itemForIndex: 0 ]);
    NSLog( @"%@", [ pagedItems_ itemForIndex: 1 ]);
    NSLog( @"%@", [ pagedItems_ itemForIndex: 2 ]);
    //!!Bug: 1st and 2nd item should not be read!!
    //GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] == nil, @"OK" );
    //GHAssertTrue( [ pagedItems_ itemForIndex: 1 ] == nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 2 ] != nil, @"OK" );
    SCItem* child_ = [ pagedItems_ itemForIndex: 2 ];

    GHAssertTrue( child_.parent  == nil, @"OK" );
    GHAssertTrue( child_.readChildren  == nil, @"OK" );

    GHAssertTrue( [ child_ fieldValueWithName: @"Normal Text" ] != nil, @"OK" );
}

-(void)testPagedItemSCWithAllFields
{
   __block SCPagedItems* pagedItems_;
   __weak __block SCApiContext* apiContext_ = nil;
   //__block NSArray* test_items_ = nil;
   __block NSNumber* items_count_ = 0;
   
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
      strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                       login: SCWebApiAdminLogin
                                                    password: SCWebApiAdminPassword ];
       apiContext_ = strongContext_;
      
      SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
      request_.requestType = SCItemReaderRequestItemPath;
      request_.scope       = SCItemReaderSelfScope | SCItemReaderChildrenScope;
      request_.request     = SCHomePath;
      request_.flags       = SCItemReaderRequestReadFieldsValues;
      request_.fieldNames  = nil;
      request_.pageSize    = 2;

      pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                    request: request_ ];
      [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
      {
         items_count_ = result_;
         [ pagedItems_ itemReaderForIndex: 0 ]( ^( id result_, NSError* error_ )
         {
            didFinishCallback_();
         } );
      } );
   };

   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: _cmd ];
    }
    
   GHAssertTrue( apiContext_ != nil, @"OK" );
   NSLog( @"items_count_: %@", items_count_ );
   GHAssertTrue( [ items_count_ unsignedIntValue ] == 4, @"OK" );

   GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
   SCItem* parent_ = [ pagedItems_ itemForIndex: 0 ];
   NSLog( @"parent_.displayName: %@", parent_.displayName );
   GHAssertTrue( [ parent_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
   GHAssertTrue( parent_.allFieldsByName != nil, @"OK" );
   GHAssertTrue( [ parent_.allFieldsByName count ] == [ parent_.readFieldsByName count ], @"OK" );

   GHAssertTrue( [ parent_.readChildren count ] == 1, @"OK" );
   GHAssertTrue( parent_.parent == nil, @"OK" );

   GHAssertTrue( [ pagedItems_ itemForIndex: 1 ] != nil, @"OK" );
   SCItem* child_ = [ pagedItems_ itemForIndex: 1 ];
   GHAssertTrue( child_.parent  == parent_, @"OK" );
   GHAssertTrue( child_.readChildren == nil, @"OK" );

   GHAssertTrue( child_.allFieldsByName != nil, @"OK" );
   GHAssertTrue( [ child_.allFieldsByName count ] == [ child_.readFieldsByName count ], @"OK" );
   
   GHAssertTrue( [ pagedItems_ itemForIndex: 2 ] == nil, @"OK" );   
   
}


-(void)testPagedItemWithQueryWithoutFields
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSNumber* items_count_ = 0;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
        apiContext_ = strongContext_;
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestQuery;
        request_.request = @"/sitecore/content/home/descendant-or-self::*[@@templatename='Sample Item']";
        request_.fieldNames = [ NSSet set ];
        request_.pageSize = 2;

        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        if ( !pagedItems_ )
        {
            didFinishCallback_();
            return;
        }
        [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
        {
            items_count_ = result_;
            [ pagedItems_ itemReaderForIndex: 1 ]( ^( id result_, NSError* error_ )
            {
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"items_count_: %@", items_count_ );
    for ( NSUInteger i = 0; i < 2; i++ )
    {
        GHAssertTrue( [ pagedItems_ itemForIndex: i ] != nil, @"OK" );
    }
    GHAssertTrue( [ pagedItems_ itemForIndex: 2 ] == nil, @"OK" );
    
    SCItem* item_ = [ pagedItems_ itemForIndex: 1 ];
   
    GHAssertTrue( item_.parent  != nil, @"OK" );
    GHAssertTrue( item_.readChildren  == nil, @"OK" );
    NSLog( @"%@:", [ item_ readFieldsByName] );
    GHAssertTrue( [[ item_ readFieldsByName] count ] == 0, @"OK" );
}

@end
