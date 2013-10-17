#import "SCAsyncTestCase.h"

@interface UploadMediaWithoutAccessTest : SCAsyncTestCase
@end

@implementation UploadMediaWithoutAccessTest

-(void)testCreateMediaItemInWeb
{
    __block __weak SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* createError = nil;
    
    @autoreleasepool
    {
        SCApiContext* strongContext = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
        apiContext_ = strongContext;
        apiContext_.defaultDatabase = @"web";

        void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];

            request_.fileName      = @"auto tests.png";
            request_.itemName      = @"TestMediaItemNoRights";
            request_.itemTemplate  = @"System/Media/Unversioned/Image";
            request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
            request_.fieldNames    = [ NSSet new ];
            request_.contentType   = @"image/png";
            request_.folder        = SCCreateMediaFolder;

            [ apiContext_ mediaItemCreatorWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
            {
                createError = error_;
                media_item_ = item_;
                didFinishCallback_();
            } );

        };
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemPath: media_item_.path ];
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
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
        
        [ [ apiContext_.extendedApiContext itemsCache ] cleanupAll ];
    }
    
    if ( !IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertNil( apiContext_, @"ApiContext must not exist anymore" );
        GHAssertNil( media_item_, @"media item must not exist anymore" );
    }

}

-(void)testGetMediaWithoutAccess
{
    __block __weak SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    __block NSError* error_ = nil;
    
    @autoreleasepool
    {
        SCApiContext* strongContext = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                                      login: SCWebApiNoReadAccessLogin
                                                                   password: SCWebApiNoReadAccessPassword
                                                                    version: SCWebApiV1 ];
        apiContext_ = strongContext;
        apiContext_.defaultDatabase = @"web";
        
        
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/Media Library/Images/test image" ];
            item_request_.fieldNames = nil;
            item_request_.flags = SCItemReaderRequestReadFieldsValues | SCItemReaderRequestIngnoreCache;
            [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
            {
                if ( read_error_ )
                {
                    error_ = read_error_;
                    didFinishCallback_();
                }
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
        
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
        
        [ [ apiContext_.extendedApiContext itemsCache ] cleanupAll ];
    }

        GHAssertNil( apiContext_, @"ApiContext must not exist anymore" );
        GHAssertNil( media_item_, @"media item must not exist anymore" );
    
}


@end