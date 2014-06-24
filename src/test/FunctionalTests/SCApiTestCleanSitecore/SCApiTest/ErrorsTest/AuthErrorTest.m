#import "SCAsyncTestCase.h"

@interface AuthErrorTest : SCAsyncTestCase
@end

@implementation AuthErrorTest

-(void)testReadItemWithAuthWithWrongLoginPwd
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                                 login: @"aaa"
                                                              password: @"bbb"
                                                               version: SCWebApiV1 ];
                apiContext_ = strongContext_;

                SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
                request_.site = SCSitecoreShellSite;
                request_.requestType = SCReadItemRequestItemPath;
                request_.request = SCHidedPath;
                [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( SCItem* result_item_, NSError* error_ )
                                                                        {
                                                                            item_error_ = (SCApiError*)error_;
                                                                            item_ = result_item_;
                                                                            didFinishCallback_();
                                                                        } );
            };
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                                   selector: _cmd ];
        }
        
        GHAssertTrue( apiContext_ == nil, @"OK" );
        GHAssertTrue( item_ == nil, @"OK" );
        GHAssertTrue( item_error_ != nil, @"OK" );
        
        
        GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");
        GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
    
}

-(void)testReadItemWithAuthWithEmptyLoginPwd
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_        = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                             login: @""
                                                          password: @"" ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.site = SCSitecoreShellSite;
            request_.requestType = SCReadItemRequestItemPath;
            request_.request = SCHidedPath;
            [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( SCItem* result_item_, NSError* error_ )
            {
                item_error_ = (SCApiError*)error_;
                item_ = result_item_;
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    

    GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");
    GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
}

-(void)testReadItemWithAuthWithInvalidLogin
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                                 login: @"yuQ^:`~%" 
                                                              password: @"" ];
                apiContext_ = strongContext_;
                
                SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
                request_.site = SCSitecoreShellSite;
                request_.requestType = SCReadItemRequestItemPath;
                request_.request = SCHidedPath;
                [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    
    GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
    GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");

}

-(void)testReadItemWithAuthWithInvalidPwd
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                             login: SCWebApiAdminLogin
                                                          password: @"yuQ^:`~%  " ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.site = SCSitecoreShellSite;
            request_.requestType = SCReadItemRequestItemPath;
            request_.request = SCHidedPath;
            [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( SCItem* result_item_, NSError* error_ )
            {
                item_error_ = (SCApiError*)error_;
                item_ = result_item_;
                didFinishCallback_();
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    
    GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
    GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");

}

-(void)testReadItemWithAuthWithWrongPwd
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                             login: @"test" 
                                                          password: @"_test" ];
            apiContext_ = strongContext_;
            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.site = SCSitecoreShellSite;
            request_.requestType = SCReadItemRequestItemPath;
            request_.request = SCHidedPath;
            [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( SCItem* result_item_, NSError* error_ )
                                                                    {
                                                                        item_error_ = (SCApiError*)error_;
                                                                        item_ = result_item_;
                                                                        didFinishCallback_();
                                                                    } );
        }
    };
        
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    
    GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
    GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");
}

-(void)testReadItemFromShellAsAnonymous
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName ];
                apiContext_ = strongContext_;

                SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
                request_.site = SCSitecoreShellSite;
                request_.requestType = SCReadItemRequestItemPath;
                request_.request = SCHidedPath;
                [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( SCItem* result_item_, NSError* error_ )
                                                                        {
                                                                            item_error_ = (SCApiError*)error_;
                                                                            item_ = result_item_;
                                                                            didFinishCallback_();
                                                                        } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    
    GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
    GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");
}

-(void)testReadItemWithAuthWithRightLoginPwd_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                NSString* path_ = SCHomePath;
                [ apiContext_ readItemOperationForItemPath: path_ ]( ^( SCItem* result_item_, NSError* error_ )
                 {
                     item_error_ = (SCApiError*)error_;
                     item_ = result_item_;
                     didFinishCallback_();
                 } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( item_error_ == nil, @"OK" );
}

@end