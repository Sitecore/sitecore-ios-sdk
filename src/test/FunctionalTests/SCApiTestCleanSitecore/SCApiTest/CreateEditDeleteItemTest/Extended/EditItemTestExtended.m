#import "SCAsyncTestCase.h"

@interface EditItemTestExtended : SCAsyncTestCase
@end

@implementation EditItemTestExtended

-(void)testCreateAndEditItemInWeb
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* edited_item_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ =
        [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
    
        apiContext_.defaultDatabase = @"web";


        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Tweet Item";
            request_.itemTemplate = @"Common/Folder";
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
            {
                edited_item_ = result;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };

        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];

            SCDidFinishAsyncOperationHandler mainDoneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] != 0 )
                {
                    SCItem* item_ = [ items_ objectAtIndex: 0 ];
                    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                    SCField* field_ = [ item_.readFieldsByName objectForKey: @"__Editor" ];
                    field_.rawValue = @"Text2";
                    
                    SCDidFinishAsyncOperationHandler donaHandler = ^( SCItem* editedItem_, NSError* error_ )
                    {
                        edited_item_ = editedItem_;
                        NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] );
                        didFinishCallback_();
                    };
                    
                    SCExtendedAsyncOp loader = [ item_ extendedSaveItem ];
                    loader(nil, nil, donaHandler);
                }
                else
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp mainLoader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            mainLoader(nil, nil, mainDoneHandler);
        };

        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"Tweet Item" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Common/Folder" ], @"OK" );

    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"__Editor" ] rawValue ] isEqualToString: @"Text2" ], @"OK" );
}

-(void)testCreateAndEditItemInMaster
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* edited_item_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ =
        [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"master";

        
        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
            
            request_.itemName     = @"Empty Item";
            request_.itemTemplate = @"Common/Folder";
            
            SCDidFinishAsyncOperationHandler doneHAndler = ^( id result, NSError* error )
            {
                edited_item_ = result;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHAndler);
        };
        
        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] != 0 )
                {
                    SCItem* item_ = [ items_ objectAtIndex: 0 ];
                    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                    SCField* field_ = [ item_.readFieldsByName objectForKey: @"__Editor" ];
                    field_.rawValue = @"Text22__";
                    SCField* field2_ = [ item_.readFieldsByName objectForKey: @"__Display name" ];
                    field2_.rawValue = @"urla22__";
                    [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                                       {
                                           edited_item_ = editedItem_;
                                           didFinishCallback_();
                                       } );
                }
                else
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            request_.flags = SCItemReaderRequestIngnoreCache;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] > 0 )
                {
                    edited_item_ = [ items_ objectAtIndex: 0 ];
                    didFinishCallback_();
                }
                else
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"urla22__" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Common/Folder" ], @"OK" );
    
    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 2, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] isEqualToString: @"Text22__" ], @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"__Display name" ] rawValue ] isEqualToString: @"urla22__" ], @"OK" );
}

-(void)testCreateAndEditSystemItemInWeb
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* edited_item_ = nil;
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ =
        [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        apiContext_.defaultDatabase = @"web";
        

        void (^createBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];

            request_.itemName     = @"Language Item";
            request_.itemTemplate = @"System/Language";
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
            {
                edited_item_ = result;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };

        void (^editBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] != 0 )
                {
                    SCItem* item_ = [ items_ objectAtIndex: 0 ];
                    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                    SCField* field3_ = [ item_.readFieldsByName objectForKey: @"__Display name" ];
                    field3_.rawValue = @"Display_name";
                    [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                                       {
                                           edited_item_ = editedItem_;
                                           didFinishCallback_();
                                       } );
                }
                else
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        void (^readBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                            fieldsNames: fieldNames_ ];
            request_.flags = SCItemReaderRequestIngnoreCache;

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] > 0 )
                {
                    NSLog( @"items fields: %@", [ [ items_ objectAtIndex: 0 ] readFieldsByName ] );
                    edited_item_ = [ items_ objectAtIndex: 0 ];
                    didFinishCallback_();
                }
                else
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };

        [ self performAsyncRequestOnMainThreadWithBlock: createBlock_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: editBlock_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: readBlock_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"System/Language" ], @"OK" );
    
    NSLog( @"items fields: %@", [ edited_item_ readFieldsByName ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"__Display name" ] rawValue ] isEqualToString: @"Display_name" ], @"OK" );
}

-(void)testCreateAndEditItemNotSave
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* edited_item_ = nil;
    
    @autoreleasepool
    {
        SCApiContext* strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"web";


        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
            
            request_.itemName     = @"Not Saved Item";
            request_.itemTemplate = @"Common/Folder";
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
            {
                edited_item_ = result;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                            fieldsNames: fieldNames_ ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] != 0 )
                {
                    SCItem* item_ = [ items_ objectAtIndex: 0 ];
                    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                    SCField* field_ = [ item_.readFieldsByName objectForKey: @"__Editor" ];
                    field_.rawValue = @"Text2";
                    edited_item_ = item_;
                    didFinishCallback_();
                }
                else
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                            fieldsNames: fieldNames_ ];
            request_.flags = SCItemReaderRequestIngnoreCache;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] > 0 )
                {
                    edited_item_ = [ items_ objectAtIndex: 0 ];
                    didFinishCallback_();
                }
                else
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };

        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"Not Saved Item" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Common/Folder" ], @"OK" );
    
    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] isEqualToString: @"" ], @"OK" );
    
}

-(void)testCreateAndEditItemInCore
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* edited_item_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ =
        [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        apiContext_.defaultDatabase = @"core";

        
        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
            
            request_.itemName     = @"Folder Item";
            request_.itemTemplate = @"Common/Folder";
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
            {
                edited_item_ = result;
                didFinishCallback_();
            } ;
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] != 0 )
                {
                    SCItem* item_ = [ items_ objectAtIndex: 0 ];
                    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                    SCField* field_ = [ item_.readFieldsByName objectForKey: @"__Display name" ];
                    field_.rawValue = @"Text2";
                    [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                                       {
                                           edited_item_ = editedItem_;
                                           didFinishCallback_();
                                       } );
                }
                else
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                               selector: _cmd ];
    }
    
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"Text2" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Common/Folder" ], @"OK" );
    
    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Display name" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"__Display name" ] fieldValue ] isEqualToString: @"Text2" ], @"OK" );
    
}

-(void)testCreateAndEditSeveralItemsAtOnce
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* edited_item_ = nil;
    __block NSUInteger items_count_ = 0;
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ =
        [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
    
        apiContext_.defaultDatabase = @"web";
        
        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: SCCreateItemPath ];
            
            request_.itemName     = @"Several Items";
            request_.itemTemplate = @"System/Language";
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result, NSError* error )
            {
                edited_item_ = result;
                request_.request = [ (SCItem*)result path ];
                
                SCDidFinishAsyncOperationHandler donaHandler1 = ^( id result, NSError* error )
                {
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result, NSError* error )
                    {
                        didFinishCallback_();
                    };
                    
                    SCExtendedAsyncOp loader2 = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
                    loader2(nil, nil, doneHandler2);
                };
                
                SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
                loader1(nil, nil, donaHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"Dictionary", @"Iso", @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                            fieldsNames: fieldNames_ ];
            request_.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] > 0 )
                {
                    __block NSUInteger i = 0;
                    for (SCItem* curr_item_ in items_)
                    {
                        SCItem* item_ = curr_item_;
                        item_ = [ items_ objectAtIndex: 0 ];
                        NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                        SCField* field_ = [ item_.readFieldsByName objectForKey: @"Dictionary" ];
                        field_.rawValue = @"en-US.tdf";
                        SCField* field2_ = [ item_.readFieldsByName objectForKey: @"Iso" ];
                        field2_.rawValue = @"en";
                        SCField* field3_ = [ item_.readFieldsByName objectForKey: @"__Display name" ];
                        field3_.rawValue = @"__Display name new";
                        [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                                           {
                                               i++;
                                               edited_item_ = editedItem_;
                                               if ( i == items_.count )
                                               {
                                                   didFinishCallback_();
                                               }
                                           } );
                    }
                }
                else 
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
            
        };
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"Dictionary", @"Iso", @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            request_.flags = SCItemReaderRequestIngnoreCache;
            request_.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] > 0 )
                {
                    items_count_ = [ items_ count ];
                    edited_item_ = [ items_ objectAtIndex: 0 ];
                    didFinishCallback_();
                }
                else
                {
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
            
        [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( items_count_ == 3, @"OK" );
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"__Display name new" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"System/Language" ], @"OK" );
    
    NSLog( @"items fields: %@", [ edited_item_ readFieldsByName ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 3, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Dictionary" ] fieldValue ] isEqualToString: @"en-US.tdf" ], @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Iso" ] rawValue ] isEqualToString: @"en" ], @"OK" );
}


@end