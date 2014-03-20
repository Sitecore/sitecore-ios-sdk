#import "SCAsyncTestCase.h"

@interface UploadMediaTestExtended : SCAsyncTestCase
@end

@implementation UploadMediaTestExtended



-(void)testCreateMediaItemInWeb
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";

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
        request_.site = @"/sitecore/shell";
        
        SCDidFinishAsyncOperationHandler donaHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        loader(nil, nil, donaHandler);

    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: media_item_.path ];
        item_request_.flags = SCReadItemRequestIngnoreCache;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
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
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
        
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
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
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
        request_.site = @"/sitecore/shell";
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            if ( item_ != nil )
            {
                SCField* field_ = [ item_ fieldWithName: @"Alt" ];
                field_.rawValue = @"Image Alt";
                SCField* field2_ = [ item_ fieldWithName: @"Dimensions" ];
                field2_.rawValue = @"10 x 10";
                
                [ item_ saveItemOperation ]( ^( SCItem* editedItem_, NSError* error_ )
                                   {
                                       didFinishCallback_();
                                   } );
            }
            else
            {
                didFinishCallback_();
            }
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };

    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* field_names_ = [ NSSet setWithObjects: @"Dimensions", @"Alt", @"Blob", nil ];
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: media_item_.itemId
                                                                           fieldsNames: field_names_ ];
        item_request_.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
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
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );

    //first item:
    GHAssertTrue( media_item_ != nil, @"OK" );
    NSLog(@"displayName: %@", [ media_item_ displayName ] );
    GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestMediaWithFields" ], @"OK" );
    GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
    GHAssertTrue( [ [ media_item_ readFields ] count ] == 3, @"OK" );
    NSLog(@"[ media_item_ readFieldsByName ]: %@", [ media_item_ readFields ]);
    NSLog(@"Dimensions: %@", [ [ media_item_ fieldWithName: @"Dimensions" ] rawValue ] );
    GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Dimensions" ] rawValue ] isEqualToString: @"10 x 10"], @"OK" );
    GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Alt" ] rawValue ] isEqualToString: @"Image Alt"], @"OK" );
    NSLog(@"[ media_item_ readField ]: %@", [ [ media_item_ fieldWithName: @"Blob" ] fieldValue ] );
    GHAssertTrue( [ [ media_item_ fieldWithName: @"Blob" ] fieldValue ] != nil, @"OK" );
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
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    
    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* field_names_ = [ NSSet setWithObjects: @"Dimensions", @"Alt", nil ];
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: media_item_.itemId 
                                                                           fieldsNames: field_names_ ];
        item_request_.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        item_request_.site = @"/sitecore/shell";
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
                SCField* field1_ = [ media_item_ fieldWithName: @"Dimensions" ];
                field1_.rawValue = @"5 x 5";
                SCField* field2_ = [ media_item_ fieldWithName: @"Alt" ];
                field2_.rawValue = @"La-la-la";
                
                [ media_item_ saveItemOperation ]( ^( SCItem* editedItem_, NSError* error_ )
                {
                    didFinishCallback_();
                } );
            }
            else
            {
                media_item_ = nil;
            }
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
        
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* field_names_ = [ NSSet setWithObjects: @"Dimensions", @"Alt", nil ];
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemId: media_item_.itemId 
                                                                           fieldsNames: field_names_ ];
        item_request_.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
        
        SCDidFinishAsyncOperationHandler donaHandler = ^( NSArray* read_items_, NSError* read_error_ )
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
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: item_request_ ];
        loader(nil, nil, donaHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //first item:
    GHAssertTrue( media_item_ != nil, @"OK" );
    GHAssertTrue( [ [ media_item_ displayName ] hasPrefix: @"TestAndEditMedia" ], @"OK" );
    GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
    GHAssertTrue( [ [ media_item_ readFields ] count ] == 2, @"OK" );
    NSLog(@"[ media_item_ readFieldsByName ]: %@", [ media_item_ readFields ]);
    GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Dimensions" ] rawValue ] isEqualToString: @"5 x 5"], @"OK" );
    GHAssertTrue( [ [ [ media_item_ fieldWithName: @"Alt" ] rawValue ] isEqualToString: @"La-la-la"], @"OK" );
}

-(void)testCreateNotMediaItemInWeb
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];
        
        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestNotAMediaItem";
        request_.itemTemplate  = @"System/Media/Unversioned/File";
        request_.mediaItemData = nil;
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"file";
        request_.folder        = SCCreateMediaFolder;
        request_.site = @"/sitecore/shell";
        
        SCDidFinishAsyncOperationHandler donaHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        loader(nil, nil, donaHandler);
        
    };
    
    __block NSError *readError;
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: media_item_.path ];
        item_request_.flags = SCReadItemRequestIngnoreCache;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
            }
            else
            {
                media_item_ = nil;
            }
            
            readError = read_error_;
            
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //@igk media item with nil image data will not be created with new webApi, test should be fixed
    GHAssertTrue( media_item_ == nil, @"OK" );
    GHAssertTrue( readError != nil, @"OK" );
    GHAssertTrue( [ readError isMemberOfClass: [ SCInvalidPathError class ] ], @"wrong error type");
}

-(void)testCreateMediaItemInCore
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"core";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];
        
        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestCoreMediaItem Extended";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;
        request_.site = @"/sitecore/shell";
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: media_item_.path ];
        item_request_.flags = SCReadItemRequestIngnoreCache;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
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
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( media_item_ != nil, @"OK" );
    GHAssertTrue( [ [ media_item_ displayName ] isEqualToString: @"TestCoreMediaItem Extended" ], @"OK" );
    GHAssertTrue( [ [ media_item_ itemTemplate ] isEqualToString: @"System/Media/Unversioned/Image" ], @"OK" );
}

-(void)testCreateSeveralMediaItems
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];
        
        request_.fileName      = @"File name (Alt)";
        request_.itemName      = @"TestSeveralMediaItems";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;
        request_.site = @"/sitecore/shell";
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( SCItem* item_, NSError* error_ )
            {
                SCDidFinishAsyncOperationHandler doneHandler2 = ^( SCItem* item_, NSError* error_ )
                {
                    media_item_ = item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader2 = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
                loader2(nil, nil, doneHandler2);
            };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    __block NSError *readError;
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: media_item_.path ];
        item_request_.flags = SCReadItemRequestIngnoreCache;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                media_item_ = [ read_items_ objectAtIndex: 0 ];
            }
            else
            {
                media_item_ = nil;
            }
            
            readError = read_error_;
            
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: item_request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //first item:
    //@igk media item with nil image data will not be created with new webApi, test should be fixed
    GHAssertTrue( media_item_ == nil, @"OK" );
    GHAssertTrue( readError != nil, @"OK" );
    GHAssertTrue( [ readError isMemberOfClass: [ SCInvalidPathError class ] ], @"wrong error type");
}


@end