#import "SCAsyncTestCase.h"

@interface UploadMediaTest : SCAsyncTestCase
@end

@implementation UploadMediaTest



-(void)testCreateMediaItemInWeb
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* createError = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                  login: SCExtranetAdminLogin
                                               password: SCExtranetAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"";

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];

        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestMediaItem";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;

        [ apiContext_ uploadMediaOperationWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
        {
            createError = error_;
            media_item_ = item_;
            didFinishCallback_();
        } );

    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: media_item_.path ];
        item_request_.flags = SCReadItemRequestIngnoreCache;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
            }
            else 
            {
                media_item_ = nil;
            }
            didFinishCallback_();                                                  
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
        
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //first item:
    GHAssertTrue( media_item_ != nil, @"OK" );
    NSLog( @"[ media_item_ displayName ]:%@", [ media_item_ displayName ] );
    GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestMediaItem" ], @"OK" );
    GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
   }

-(void)testCreateMediaItemWithFields
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* createError = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];

        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestMediaWithFields";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet setWithObjects: @"Dimensions", @"Alt", nil ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;

        [ apiContext_ uploadMediaOperationWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
        {
            createError = error_;
            
            media_item_ = item_;
            if ( item_ != nil ) 
            {
                SCField* field_ = [ item_.readFieldsByName objectForKey: @"Alt" ];
                field_.rawValue = @"Image Alt";
                SCField* field2_ = [ item_.readFieldsByName objectForKey: @"Dimensions" ];
                field2_.rawValue = @"10 x 10";

                [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                {
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
        NSSet* field_names_ = [ NSSet setWithObjects: @"Dimensions", @"Alt", @"Blob", @"media", nil ];
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: media_item_.itemId
                                                                           fieldsNames: field_names_ ];
        item_request_.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
            }
            else 
            {
                media_item_ = nil;
            }
            didFinishCallback_();                                                  
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );

        //first item:
        GHAssertTrue( media_item_ != nil, @"OK" );
        NSLog(@"displayName: %@", [ media_item_ displayName ] );
        GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestMediaWithFields" ], @"OK" );
        GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
        GHAssertTrue( [ [ media_item_ readFieldsByName ] count ] == 3, @"OK" );
        NSLog(@"[ media_item_ readFieldsByName ]: %@", [ media_item_ readFieldsByName ]);
        NSLog(@"Dimensions: %@", [ [ media_item_ fieldWithName: @"Dimensions" ] rawValue ] );
        GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Dimensions" ] rawValue ] isEqualToString: @"10 x 10"], @"OK" );
        GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Alt" ] rawValue ] isEqualToString: @"Image Alt"], @"OK" );
        NSLog(@"[ media_item_ readField ]: %@", [ [ media_item_ fieldWithName: @"Blob" ] fieldValue ] );
        NSLog(@"[ media_item_ readField ]: %@", [ [ media_item_ fieldWithName: @"Media" ] fieldValue ] );
        GHAssertTrue( [ [ media_item_ fieldWithName: @"Blob" ] fieldValue ] != nil, @"OK" );
    }
    else
    {
        //@igk [new webApi] admin has access to the extranet domain
        GHAssertTrue( media_item_ != nil, @"OK" );

        GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestMediaWithFields" ], @"OK" );
        GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
        GHAssertTrue( [ [ media_item_ readFieldsByName ] count ] == 3, @"OK" );
        
        GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Dimensions" ] rawValue ] isEqualToString: @"10 x 10"], @"OK" );
        GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Alt" ] rawValue ] isEqualToString: @"Image Alt"], @"OK" );
      
        //FIXME: @igk check why Blob value is nil?
        GHAssertTrue( [ [ media_item_ fieldWithName: @"Blob" ] fieldValue ] != nil, @"OK" );
    }
}

-(void)testCreateAndEditMediaItem
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"master";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];
        
        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestAndEditMedia";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet setWithObjects: @"Dimensions", @"Alt", nil ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;
        request_.site = @"/sitecore/shell";
        
        [ apiContext_ uploadMediaOperationWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            GHAssertTrue(media_item_ != nil, @"item should be created");
            didFinishCallback_();
        } );
        
    };
    
    
    
    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* field_names_ = [ NSSet setWithObjects: @"Dimensions", @"Alt", nil ];
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: media_item_.itemId 
                                                                           fieldsNames: field_names_ ];
        item_request_.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
                SCField* field1_ = [ media_item_ fieldWithName: @"Dimensions" ];
                field1_.rawValue = @"5 x 5";
                SCField* field2_ = [ media_item_ fieldWithName: @"Alt" ];
                field2_.rawValue = @"La-la-la";
                
                [ media_item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                {
                    didFinishCallback_();
                } );
            }
            else 
            {
                media_item_ = nil;
            }
            didFinishCallback_();                                                  
        } );
        
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* field_names_ = [ NSSet setWithObjects: @"Dimensions", @"Alt", nil ];
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: media_item_.itemId 
                                                                           fieldsNames: field_names_ ];
        item_request_.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
            }
            else 
            {
                media_item_ = nil;
            }
            didFinishCallback_();                                                  
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];
    GHAssertTrue( media_item_ != nil, @"Item Editing failed" );

    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //first item:
    GHAssertTrue( media_item_ != nil, @"OK" );
    GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestAndEditMedia" ], @"OK" );
    GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
    GHAssertTrue( [ [ media_item_ readFieldsByName ] count ] == 2, @"OK" );
    NSLog(@"[ media_item_ readFieldsByName ]: %@", [ media_item_ readFieldsByName ]);
    GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Dimensions" ] rawValue ] isEqualToString: @"5 x 5"], @"OK" );
    GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Alt" ] rawValue ] isEqualToString: @"La-la-la"], @"OK" );
}

-(void)testCreateNotMediaItemInWeb
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* createError = nil;
    
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];
        
        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestNotAMediaItem";
        request_.itemTemplate  = @"System/Media/Unversioned/File";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );;
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"file";
        request_.folder        = SCCreateMediaFolder;
        
        [ apiContext_ uploadMediaOperationWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
        {
            createError = error_;
            media_item_ = item_;
            didFinishCallback_();
        } );
        
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: media_item_.path ];
        item_request_.flags = SCReadItemRequestIngnoreCache;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
            }
            else 
            {
                media_item_ = nil;
            }
            didFinishCallback_();                                                  
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        
        
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item:
        GHAssertTrue( media_item_ != nil, @"OK" );
        GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestNotAMediaItem" ], @"OK" );
        //@igk [new webApi] item template changed by server according to the extention of file name
        GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
    }
    else
    {
        //@igk [new webApi] admin user has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item:
        GHAssertTrue( media_item_ != nil, @"OK" );
        GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestNotAMediaItem" ], @"OK" );
        //@igk [new webApi] item template changed by server according to the extention of file name
        GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );

    }
}

-(void)testCreateMediaItemInCore
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* createError = nil;
    
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"core";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];
        
        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestCoreMediaItem";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;
        
        [ apiContext_ uploadMediaOperationWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
        {
            createError = error_;
            media_item_ = item_;
            didFinishCallback_();
        } );
        
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: media_item_.path ];
        item_request_.flags = SCReadItemRequestIngnoreCache;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
            }
            else 
            {
                media_item_ = nil;
            }
            didFinishCallback_();                                                  
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
        
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        GHAssertTrue( media_item_ != nil, @"OK" );
        GHAssertTrue( [ [ media_item_ displayName ] isEqualToString: @"TestCoreMediaItem" ], @"OK" );
        GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
    }
    else
    {
        //@igk [new webApi] admin has access to the extranet domain
        GHAssertNil( createError, @"error class mismatch" );
        
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        GHAssertTrue( media_item_ != nil, @"OK" );
        GHAssertTrue( [ [ media_item_ displayName ] isEqualToString: @"TestCoreMediaItem" ], @"OK" );
        GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
    }
}

-(void)testCreateSeveralMediaItems
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* createError = nil;
    
    
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];
        
        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestSeveralMediaItems";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;
        
        [ apiContext_ uploadMediaOperationWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
        {
            [ apiContext_ uploadMediaOperationWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
            {
                [ apiContext_ uploadMediaOperationWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
                {
                    createError = error_;
                    media_item_ = item_;
                    didFinishCallback_();
                } );
            } );
        } );
        
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: media_item_.path ];
        item_request_.flags = SCReadItemRequestIngnoreCache;
        [ apiContext_ readItemsOperationWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
            }
            else 
            {
                media_item_ = nil;
            }
            didFinishCallback_();                                                  
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {

        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item:
        GHAssertTrue( media_item_ != nil, @"OK" );
        GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestSeveralMediaItems" ], @"OK" );
        GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
    }
    else
    {
        //@igk [new webApi] admin has access to the extranet domain
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item:
        GHAssertTrue( media_item_ != nil, @"OK" );
        GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestSeveralMediaItems" ], @"OK" );
        GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
    }
}

@end