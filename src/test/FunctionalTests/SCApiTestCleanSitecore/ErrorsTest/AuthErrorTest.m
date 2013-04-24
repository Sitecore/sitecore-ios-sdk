#import "SCAsyncTestCase.h"

@interface AuthErrorTest : SCAsyncTestCase
@end

@implementation AuthErrorTest

-(void)testReadItemWithAuthWithWrongLoginPwd
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCError* item_error_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: @"aaa" 
                                                password: @"bbb" ];

            NSString* path_ = @"/sitecore/content/Nicam/My_Nicam";
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
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: @"" 
                                                password: @"" ];

            NSString* path_ = @"/sitecore/content/Nicam/My_Nicam";
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
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: @"yuQ^:`~%" 
                                                password: @"" ];
            
            NSString* path_ = @"/sitecore/content/Nicam/My_Nicam";
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
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: @"test" 
                                                password: @"yuQ^:`~%  " ];
            
            NSString* path_ = @"/sitecore/content/Nicam/My_Nicam";
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

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: @"test" 
                                                password: @"_test" ];

            NSString* path_ = @"/sitecore/content/Nicam/My_Nicam";
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

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiAdminLogin 
                                                password: SCWebApiAdminPassword ];

            NSString* path_ = @"/sitecore/content/Nicam/My_Nicam";
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
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( item_error_ == nil, @"OK" );
}

@end