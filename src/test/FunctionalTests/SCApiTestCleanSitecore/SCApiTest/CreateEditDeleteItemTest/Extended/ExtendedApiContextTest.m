#import "SCAsyncTestCase.h"

@interface ExtendedApiSessionTest : SCAsyncTestCase
@end

@implementation ExtendedApiSessionTest

-(void)testCreateItem
{
    __block SCApiSession* apiContext_;
    __block SCItem* media_item_ = nil;
    apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                          login: SCWebApiAdminLogin
                                                       password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];
        
        request_.fileName      = @"large_image.jpg";
        request_.itemName      = @"TestMediaItem";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"image/jpg";
        request_.folder        = SCCreateMediaFolder;
        request_.site = @"/sitecore/shell";
        
        SCCancelAsyncOperationHandler cancelCallback = ^void( BOOL isActionTerminated )
        {
            NSLog(@"--=== CANCEL");
            didFinishCallback_();
        };
        SCDidFinishAsyncOperationHandler doneCallback = ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            didFinishCallback_();
        };
        
        SCAsyncOperationProgressHandler progressCallback = ^(id<SCUploadProgress> progressInfo)
        {
            if ([progressInfo isKindOfClass:[JFFNetworkUploadProgressCallback class]])
                NSLog(@"-=== progress: %.2f%%", (progressInfo.progress.floatValue * 100));
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession uploadMediaOperationWithRequest: request_ ];
        
        SCCancelAsyncOperation cancelOperation = loader ( progressCallback, cancelCallback, doneCallback );

        NSLog(@"cancel operation %@", cancelOperation);//remove unused cancelOperation warning 
        //cancelOperation( YES );
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( media_item_ != nil, @"Item not created" );
}

@end
