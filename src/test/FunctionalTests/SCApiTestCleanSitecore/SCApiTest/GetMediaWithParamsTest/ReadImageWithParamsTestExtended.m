#import "SCAsyncTestCase.h"

@interface ReadImageWithParamsTestExtended : SCAsyncTestCase
@end

@implementation ReadImageWithParamsTestExtended


-(void)testCreateAndReadImageWithPArams
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

        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            didFinishCallback_();
        } ;
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);

    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( media_item_ != nil, @"Item not created" );
    
    
    __block UIImage *readedImage = nil;
    
    if ( media_item_ )
    {
    
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            
            SCDownloadMediaOptions *params = [ SCDownloadMediaOptions new ];
            params.width = 10.f;
            params.height = 10.f;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( UIImage* image, NSError* read_error_ )
            {
                readedImage = image;
                
                didFinishCallback_();
                
            };

            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadOperationForSCMediaPath: media_item_.path
                                                                   imageParams: params ];
            loader(nil, nil, doneHandler);
        
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //first item:
    GHAssertTrue( readedImage.size.height == 10.f , @"OK" );
    GHAssertTrue( readedImage.size.width == 10.f , @"OK" );

}

-(void)testCreateAndReadImageWithScale
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
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        loader (nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( media_item_ != nil, @"Item not created" );
    
    
    __block UIImage *readedImage = nil;
    
    if ( media_item_ )
    {
    
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            
            SCDownloadMediaOptions *params = [ SCDownloadMediaOptions new ];
            params.scale = 2.f;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( UIImage* image, NSError* read_error_ )
            {
                readedImage = image;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadOperationForSCMediaPath: media_item_.path
                                                                   imageParams: params ];
            loader(nil, nil, doneHandler);
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //first item:
    GHAssertTrue( readedImage.size.height == 114.f , @"OK" );
    GHAssertTrue( readedImage.size.width == 114.f , @"OK" );
    
}

-(void)testCreateAndReadImageAsThumbnail
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
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        loader (nil, nil, doneHandler);
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( media_item_ != nil, @"Item not created" );
    
    
    __block UIImage *readedImage = nil;
    
    if ( media_item_ )
    {
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            
            SCDownloadMediaOptions *params = [ SCDownloadMediaOptions new ];
            params.displayAsThumbnail = YES;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( UIImage* image, NSError* read_error_ )
            {
                readedImage = image;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadOperationForSCMediaPath: media_item_.path
                                                                   imageParams: params ];
            
            loader(nil, nil, doneHandler);
        };
        
        
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //first item:
    GHAssertTrue( readedImage.size.height == 150.f , @"OK" );
    GHAssertTrue( readedImage.size.width == 150.f , @"OK" );
    
}

-(void)testImageLoaderFromFieldUsesSourceOfItem
{
    SCApiSession* legacySession = nil;
    SCExtendedApiSession* apiContext = nil;
    
    __block SCItem * mediaItem = nil;
    __block UIImage* image     = nil;
    __block NSError* error     = nil;
    
    legacySession = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext = legacySession.extendedApiSession;
    apiContext.defaultDatabase = @"web";
    
    SCItemSourcePOD* itemSource = [ SCItemSourcePOD new ];
    {
        itemSource.database = @"master"                  ;
        itemSource.site     = apiContext.defaultSite    ;
        itemSource.language = apiContext.defaultLanguage;
    }
    
    static NSString* const IMAGE_FIELD_NAME = @"Image";
    static NSString* const TEXT_FIELD_NAME  = @"Text" ;
    
    //    static NSString* const IMAGE_FIELD_NAME = @"image";
    //    static NSString* const TEXT_FIELD_NAME = @"text";
    
    
    NSArray* fields =
    @[
      TEXT_FIELD_NAME ,
      IMAGE_FIELD_NAME
      ];
    SCReadItemsRequest* request =
    [ SCReadItemsRequest requestWithItemPath: @"/sitecore/content/FieldsTest/Mouse"
                                 fieldsNames: [ NSSet setWithArray: fields ] ];
    {
        request.database = @"master";
        request.site     = apiContext.defaultSite;
        request.language = apiContext.defaultLanguage;
    }
    
    void (^GetItemBlock)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCExtendedAsyncOp itemLoader = [ apiContext readItemsOperationWithRequest: request ];
        itemLoader( nil, nil, ^void( NSArray* blockItems, NSError* blockError )
       {
           mediaItem = [ blockItems lastObject ];
           error     = blockError;
           
           didFinishCallback_();
       } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: GetItemBlock
                                           selector: _cmd ];
    
    GHAssertNil   ( error    , @"error loading item" );
    GHAssertNotNil( mediaItem, @"error loading item" );
    
    /////////////////
    SCField* imageField = [ mediaItem fieldWithName: IMAGE_FIELD_NAME ];
    
    
    void (^GetImageBlock)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCExtendedAsyncOp imageLoader = [ imageField readFieldValueExtendedOperation ];
        imageLoader( nil, nil, ^void( UIImage* blockImage, NSError* blockError )
        {
            image = blockImage;
            error = blockError;
            didFinishCallback_();
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: GetImageBlock
                                           selector: _cmd ];
    
    GHAssertNil( error, @"unexpected error" );
    GHAssertNotNil( image, @"where is my image ???" );
}

@end