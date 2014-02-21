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

                NSString* path_ = SCHidedPath;
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
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
    }
    else
    {
        GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
    }
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

            NSString* path_ = SCHidedPath;
            [ apiContext_ readItemOperationForItemPath: path_ ]( ^( SCItem* result_item_, NSError* error_ )
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
    

    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( [ item_error_ isMemberOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
    }
    else
    {
        GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");
        GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
    }
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
                
                NSString* path_ = SCHidedPath;
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
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    
    
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
    }
    else
    {
        GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
        GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");
    }
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
                                                             login: @"test" 
                                                          password: @"yuQ^:`~%  " ];
            apiContext_ = strongContext_;
            
            NSString* path_ = SCHidedPath;
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
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
    }
    else
    {
        GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
        GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");        
    }
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

            NSString* path_ = SCHidedPath;
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
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
    }
    else
    {
        GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] == TRUE, @"OK" );
    }
}

-(void)testReadItemWithoutAuth
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
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( item_ != nil, @"OK" );
        GHAssertTrue( item_error_ == nil, @"OK" );
    }
    else
    {
        GHAssertNil( apiContext_, @"no context expected" );
        GHAssertNil( item_, @"no item expected" );
        GHAssertTrue( item_error_ != nil, @"OK" );
        GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] , @"error class mismatch" );
        
        GHAssertEqualObjects(item_error_.localizedDescription, @"Access to site is not granted.", @"Wrong error description");
        
        SCResponseError* castedError = (SCResponseError*)item_error_;
        GHAssertTrue( castedError.statusCode == 401, @"status code mismatch" );
    }
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