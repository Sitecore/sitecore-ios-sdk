#import "SCAsyncTestCase.h"

@interface ReadItemsCacheTestExtended : SCAsyncTestCase

@end

@implementation ReadItemsCacheTestExtended


#pragma Read items S
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 0 ----
-(SCItem*)testReadItemSWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCHomePath;

        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] == 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_.allChildren == nil, @"OK" );
    }

    GHAssertTrue( test_item_ != nil, @"OK" );
    GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
    GHAssertTrue( test_item_.allFieldsByName != nil, @"OK" );
    NSLog( @"[ test_item_.allFieldsByName count ]: %lu", (unsigned long)[ test_item_.allFieldsByName count ]);
    GHAssertTrue( SCAllFieldsCount == [ test_item_.allFieldsByName count ], @"OK" );
    GHAssertTrue( [ test_item_.allFieldsByName count ] == [ test_item_.readFieldsByName count ], @"OK" );

    SCExtendedApiSession* exContext = apiContext_.extendedApiSession;
    return [ exContext itemWithPath: @"/sitecore"
                         itemSource: [ exContext contextSource ] ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 1 ----
-(SCItem*)testReadItemSWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

        NSString* itemId_ = SCHomeID;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", nil ];

        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] == 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];
    if ( rootItem_ == nil )
    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_.allChildren == nil, @"OK" );
        GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
    }
    GHAssertTrue( test_item_ != nil, @"OK" );

    GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
    if (test_item_.allFieldsByName == nil )
    {
        GHAssertTrue( 1 <= [ test_item_.readFieldsByName count ], @"OK" );
    }

    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 2 ----  
-(SCItem*)testReadItemSWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                       selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCHomePath;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] == 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_.allChildren == nil, @"OK" );
        GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ test_item_.readFieldsByName count ] == 0, @"OK" );
    }

    GHAssertTrue( test_item_ != nil, @"OK" );
    GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );

    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

#pragma Read items C
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 3 ----
-(SCItem*)testReadItemCWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* products_children_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCHomePath;

        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: nil 
                                                                              scope: SCReadItemChildrenScope ];
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            products_children_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ products_children_items_ count ] == SCAllChildrenCount, @"OK" );

    for ( SCItem* item_ in products_children_items_ )
    {
        if ( rootItem_ == nil )
        {
            GHAssertTrue( item_.parent == nil, @"OK" );
        }
        GHAssertTrue( [ item_.readFieldsByName count ] != 0, @"OK" );
        GHAssertTrue( [ item_.allFieldsByName    count ] != 0, @"OK" );
        GHAssertTrue( [ item_.allFieldsByName count ] == [ item_.readFieldsByName count ], @"OK" );;
    }
    
    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 4 ----
-(SCItem*)testReadItemCWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* children_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* itemId_   = SCHomeID;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", nil ];

        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: SCReadItemChildrenScope ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            children_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ children_items_ count ] == SCAllChildrenCount, @"OK" );

    for ( SCItem* item_ in children_items_ )
    {
        if ( rootItem_ == nil )
        {
            GHAssertTrue( item_.parent == nil, @"OK" );
            GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        }
    }
    
    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 5 ----
-(SCItem*)testReadItemCWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                       selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
   __weak __block SCApiSession* apiContext_ = nil;
   __block NSArray* products_children_items_ = nil;

   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
       strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
       apiContext_ = strongContext_;

      NSString* path_ = SCHomePath;
      NSSet* fieldsNames_ = [ NSSet new ];

      SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: SCReadItemChildrenScope ];
       SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
       {
           products_children_items_ = items_;
           didFinishCallback_();
       };
       
       SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
       loader(nil, nil, doneHandler);
   };

   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: selector_ ];

   GHAssertTrue( apiContext_ != nil, @"OK" );
   GHAssertTrue( [ products_children_items_ count ] == SCAllChildrenCount, @"OK" );

   for( SCItem* item_ in products_children_items_ )
   {
      if ( rootItem_ == nil )
      {
         GHAssertTrue( item_.parent == nil, @"OK" );
         GHAssertTrue( item_.allFieldsByName    == nil, @"OK" );
         GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
      }
   }
    
    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
   return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                             itemSource: contextSource ];
}

#pragma Read items P
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 6 ----
-(SCItem*)testReadItemPWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCAllowedParentPath;

        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: nil 
                                                                              scope: SCReadItemParentScope ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] == 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];
    if ( rootItem_ == nil )
    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_.allChildren == nil, @"OK" );
    }
    GHAssertTrue( test_item_ != nil, @"OK" );

    GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );

    GHAssertTrue( test_item_.allFieldsByName != nil, @"OK" );

    GHAssertTrue( SCAllFieldsCount == [ test_item_.allFieldsByName count ], @"OK" );
    GHAssertTrue( [ test_item_.allFieldsByName count ] == [ test_item_.readFieldsByName count ], @"OK" );
    
    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 7 ----
-(SCItem*)testReadItemPWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* itemId_ = SCAllowedParentID;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", nil ];

        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: SCReadItemParentScope ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] == 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];
    if ( rootItem_ == nil )
    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_.allChildren == nil, @"OK" );
        GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
    }
    GHAssertTrue( test_item_ != nil, @"OK" );
    GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
    if ( test_item_.allFieldsByName == nil )
    {
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 1 <= [ test_item_.readFieldsByName count ], @"OK" );
    }
    
    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 8 ----
-(SCItem*)testReadItemPWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                       selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCAllowedParentPath;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: SCReadItemParentScope ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] == 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_.allChildren == nil, @"OK" );
        GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ test_item_.readFieldsByName count ] == 0, @"OK" );
    }

    GHAssertTrue( test_item_ != nil, @"OK" );
    GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );

    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

#pragma Read items SC
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 9 ----
-(SCItem*)testReadItemSCWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCHomePath;

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemSelfScope | SCReadItemChildrenScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: nil 
                                                                              scope: scope_ ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
    }

    GHAssertTrue( test_item_ != nil, @"OK" );
    GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );

    GHAssertTrue( test_item_.allFieldsByName != nil, @"OK" );

    GHAssertTrue( SCAllFieldsCount == [ test_item_.allFieldsByName count ], @"OK" );
    GHAssertTrue( [ test_item_.allFieldsByName count ] == [ test_item_.readFieldsByName count ], @"OK" );

    GHAssertTrue( [ test_item_.allChildren count ] == SCAllChildrenCount, @"OK" );
    GHAssertTrue( [ test_item_.readChildren count ] == [ test_item_.allChildren count ], @"OK" );

    for ( SCItem* item_ in test_item_.allChildren )
    {
        GHAssertTrue( item_.parent == test_item_, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] != 0, @"OK" );
        GHAssertTrue( [ item_.allFieldsByName count ] != 0, @"OK" );
        GHAssertTrue( [ item_.allFieldsByName count ] == [ item_.readFieldsByName count ], @"OK" );;
    }
    
    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 10 ----
-(SCItem*)testReadItemSCWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                          selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* itemId_   = SCHomeID;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", nil ];

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemSelfScope | SCReadItemChildrenScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: scope_ ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
    }

    GHAssertTrue( test_item_ != nil, @"OK" );
    GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
    if ( test_item_.allFieldsByName == nil )
    {
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 1 <= [ test_item_.readFieldsByName count ], @"OK" );
    }
    GHAssertTrue( [ test_item_.allChildren count ] == SCAllChildrenCount, @"OK" );
    GHAssertTrue( [ test_item_.readChildren count ] == [ test_item_.allChildren count ], @"OK" );

    for ( SCItem* item_ in test_item_.readChildren )
    {
        GHAssertTrue( item_.parent == test_item_, @"OK" );
    }
    
    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 11 ----
-(SCItem*)testReadItemSCWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCHomePath;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemSelfScope | SCReadItemChildrenScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: scope_ ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ test_item_.readFieldsByName count ] == 0, @"OK" );
    }
    GHAssertTrue( test_item_ != nil, @"OK" );
    GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );

    GHAssertTrue( [ test_item_.allChildren count ] == SCAllChildrenCount, @"OK" );
    GHAssertTrue( [ test_item_.readChildren count ] == [ test_item_.allChildren count ], @"OK" );

    for ( SCItem* item_ in test_item_.allChildren )
    {
        GHAssertTrue( item_.parent == test_item_, @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( item_.allFieldsByName    == nil, @"OK" );
            GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
        }
    }
    
    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}


#pragma Read items SP
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 12 ----
-(SCItem*)testReadItemSPWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCAllowedParentPath;

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemSelfScope | SCReadItemParentScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: nil 
                                                                              scope: scope_ ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    SCItem* test_item_ = nil;

    //test products item
    {
        GHAssertTrue( test_items_ != nil, @"OK" );
        GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

        test_item_ = test_items_[ 0 ];
        GHAssertTrue( test_item_ != nil, @"OK" );
        GHAssertTrue( test_item_.readChildren != nil, @"OK" );

        if ( rootItem_ == nil )
        {
            GHAssertTrue( test_item_.parent == nil, @"OK" );
            GHAssertTrue( test_item_.allChildren == nil, @"OK" );
        }
        NSLog( @"%@",[ test_item_ readChildren ]);
        GHAssertTrue( [ test_item_.readChildren count ] >= 1, @"OK" );

        GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
        GHAssertTrue( test_item_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( SCAllFieldsCount == [ test_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ test_item_.allFieldsByName count ] == [ test_item_.readFieldsByName count ], @"OK" );
    }

    //test self item
    {
        SCItem* child_item_ = test_item_.readChildren[ 0 ];

        GHAssertTrue( child_item_ != nil, @"OK" );

        GHAssertTrue( child_item_.parent == test_item_, @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( child_item_.allChildren == nil, @"OK" );
            GHAssertTrue( child_item_.readChildren == nil, @"OK" );
            GHAssertTrue( child_item_.allFieldsByName != nil, @"OK" );
        }
        GHAssertTrue( [ child_item_.allFieldsByName count ] == [ child_item_.readFieldsByName count ], @"OK" );
    }
    
    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 13 ----
// stop modifying tests
-(SCItem*)testReadItemSPWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                          selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        contextSource = [ apiContext_.extendedApiSession contextSource ];

        NSString* itemId_ = SCAllowedParentID;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", nil ];

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemSelfScope | SCReadItemParentScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: scope_ ];
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    SCItem* test_item_ = nil;

    GHAssertTrue( apiContext_ != nil, @"OK" );
    //test lenses item
    {
        GHAssertTrue( test_items_ != nil, @"OK" );
        GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

        test_item_ = test_items_[ 0 ];
        GHAssertTrue( test_item_.readChildren != nil, @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( test_item_.parent == nil, @"OK" );
            GHAssertTrue( test_item_.allChildren == nil, @"OK" );
            GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ test_item_.readChildren count ] == 1, @"OK" );
        }

        GHAssertTrue( test_item_ != nil, @"OK" );
        GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 1 <= [ test_item_.readFieldsByName count ], @"OK" );
    }

    //test self item
    {
        //STODO get item via property readChildren
        SCItem* self_item_ = [ apiContext_.extendedApiSession itemWithPath: SCAllowedParentPath
                                                                itemSource: contextSource ];

        GHAssertTrue( self_item_ != nil, @"OK" );

        GHAssertTrue( self_item_.parent == test_item_, @"OK" );

        if (rootItem_ == nil )
        {
            GHAssertTrue( self_item_.allChildren == nil, @"OK" );
            GHAssertTrue( self_item_.readChildren == nil, @"OK" );
            GHAssertTrue( self_item_.allFieldsByName == nil, @"OK" );
        }
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 1 <= [ self_item_.readFieldsByName count ], @"OK" );
    }
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 14 ----
-(SCItem*)testReadItemSPWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        contextSource = [ apiContext_.extendedApiSession contextSource ];

        NSString* path_ = SCAllowedParentPath;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCReadItemScopeType scope_ = (SCReadItemScopeType)( SCReadItemSelfScope | SCReadItemParentScope );
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: scope_ ];
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    SCItem* test_item_ = nil;
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //test parent item
    {
        GHAssertTrue( test_items_ != nil, @"OK" );
        GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

        test_item_ = test_items_[ 0 ];
        GHAssertTrue( test_item_ != nil, @"OK" );
        GHAssertTrue( test_item_.readChildren != nil, @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( test_item_.parent == nil, @"OK" );
            GHAssertTrue( test_item_.allChildren == nil, @"OK" );
            GHAssertTrue( [ test_item_.readChildren count ] == 1, @"OK" );
            GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ test_item_.readFieldsByName count ] == 0, @"OK" );
        }

        GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
    }

    //test self item
    {
        SCItem* child_item_ = [ apiContext_.extendedApiSession itemWithPath: SCAllowedParentPath
                                                                 itemSource: contextSource ];

        GHAssertTrue( child_item_ != nil, @"OK" );
        GHAssertTrue( child_item_.parent == test_item_, @"OK" );

        if ( rootItem_ == nil )
        {
            GHAssertTrue( child_item_.parent == test_item_, @"OK" );
            GHAssertTrue( child_item_.allChildren == nil, @"OK" );
            GHAssertTrue( child_item_.readChildren == nil, @"OK" );
            GHAssertTrue( child_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ child_item_.readFieldsByName count ] == 0, @"OK" );
        }
    }
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

#pragma Read items CP
//by relative path
// 0(-),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 15 ----
-(SCItem*)testReadItemCPWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCAllowedParentPath;

        SCReadItemScopeType scope_ = (SCReadItemScopeType)( SCReadItemParentScope | SCReadItemChildrenScope );
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: nil 
                                                                              scope: scope_ ];
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

    SCItem* test_item_ = test_items_[ 0 ];

    GHAssertTrue( test_item_ != nil, @"OK" );

    {
        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( test_item_.allChildren == nil, @"OK" );
            GHAssertTrue( test_item_.readChildren == nil, @"OK" );
            GHAssertTrue( test_item_.allFieldsByName != nil, @"OK" );
        }

        GHAssertTrue( SCAllFieldsCount == [ test_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ test_item_.allFieldsByName count ] == [ test_item_.readFieldsByName count ], @"OK" );
    }

    //test childs
    {
        NSLog( @"test_items_ count: %lu", (unsigned long)[ test_items_ count ] );
        NSRange childrenRange = NSMakeRange( 1, [ test_items_ count ] - 1 );
        NSArray* children_ = [ test_items_ subarrayWithRange: childrenRange ];
        GHAssertTrue( 2 == [ children_ count ], @"OK" );
        for ( SCItem* item_ in children_ )
        {
            GHAssertTrue( item_ != nil, @"OK" );
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.parent == nil, @"OK" );
                GHAssertTrue( item_.allChildren == nil, @"OK" );
                GHAssertTrue( item_.readChildren == nil, @"OK" );
            }
        }
    }

    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by item id
// 0(-),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 16 ----
-(SCItem*)testReadItemCPWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                          selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* itemId_ = SCAllowedParentID;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", nil ];

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemParentScope | SCReadItemChildrenScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: scope_ ];
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

    {
        SCItem* test_item_ = test_items_[ 0 ];

        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_ != nil, @"OK" );
        GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( test_item_.allChildren == nil, @"OK" );
            GHAssertTrue( test_item_.readChildren == nil, @"OK" );
            GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
        }
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 1 <= [ test_item_.readFieldsByName count ], @"OK" );
    }

    {
        NSRange childrenRange = NSMakeRange( 1, [ test_items_ count ] - 1 );
        NSArray* children_ = [ test_items_ subarrayWithRange: childrenRange ];
        GHAssertTrue( 2 == [ children_ count ], @"OK" );
        for ( SCItem* item_ in children_ )
        {
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.parent == nil, @"OK" );
                GHAssertTrue( item_.allChildren == nil, @"OK" );
                GHAssertTrue( item_.readChildren == nil, @"OK" );
                GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
            }
            GHAssertTrue( 1 <= [ item_.readFieldsByName count ], @"OK" );
        }
    }

    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by absolute path
// 0(-),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 17 ----
-(SCItem*)testReadItemCPWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;

        NSString* path_ = SCAllowedParentPath;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemParentScope | SCReadItemChildrenScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: scope_ ];
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

    {
        SCItem* test_item_ = test_items_[ 0 ];

        GHAssertTrue( test_item_.parent == nil, @"OK" );
        GHAssertTrue( test_item_ != nil, @"OK" );
        GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
        if (rootItem_ == nil )
        {
            GHAssertTrue( test_item_.allChildren == nil, @"OK" );
            GHAssertTrue( test_item_.readChildren == nil, @"OK" );
            GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ test_item_.readFieldsByName count ] == 0, @"OK" );
        }
    }

    {
        NSRange childrenRange = NSMakeRange( 1, [ test_items_ count ] - 1 );
        NSArray* children_ = [ test_items_ subarrayWithRange: childrenRange ];
        GHAssertTrue( 2 == [ children_ count ], @"OK" );
        for ( SCItem* item_ in children_ )
        {
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.parent == nil, @"OK" );
                GHAssertTrue( item_.allChildren == nil, @"OK" );
                GHAssertTrue( item_.readChildren == nil, @"OK" );
                GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
            }
        }
    }

    SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

#pragma Read items SCP
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 18 ----
-(SCItem*)testReadItemSCPWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                          selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        contextSource = [ apiContext_.extendedApiSession contextSource ];

        NSString* path_ = SCAllowedParentPath;

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemSelfScope | SCReadItemParentScope | SCReadItemChildrenScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: nil 
                                                                              scope: scope_ ];
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

    SCItem* test_item_ = nil;

    //test parent item
    {
        test_item_ = test_items_[ 0 ];
        GHAssertTrue( test_item_ != nil, @"OK" );
        GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( test_item_.parent == nil, @"OK" );
            GHAssertTrue( test_item_.allChildren == nil, @"OK" );
        }
        GHAssertTrue( test_item_.allFieldsByName != nil, @"OK" );

        GHAssertTrue( SCAllFieldsCount == [ test_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ test_item_.allFieldsByName count ] == [ test_item_.readFieldsByName count ], @"OK" );
    }

    //test self with children item
    {
        SCItem* self_item_ = [ apiContext_.extendedApiSession itemWithPath: SCAllowedParentPath
                                                                itemSource: contextSource ];

        GHAssertTrue( self_item_ != nil, @"OK" );

        GHAssertTrue( self_item_.parent == test_item_, @"OK" );
        GHAssertTrue( [ self_item_.displayName isEqualToString: @"Allowed_Parent" ], @"OK" );
        GHAssertTrue( self_item_.allFieldsByName != nil, @"OK" );

        GHAssertTrue( 2 <= [ self_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ self_item_.allFieldsByName count ] == [ self_item_.readFieldsByName count ], @"OK" );

        GHAssertTrue( [ self_item_.allChildren count ] == 2, @"OK" );

        for ( SCItem* item_ in self_item_.allChildren )
        {
            GHAssertTrue( item_.parent == self_item_, @"OK" );
            GHAssertTrue( [ item_.readFieldsByName count ] != 0, @"OK" );
            GHAssertTrue( [ item_.allFieldsByName    count ] != 0, @"OK" );
            GHAssertTrue( [ item_.allFieldsByName count ] == [ item_.readFieldsByName count ], @"OK" );;
        }
    }
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 19 ----
-(SCItem*)testReadItemSCPWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                           selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        contextSource = [ apiContext_.extendedApiSession contextSource ];
        
        NSString* itemId_ = SCAllowedParentID;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", nil ];

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemSelfScope | SCReadItemParentScope | SCReadItemChildrenScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: scope_ ];
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

    SCItem* test_item_ = nil;
    //test parent item
    {
        test_item_ = test_items_[ 0 ];

        GHAssertTrue( test_item_ != nil, @"OK" );
        GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( test_item_.parent == nil, @"OK" );
            GHAssertTrue( test_item_.allChildren == nil, @"OK" );
            GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
        }
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 1 <= [ test_item_.readFieldsByName count ], @"OK" );
    }

    //test self with children item
    {
        SCItem* self_item_ = [ apiContext_.extendedApiSession itemWithPath: SCAllowedParentPath
                                                                itemSource: contextSource ];

        GHAssertTrue( self_item_ != nil, @"OK" );
        GHAssertTrue( self_item_.parent == test_item_, @"OK" );
        GHAssertTrue( [ self_item_.displayName isEqualToString: @"Allowed_Parent" ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( self_item_.allFieldsByName == nil, @"OK" );
        }
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 1 <= [ self_item_.readFieldsByName count ], @"OK" );

        GHAssertTrue( [ self_item_.allChildren count ] == 2, @"OK" );

        for ( SCItem* item_ in self_item_.allChildren )
        {
            GHAssertTrue( item_.parent == self_item_, @"OK" );
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
            }
            // STODO: If Cache: allFieldsByName != nil
            GHAssertTrue( 1 <= [ item_.readFieldsByName count ], @"OK" );
        }
    }
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 20 ----
-(SCItem*)testReadItemSCPWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __block SCApiSession* strongContext_  = nil;
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* test_items_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

        NSString* path_ = SCAllowedParentPath;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCReadItemScopeType scope_ = (SCReadItemScopeType)(SCReadItemSelfScope | SCReadItemParentScope | SCReadItemChildrenScope);
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: scope_ ];
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
        {
            test_items_ = items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( test_items_ != nil, @"OK" );
    GHAssertTrue( [ test_items_ count ] >= 1, @"OK" );

    SCItem* test_item_ = nil;

    //test parent item
    {
        test_item_ = test_items_[ 0 ];

        GHAssertTrue( test_item_ != nil, @"OK" );
        GHAssertTrue( [ test_item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( test_item_.parent == nil, @"OK" );
            GHAssertTrue( test_item_.allChildren == nil, @"OK" );
            GHAssertTrue( test_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ test_item_.readFieldsByName count ] == 0, @"OK" );
        }
    }

    //test self with children item
    {
        SCItem* self_item_ = [ apiContext_.extendedApiSession itemWithPath: SCAllowedParentPath
                                                                itemSource: contextSource ];

        GHAssertTrue( self_item_ != nil, @"OK" );
        GHAssertTrue( self_item_.parent == test_item_, @"OK" );
        GHAssertTrue( [ self_item_.displayName isEqualToString: @"Allowed_Parent" ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( self_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ self_item_.readFieldsByName count ] == 0, @"OK" );
        }
        GHAssertTrue( [ self_item_.allChildren count ] == 2, @"OK" );

        for ( SCItem* item_ in self_item_.allChildren )
        {
            GHAssertTrue( item_.parent == self_item_, @"OK" );
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.allFieldsByName  == nil, @"OK" );
                GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
            }
        }
    }
    return [ apiContext_.extendedApiSession itemWithPath: @"/sitecore"
                                              itemSource: contextSource ];
}

-(void)testReadItemsSWithAndWithoutFieldsWithCache
{
    typedef SCItem*(^LensesBlock)(SCItem*, SEL);
    NSMutableArray* array_ = [ NSMutableArray new ];
    //   NSMutableArray* inner_array_ = [ NSMutableArray new ];
    //Add block functions to array
    {
        //Read items S
        LensesBlock block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSWithAllFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSWithSomeFieldsWithRootItem: rootItem_ 
                                                         selector: selector_];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSWithNoFieldsWithRootItem: rootItem_  
                                                       selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        //Read items C
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCWithAllFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCWithSomeFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCWithNoFieldsWithRootItem: rootItem_   
                                                       selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items P
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemPWithAllFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemPWithSomeFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemPWithNoFieldsWithRootItem: rootItem_   
                                                       selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items SC
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCWithAllFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCWithSomeFieldsWithRootItem: rootItem_   
                                                          selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCWithNoFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items SP
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSPWithAllFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
      
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSPWithSomeFieldsWithRootItem: rootItem_   
                                                          selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSPWithNoFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items CP
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCPWithAllFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCPWithSomeFieldsWithRootItem: rootItem_   
                                                          selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCPWithNoFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items SCP
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCPWithAllFieldsWithRootItem: rootItem_   
                                                          selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCPWithSomeFieldsWithRootItem: rootItem_   
                                                           selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCPWithNoFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
    }

    for ( NSUInteger i = 0; i != [ array_ count ]; ++i )
    {
        for ( NSUInteger j = 0; j != [ array_ count ]; ++j )
        {
            NSLog( @"for: i=%lu, j=%lu", (unsigned long)i, (unsigned long)j );
            @autoreleasepool
            {
                LensesBlock block1_ = array_[ i ];
                LensesBlock block2_ = array_[ j ];

                SCItem* rootItem_ = block1_( nil, _cmd );
                block2_( rootItem_, _cmd );
            }
        }
    }
}
@end
