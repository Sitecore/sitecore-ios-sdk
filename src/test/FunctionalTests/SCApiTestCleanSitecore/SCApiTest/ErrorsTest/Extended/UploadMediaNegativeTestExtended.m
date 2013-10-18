#import "SCAsyncTestCase.h"

@interface UploadMediaNegativeTestExtended : SCAsyncTestCase
@end

@implementation UploadMediaNegativeTestExtended

-(void)testCreateMediaWithoutName
{
    __weak __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        apiContext_.defaultDatabase = @"master";

        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];

            request_.itemName      = @" ";
            request_.itemTemplate  = @"System/Media/Unversioned/Image";
            request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: @"auto tests.png" ] );
            request_.fieldNames    = nil;
            request_.contentType   = @"image/png";
            request_.folder        = SCCreateMediaFolder;

            SCDidFinishAsyncOperationHandler doneHandler = ^( id item_, NSError* error_ )
            {
                media_item_ = item_;
                response_error_ = error_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext mediaItemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
            
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( media_item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCNoItemError class ] ], @"OK" );
}

-(void)testCreateMediaWithInvalidName
{
    __weak __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
        
        request_.itemName      = @"  _$";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: @"auto tests.png" ] );
        request_.fieldNames    = nil;
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;

        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext mediaItemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_   == nil, @"OK" );
    GHAssertTrue( media_item_     == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCNoItemError class ] ], @"OK" );
}

-(void)testCreateMediaWithInvalidTemplate
{
    __weak __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
        
        request_.itemName      = @"Invalid Template";
        request_.itemTemplate  = @"System/Media/Unversioned/Invalid";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: @"auto tests.png" ] );
        request_.fieldNames    = nil;
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext mediaItemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( media_item_ != nil, @"OK" );
    NSLog(@"template: %@", [ media_item_ itemTemplate ] );
    GHAssertEqualStrings([ media_item_ itemTemplate ], @"System/Media/Unversioned/File", @"Temppate path wrong");
    GHAssertTrue( response_error_ == nil, @"OK" );
}

-(void)testCreateMediaWithEmptyFile
{
    __weak __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        
        apiContext_.defaultDatabase = @"web";
        
        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
            
            request_.itemName      = @"Empty Media";
            request_.itemTemplate  = @"System/Media/Unversioned/File";
            request_.mediaItemData = nil;
            request_.fieldNames    = nil;
            request_.contentType   = @"image/png";
            request_.folder        = SCCreateMediaFolder;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
            {
                media_item_ = item_;
                response_error_ = error_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext mediaItemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
            
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( media_item_ != nil, @"OK" );
    GHAssertTrue( response_error_ == nil, @"OK" );
    BOOL itemHasPrefix = [ [ media_item_ displayName ] hasPrefix: @"Empty Media" ];
    GHAssertTrue( itemHasPrefix, @"item should has a prefix 'Empty Media'" );
    GHAssertEqualStrings([ media_item_ itemTemplate ], @"System/Media/Unversioned/File", @"wrong item template path");
    GHAssertTrue( [ media_item_ readFieldsByName ] != nil, @"OK" );
}

-(void)testCreateMediaWithHighData
{
    __weak __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
        
        request_.itemName      = @"Large Image";
        request_.fileName      = @"large_image.jpg";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = nil;
        request_.contentType   = @"image/jpg";
        request_.folder        = SCCreateMediaFolder;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext mediaItemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( media_item_ != nil, @"OK" );
    GHAssertTrue( response_error_ == nil, @"OK" );
    NSLog( @"media_item_: %@", media_item_ );
    NSLog( @"media_item_template: %@", [ media_item_ itemTemplate ]);
    BOOL namePrefix = [ [ media_item_ displayName ] hasPrefix: @"Large Image" ];
    GHAssertTrue( namePrefix, @"item name shoud has prefix 'Large Image'" );
    GHAssertEqualStrings([ media_item_ itemTemplate ], @"System/Media/Unversioned/Jpeg", @"wrong item template path");
    GHAssertTrue( [ media_item_ readFieldsByName ] != nil, @"OK" );

}

-(void)testCreateMediaWithInvalidUser_shell
{
    __weak __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                         login: @"notexisted"
                                                      password: @"notexisted" ];
        apiContext_ = strongContext_;
        
        
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
        
        request_.itemName      = @"InvalidUserAdd";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: @"auto tests.png" ] );
        request_.fieldNames    = nil;
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            response_error_ = error_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext mediaItemCreatorWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    }
    
    
    NSLog( @"response_error_: %@", response_error_ );
    NSLog( @"media_item_: %@", media_item_ );
    GHAssertTrue( media_item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
}

-(void)testCreateMediaWithInvalidUser
{
    __weak __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                         login: @"notexisted"
                                                      password: @"notexisted" ];
        apiContext_ = strongContext_;
        apiContext_.defaultSite = @"/sitecore/shell";
        
        apiContext_.defaultDatabase = @"web";
        apiContext_.defaultSite = nil;
        
        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
            
            request_.itemName      = @"InvalidUserAdd";
            request_.itemTemplate  = @"System/Media/Unversioned/Image";
            request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: @"auto tests.png" ] );
            request_.fieldNames    = nil;
            request_.contentType   = @"image/png";
            request_.folder        = SCCreateMediaFolder;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
            {
                media_item_ = item_;
                response_error_ = error_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext mediaItemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
            
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
    }
    
    NSLog( @"response_error_: %@", response_error_ );
    NSLog( @"media_item_: %@", media_item_ );
    GHAssertTrue( media_item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
}

-(void)testCreateMediaWithLowPermissionUser
{
    // ===========COMPATIBILITY===========
    // @adk - item web api fixed in CMS 7.1.
    // https://support.sitecore.net/client/ViewItem.aspx?type=defects&id=393416
    // The test will fail for older releases

    __weak __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiNocreateLogin
                                                      password: SCWebApiNocreatePassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultSite = @"/sitecore/shell";
        
        apiContext_.defaultDatabase = @"web";
        
        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
            
            request_.itemName      = @"LowPermissionUserAdd";
            request_.itemTemplate  = @"System/Media/Unversioned/Image";
            request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: @"auto tests.png" ] );
            request_.fieldNames    = nil;
            request_.contentType   = @"image/png";
            request_.folder        = SCCreateMediaFolder;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
            {
                media_item_ = item_;
                response_error_ = error_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext mediaItemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
            
        };
         
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
    }

    NSLog( @"response_error_: %@", response_error_ );
    NSLog( @"media_item_: %@", media_item_ );
    GHAssertTrue( media_item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
    
    SCResponseError* castedError = (SCResponseError*)response_error_;
    GHAssertTrue( [ castedError statusCode ] == 403, @"error code mismatch" );
    GHAssertTrue( [ [ castedError localizedDescription ] containsString: @"Access denied" ], @"OK" );
}

-(void)testCreateMediaWithNotExitedFolder
{
    __weak __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* response_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        
        
        apiContext_.defaultDatabase = @"web";
    
        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
            
            request_.itemName      = @"NotExistedFolder";
            request_.itemTemplate  = @"System/Media/Unversioned/Image";
            request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: @"auto tests.png" ] );
            request_.fieldNames    = nil;
            request_.contentType   = @"image/png";
            request_.folder        = [ SCCreateMediaFolder stringByAppendingString: @"NotExistedFolder" ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
            {
                media_item_ = item_;
                response_error_ = error_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext mediaItemCreatorWithRequest: request_ ];
            loader(nil, nil, doneHandler);
            
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( media_item_ == nil, @"OK" );
    GHAssertTrue( response_error_ != nil, @"OK" );
    GHAssertTrue( [ response_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
}

@end
