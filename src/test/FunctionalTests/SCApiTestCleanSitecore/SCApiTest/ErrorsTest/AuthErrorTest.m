#import "SCAsyncTestCase.h"

@interface AuthErrorTest : SCAsyncTestCase
@end

@implementation AuthErrorTest

-(void)testReadItemWithAuthWithWrongLoginPwd
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: @"aaa"
                                                          password: @"bbb" ];
            apiContext_ = strongContext_;

            NSString* path_ = SCHidedPath;
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( SCItem* result_item_, NSError* error_ )
            {
                item_error_ = (SCError*)error_;
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
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
}

-(void)testReadItemWithAuthWithEmptyLoginPwd
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_        = nil;
    __block SCError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                             login: @""
                                                          password: @"" ];
            apiContext_ = strongContext_;

            NSString* path_ = SCHidedPath;
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( SCItem* result_item_, NSError* error_ )
            {
                item_error_ = (SCError*)error_;
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
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
}

-(void)testReadItemWithAuthWithInvalidLogin
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                             login: @"yuQ^:`~%" 
                                                          password: @"" ];
            apiContext_ = strongContext_;
            
            NSString* path_ = SCHidedPath;
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( SCItem* result_item_, NSError* error_ )
                                                         {
                                                             item_error_ = (SCError*)error_;
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
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
}

-(void)testReadItemWithAuthWithInvalidPwd
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                             login: @"test" 
                                                          password: @"yuQ^:`~%  " ];
            apiContext_ = strongContext_;
            
            NSString* path_ = SCHidedPath;
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( SCItem* result_item_, NSError* error_ )
                                                         {
                                                             item_error_ = (SCError*)error_;
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
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
}

-(void)testReadItemWithAuthWithWrongPwd
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                             login: @"test" 
                                                          password: @"_test" ];
            apiContext_ = strongContext_;

            NSString* path_ = SCHidedPath;
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( SCItem* result_item_, NSError* error_ )
            {
                item_error_ = (SCError*)error_;
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
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );
}

-(void)testReadItemWithAuthWithRightLoginPwd
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword ];
                apiContext_ = strongContext_;

                NSString* path_ = SCHidedPath;
                [ apiContext_ itemReaderForItemPath: path_ ]( ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCError*)error_;
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