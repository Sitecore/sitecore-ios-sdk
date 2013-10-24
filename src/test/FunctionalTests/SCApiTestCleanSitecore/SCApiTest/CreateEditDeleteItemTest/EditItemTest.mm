#import "SCAsyncTestCase.h"

#define MOCK_DOES_NOT_WORK

static NSInteger asyncSaveItemInvocationCount = 0;

@interface EditItemTest : SCAsyncTestCase
@end

@implementation EditItemTest

-(void)testCreateAndEditItemInWeb
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* edited_item_ = nil;
    
    asyncSaveItemInvocationCount = 0;
#ifndef MOCK_DOES_NOT_WORK
    JFFSimpleBlock disableMockGuardBlock = ^void()
    {
        [ [ self class ] unHookInstanceMethodForClass: [ SCItem class ]
                                         withSelector: @selector(asyncSaveItemWithDirtyFields:)
                              prototypeMethodSelector: @selector(mockAsyncSaveItemWithDirtyFields:)
                                   hookMethodSelector: @selector(asyncSaveItemWithDirtyFields__OldImpl:) ];
    };
    
    [ [ self class ] hookInstanceMethodForClass: [ SCItem class ]
                                   withSelector: @selector(asyncSaveItemWithDirtyFields:)
                        prototypeMethodSelector: @selector(mockAsyncSaveItemWithDirtyFields:)
                             hookMethodSelector: @selector(asyncSaveItemWithDirtyFields__OldImpl:) ];
    ::Utils::ObjcScopedGuard connectionMockGuard( disableMockGuardBlock );
#endif
    
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

            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                edited_item_ = result;
                didFinishCallback_();
            } );
        };

        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] != 0 )
                {
                    SCItem* item_ = [ items_ objectAtIndex: 0 ];
                    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                    SCField* field_ = [ item_.readFieldsByName objectForKey: @"__Editor" ];
                    field_.rawValue = @"Text2";
                    [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                    {
                        edited_item_ = editedItem_;
                        NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] );
                        didFinishCallback_();
                    } );
                }
                else 
                {
                    didFinishCallback_();
                }
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];

        [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                               selector: _cmd ];
    }
    
#ifndef MOCK_DOES_NOT_WORK
    disableMockGuardBlock();
    connectionMockGuard.Release();
#endif

    
    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"Tweet Item" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Common/Folder" ], @"OK" );

    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"__Editor" ] rawValue ] isEqualToString: @"Text2" ], @"OK" );
    
#ifndef MOCK_DOES_NOT_WORK
    GHAssertTrue( 1 == asyncSaveItemInvocationCount, @"HTTP request count mismatch" );
#endif
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
            
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                edited_item_ = result;
                didFinishCallback_();
            } );
        };
        
        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
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
            } );
        };
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            request_.flags = SCItemReaderRequestIngnoreCache;
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
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
            } );
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

            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                edited_item_ = result;
                didFinishCallback_();
            } );
        };

        void (^editBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
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
            } );
        };
        void (^readBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                            fieldsNames: fieldNames_ ];
            request_.flags = SCItemReaderRequestIngnoreCache;

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
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
            } );
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
            
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
                                                             {
                                                                 edited_item_ = result;
                                                                 didFinishCallback_();
                                                             } );
        };
        
        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                            fieldsNames: fieldNames_ ];
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
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
            } );
        };
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                            fieldsNames: fieldNames_ ];
            request_.flags = SCItemReaderRequestIngnoreCache;
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
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
            } );
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
            
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                edited_item_ = result;
                didFinishCallback_();
            } );
        };
        
        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] != 0 )
                {
                    apiContext_.defaultDatabase = @"web";
                    
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
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
        if ( nil == edited_item_ )
        {
            GHFail( @"item not created" );
            return;
        }
        
        
        [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                               selector: _cmd ];
    }
    
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    NSString* edited_display_name_ = [ edited_item_ displayName ];
    GHAssertTrue( [ edited_display_name_ hasPrefix: @"Text2" ], @"OK" );
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
            
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                edited_item_ = result;
                request_.request = [ (SCItem*)result path ];
                [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
                {
                    [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
                    {
                        didFinishCallback_();
                    } );
                } );
            } );
        };
        
        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"Dictionary", @"Iso", @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                            fieldsNames: fieldNames_ ];
            request_.scope = static_cast<SCItemReaderScopeType>( SCItemReaderSelfScope | SCItemReaderChildrenScope );
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
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
            } );
        };
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"Dictionary", @"Iso", @"__Display name", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            request_.flags = SCItemReaderRequestIngnoreCache;
            request_.scope = static_cast<SCItemReaderScopeType>( SCItemReaderSelfScope | SCItemReaderChildrenScope );
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
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
            } );
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

-(JFFAsyncOperation)mockAsyncSaveItemWithDirtyFields:( NSSet* )dirtyFields
{
    ++asyncSaveItemInvocationCount;
    return [ self asyncSaveItemWithDirtyFields__OldImpl: dirtyFields ];
}

-(JFFAsyncOperation)asyncSaveItemWithDirtyFields__OldImpl:( NSSet* )dirtyFields
{
    // IDLE
    return nil;
}


-(void)testSaveItemWithoutEditingDoesNotSendHttpRequest
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* edited_item_ = nil;
    
    __block NSString* originalItemField = nil;
    __block NSString* savedItemField = nil;

#ifndef MOCK_DOES_NOT_WORK
    __block BOOL isConnectionStarted = NO;
    
    asyncSaveItemInvocationCount = 0;

    JFFSimpleBlock disableMockGuardBlock = ^void()
    {
        [ [ self class ] unHookInstanceMethodForClass: [ SCItem class ]
    withSelector: @selector(asyncSaveItemWithDirtyFields:)
                              prototypeMethodSelector: @selector(mockAsyncSaveItemWithDirtyFields:)
                                   hookMethodSelector: @selector(asyncSaveItemWithDirtyFields__OldImpl:) ];
    };

    [ [ self class ] hookInstanceMethodForClass: [ SCItem class ]
                                   withSelector: @selector(asyncSaveItemWithDirtyFields:)
                        prototypeMethodSelector: @selector(mockAsyncSaveItemWithDirtyFields:)
                             hookMethodSelector: @selector(asyncSaveItemWithDirtyFields__OldImpl:) ];
    ::Utils::ObjcScopedGuard connectionMockGuard( disableMockGuardBlock );
#endif
    
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
            
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
             {
                 edited_item_ = result;
                 didFinishCallback_();
             } );
        };
        
        void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Editor", nil ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                          fieldsNames: fieldNames_ ];
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
             {
                 if ( [ items_ count ] != 0 )
                 {
                     SCItem* item_ = [ items_ objectAtIndex: 0 ];
                     NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                     
                     SCField* field_ = [ item_.readFieldsByName objectForKey: @"__Editor" ];
                     originalItemField = field_.rawValue;
                     
                     // @adk : no editing is performed before saving
                     [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                    {
                        edited_item_ = editedItem_;
                        savedItemField = [ [ edited_item_ fieldWithName: @"__Editor" ]  rawValue ];
                        
                        NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] );
                        didFinishCallback_();
                    } );
                 }
                 else 
                 {
                     didFinishCallback_();
                 }
             } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
        
        [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                               selector: _cmd ];
    }
    
#ifndef MOCK_DOES_NOT_WORK
    disableMockGuardBlock();
    connectionMockGuard.Release();
#endif

    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"Tweet Item" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Common/Folder" ], @"OK" );
    
    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Editor" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"__Editor" ] rawValue ] isEqualToString: originalItemField ], @"OK" );
    
#ifndef MOCK_DOES_NOT_WORK
    isConnectionStarted = ( 0 != asyncSaveItemInvocationCount );
    GHAssertFalse( isConnectionStarted, @"no HTTP request expected for unchanged object" );
#endif
}

@end