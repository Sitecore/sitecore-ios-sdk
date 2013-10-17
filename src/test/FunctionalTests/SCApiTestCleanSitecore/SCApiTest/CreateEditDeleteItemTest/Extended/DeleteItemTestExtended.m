#import "SCAsyncTestCase.h"

@interface DeleteItemTestExtended : SCAsyncTestCase
@end

@implementation DeleteItemTestExtended

-(CLEANUP_BLOCK)getCleanupBlock
{
    return [ TestingRequestFactory doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase ];
}


-(void)testDeleteParentItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    __block NSString* item2Id= nil;
    __block NSUInteger read_items_count_ = 0;
    __block NSArray* delete_response_ = nil;
    __block NSString* path_ = SCCreateItemPath;
    __block NSError* deleteError = nil;
    
    __block CLEANUP_BLOCK cleanup_block = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";
        
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
            
            request_.site = @"/sitecore/shell";
            request_.itemName     = @"ItemToDelete";
            request_.itemTemplate = @"System/Layout/Layout";
            request_.flags = SCItemReaderRequestReadFieldsValues;
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"{239F9CF4-E5A0-44E0-B342-0F32CD4C6D8B}", @"__Source", nil ];
            request_.fieldsRawValuesByName = fields_;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
            {
                item_ = result;
                request_.request = item_.path;
                request_.itemName     = @"ChildItem";
                [ apiContext_ itemCreatorWithRequest: request_ ]( ^( SCItem* result, NSError* error )
                                                                 {
                                                                     item2_ = result;
                                                                     item2Id = result.itemId;
                                                                     didFinishCallback_();
                                                                 } );
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item2Id ];
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            item_request_.scope = SCItemReaderParentScope;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id response_, NSError* read_error_ )
            {
                deleteError = read_error_;
                delete_response_ = response_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext removeItemsWithRequest: item_request_ ];
            loader(nil, nil, doneHandler);
        };
        cleanup_block = [ delete_block_ copy ];
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item2Id ];
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            item_request_.scope = SCItemReaderParentScope | SCItemReaderSelfScope;

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
            {
                read_items_count_ = [ read_items_ count ];
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: item_request_ ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item:
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
        GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
        
        //second item:
        GHAssertTrue( item2_ != nil, @"OK" );
        GHAssertTrue( [ [ item2_ displayName ] hasPrefix: @"ChildItem" ], @"OK" );
        GHAssertTrue( [ [ item2_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
        
        //removed items:
        GHAssertTrue( read_items_count_ == 0, @"OK" );
        
        NSLog( @"deleteResponse_: %@", delete_response_ );
        GHAssertTrue( [ delete_response_ count ] == 1, @"OK" );
    }
    else
    {
        GHAssertTrue( [deleteError isMemberOfClass: [SCResponseError class] ], @"error class mismatch" );
        
        SCResponseError* castedError = (SCResponseError*)deleteError;
        GHAssertTrue( 403 == castedError.statusCode, @"status code mismatch" );
        
        [ self performAsyncRequestOnMainThreadWithBlock: [ self getCleanupBlock ]
                                               selector: _cmd ];
    }
    
}

-(void)testDeleteItemsHierarchy
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    __block NSString* item2Id = nil;
    __block NSUInteger read_items_count_ = 0;
    __block NSArray* deleteResponse_ = nil;
    __block NSString* deletedItemId_ = @"";
    __block NSError* deleteError = nil;
    __block CLEANUP_BLOCK cleanup_block = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        
        apiContext_.defaultDatabase = @"web";
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
            
            request_.site = @"/sitecore/shell";
            request_.itemName     = @"ItemToDelete";
            request_.itemTemplate = @"System/Layout/Renderings/Xsl Rendering";
            request_.flags = SCItemReaderRequestReadFieldsValues;
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"__Editor", @"__Editor", nil ];
            request_.fieldsRawValuesByName = fields_;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
            {
                item_ = result;
                request_.request = item_.path;
                [ apiContext_ itemCreatorWithRequest: request_ ]( ^( SCItem* result, NSError* error )
                                                                 {
                                                                     item2_ = result;
                                                                     item2Id = result.itemId;
                                                                     didFinishCallback_();
                                                                 } );
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            deletedItemId_ = item_.itemId;
            SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId ];
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            item_request_.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;

            SCDidFinishAsyncOperationHandler doneHandelr = ^( id response_, NSError* read_error_ )
            {
                deleteError = read_error_;
                deleteResponse_ = response_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext removeItemsWithRequest: item_request_ ];
            loader(nil, nil, doneHandelr);
        };
        cleanup_block = [ delete_block_ copy ];
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item2Id ];
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            item_request_.scope = SCItemReaderParentScope | SCItemReaderSelfScope;

            SCDidFinishAsyncOperationHandler doneHandelr =  ^( NSArray* read_items_, NSError* read_error_ )
                                                            {
                                                                read_items_count_ = [ read_items_ count ];
                                                                didFinishCallback_();
                                                            } ;
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: item_request_ ];
            loader(nil, nil, doneHandelr);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item:
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
        GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Renderings/Xsl Rendering" ], @"OK" );
        
        NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
        
        //second item:
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( [ [ item2_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
        GHAssertTrue( [ [ item2_ itemTemplate ] isEqualToString: @"System/Layout/Renderings/Xsl Rendering" ], @"OK" );
        
        NSLog( @"item2_.readFieldsByName: %@", item2_.readFieldsByName );
        GHAssertTrue( [ item2_.readFieldsByName count ] == 0, @"OK" );
        
        //removed items:
        GHAssertTrue( read_items_count_ == 0, @"OK" );
        NSLog( @"deleteResponse_: %@", deleteResponse_ );
        NSLog( @"deletedItemId_: %@", deletedItemId_ );
        GHAssertTrue( [ deleteResponse_ containsObject: deletedItemId_ ], @"OK" );
    }
    else
    {
        GHAssertTrue( [deleteError isMemberOfClass: [SCResponseError class] ], @"error class mismatch" );
        
        SCResponseError* castedError = (SCResponseError*)deleteError;
        GHAssertTrue( 403 == castedError.statusCode, @"status code mismatch" );
        
        [ self performAsyncRequestOnMainThreadWithBlock: [ self getCleanupBlock ]
                                               selector: _cmd ];
    }
}

-(void)testDeleteItemsWithQuery
{
    __block  __weak SCApiContext* apiContext_ = nil;
    __block NSUInteger readItemsCount_ = 0;
    __block NSString* request1_ = nil;
    __block NSString* request2_ = nil;
    __block NSString* request3_ = nil;
    __block NSArray* deleteResponse_ = nil;
    __block SCItem* rootItem_;
    __block NSError* deleteError = nil;
    __block CLEANUP_BLOCK cleanup_block = nil;
    
    SCItem* item_ = nil;
    SCItem* item2_ = nil;
    SCItem* item3_ = nil;
    
    SCItemSourcePOD* webShellEnglish = [ SCItemSourcePOD new ];
    {
        webShellEnglish.language = @"en";
        webShellEnglish.database = @"web";
        webShellEnglish.site     = @"/sitecore/shell";
    }
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
            request_.itemName     = @"ItemToDelete";
            request_.itemTemplate = @"System/Layout/Renderings/Xsl Rendering";
            request_.flags = SCItemReaderRequestReadFieldsValues;
            NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"/xsl/sample rendering.xslt", @"__Editor", nil ];
            request_.fieldsRawValuesByName = fields_;
            request_.site = @"/sitecore/shell";
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
            {
                request1_ = [ result itemId ];
                rootItem_ = result;
                request_.request = [ result path ];
                
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result, NSError* error )
                {
                    request2_ = [ result itemId ];
                    request_.request = [ result path ];
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result, NSError* error )
                     {
                         
                         SCDidFinishAsyncOperationHandler doneHandler3 = ^( id result, NSError* error )
                          {
                              request3_ = [ result itemId ];
                              didFinishCallback_();
                          };
                         
                         SCExtendedAsyncOp loader3 = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
                         loader3(nil, nil, doneHandler3);
                     };
                    
                    SCExtendedAsyncOp loader2 = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
                    loader2(nil, nil, doneHandler2);
                };
                
                
                SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
                loader1(nil, nil, doneHandler1);
            } ;
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword ];
            apiContext_ = strongContext_;
            
            apiContext_.defaultDatabase = @"web";
            SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest new ];
            item_request_.request =
            [ rootItem_.path stringByAppendingString: @"/parent::*/descendant::*[@@key='itemtodelete']" ];
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            item_request_.requestType = SCItemReaderRequestQuery;
            item_request_.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id response_, NSError* read_error_ )
            {
                deleteResponse_ = response_;
                deleteError = read_error_;
                
                NSLog( @"deleteResponse_: %@", deleteResponse_ );
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext removeItemsWithRequest: item_request_ ];
            loader(nil, nil, doneHandler);
        };
        cleanup_block = [ delete_block_ copy ];
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword ];
            apiContext_ = strongContext_;
            
            apiContext_.defaultDatabase = @"web";
            SCItemsReaderRequest* itemRequest_ = [ SCItemsReaderRequest requestWithItemPath: request2_ ];
            itemRequest_.flags = SCItemReaderRequestIngnoreCache;
            itemRequest_.scope = SCItemReaderParentScope | SCItemReaderSelfScope | SCItemReaderChildrenScope;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* readItems_, NSError* read_error_ )
            {
                readItemsCount_ = [ readItems_ count ];
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: itemRequest_ ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
        
        
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item:
        item_ = [ apiContext_ itemWithId: request1_
                                  source: webShellEnglish ];
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
        GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Renderings/Xsl Rendering" ], @"OK" );
        
        //second item:
        item2_ = [ apiContext_ itemWithId: request2_
                                   source: webShellEnglish ];
        GHAssertTrue( item2_ != nil, @"OK" );
        GHAssertTrue( [ [ item2_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
        
        //third item:
        item3_ = [ apiContext_ itemWithId: request3_
                                   source: webShellEnglish ];
        GHAssertTrue( item3_ != nil, @"OK" );
        GHAssertTrue( [ [ item3_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
        
        [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        //remove response:
        GHAssertTrue( readItemsCount_ == 0, @"OK" );
        NSLog( @"deleteResponse_: %@", deleteResponse_ );
        GHAssertTrue( [ deleteResponse_ count ] == 3, @"OK" );
        
        //deleted items
        item_ = [ apiContext_ itemWithId: request1_
                                  source: webShellEnglish ];
        GHAssertNil( item_, @"OK" );
        
        item2_ = [ apiContext_ itemWithId: request2_
                   source: webShellEnglish ];
        GHAssertNil( item2_, @"OK" );
        
        item3_ = [ apiContext_ itemWithId: request3_
                  source: webShellEnglish ];
        GHAssertNil( item3_, @"OK" );
    }
    else
    {
        GHAssertTrue( [deleteError isMemberOfClass: [SCResponseError class] ], @"error class mismatch" );
        
        SCResponseError* castedError = (SCResponseError*)deleteError;
        GHAssertTrue( 403 == castedError.statusCode, @"status code mismatch" );
        
        [ self performAsyncRequestOnMainThreadWithBlock: [ self getCleanupBlock ]
                                               selector: _cmd ];
    }
    
}

-(void)testDeleteItemsWithChildren
{
    __weak __block SCApiContext* weakApiContext_   = nil;
    
    __block NSString* itemId1_;
    __block NSString* itemId2_;
    __block NSString* itemId3_;
    __block SCItem* rootItem_;
    __block NSError* deleteError;
    
    SCItem* item1_ = nil;
    SCItem* item2_ = nil;
    SCItem* item3_ = nil;
    
    __block BOOL itemsWasCreated_ = NO;
    __block BOOL itemsWasRemoved_ = NO;
    
    SCItemSourcePOD* webShellEnglish = [ SCItemSourcePOD new ];
    {
        webShellEnglish.language = @"en";
        webShellEnglish.database = @"web";
        webShellEnglish.site     = @"/sitecore/shell";
    }
    
    @autoreleasepool
    {
        __block SCApiContext* strongApiContext_ = nil;
        
        
        
        __block NSString* currentPath_ = SCCreateItemPath;
        
        strongApiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                            login: SCWebApiAdminLogin
                                                         password: SCWebApiAdminPassword ];
        
        weakApiContext_ = strongApiContext_;
        
        strongApiContext_.defaultDatabase = @"web";
        
        
        
        void (^deleteBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId1_ ];

            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id response_, NSError* error_ )
            {
                deleteError = error_;
                itemsWasRemoved_ = response_ != nil;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ strongApiContext_.extendedApiContext removeItemsWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        //    [ self performAsyncRequestOnMainThreadWithBlock: deleteBlock_
        //                                           selector: _cmd ];
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
            request_.itemName     = @"ItemToDelete";
            request_.itemTemplate = @"System/Layout/Renderings/Xsl Rendering";
            request_.site = @"/sitecore/shell";
            
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result1_, NSError* error_ )
           {
               if ( !result1_ )
               {
                   didFinishCallback_();
                   return;
               }
               rootItem_ = result1_;
               
               itemId1_ = result1_.itemId;
               currentPath_ = [ currentPath_ stringByAppendingPathComponent: result1_.displayName ];
               request_.request = currentPath_;
               
               SCDidFinishAsyncOperationHandler doneHandler1 = ^( SCItem* result2_, NSError* error )
                {
                    if ( !result2_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    itemId2_ = result2_.itemId;
                    currentPath_ = [ currentPath_ stringByAppendingPathComponent: result2_.displayName ];
                    request_.request = currentPath_;
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( SCItem* result3_, NSError* error )
                     {
                         itemId3_ = result3_.itemId;
                         itemsWasCreated_ = ( result3_ != nil );
                         didFinishCallback_();
                     };
                    
                    SCExtendedAsyncOp loader2 = [ strongApiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
                    loader2(nil, nil, doneHandler2);
                    
                };
               
               SCExtendedAsyncOp loader1 = [ strongApiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
               loader1(nil, nil, doneHandler1);
           };
            
            SCExtendedAsyncOp loader = [ strongApiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
        
        GHAssertTrue( itemsWasCreated_, @"OK" );
        
        GHAssertNotNil( weakApiContext_, @"OK" );
        
        item1_ = [ strongApiContext_ itemWithId: itemId1_
                                         source: webShellEnglish ];
        GHAssertNotNil( item1_, @"OK" );
        
        item2_ = [ strongApiContext_ itemWithId: itemId2_
                                         source: webShellEnglish ];
        GHAssertNotNil( item2_, @"OK" );
        
        item3_ = [ strongApiContext_ itemWithId: itemId3_
                                         source: webShellEnglish ];
        GHAssertNotNil( item3_, @"OK" );
        
        itemsWasRemoved_ = NO;
        
        [ self performAsyncRequestOnMainThreadWithBlock: deleteBlock_
                                               selector: _cmd ];
        
        [ [ weakApiContext_.extendedApiContext itemsCache ] cleanupAll ];
        if ( IS_ANONYMOUS_ACCESS_ENABLED )
        {
            GHAssertTrue( itemsWasRemoved_, @"OK" );
            GHAssertNotNil( weakApiContext_, @"OK" );
            
            item1_ = [ weakApiContext_ itemWithId: itemId1_
                                           source: webShellEnglish ];
            GHAssertNil( item1_, @"OK" );
            
            item2_ = [ weakApiContext_ itemWithId: itemId2_
                                           source: webShellEnglish ];
            GHAssertNil( item2_, @"OK" );
            
            item3_ = [ weakApiContext_ itemWithId: itemId3_
                                           source: webShellEnglish ];
            GHAssertNil( item3_, @"OK" );
        }
        else
        {
            GHAssertFalse( itemsWasRemoved_, @"OK" );
            GHAssertTrue( [deleteError isMemberOfClass: [SCResponseError class] ], @"error class mismatch" );
            
            SCResponseError* castedError = (SCResponseError*)deleteError;
            GHAssertTrue( 403 == castedError.statusCode, @"status code mismatch" );
            
            [ self performAsyncRequestOnMainThreadWithBlock: [ self getCleanupBlock ]
                                                   selector: _cmd ];
        }
        
        rootItem_ = nil;
    }
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertNil( weakApiContext_, @"Items deleted. Contest must be disposed too" );
    }
    else
    {
        GHAssertNotNil( weakApiContext_, @"Non deleted items must hold the context around" );
    }
}

@end
