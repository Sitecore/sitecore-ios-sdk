#import "SCAsyncTestCase.h"

@interface AuthErrorTestExtended : SCAsyncTestCase
@end

@implementation AuthErrorTestExtended

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
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

                NSString* path_ = SCHidedPath;
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession itemReaderForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
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
            strongContext_.defaultDatabase = @"web";
            apiContext_ = strongContext_;
            SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            NSString* path_ = SCHidedPath;
            SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
            {
                item_error_ = (SCApiError*)error_;
                item_ = result_item_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession itemReaderForItemPath: path_
                                                                                   itemSource: contextSource ];
            loader(nil, nil, doneHandler);
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
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
                
                NSString* path_ = SCHidedPath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession itemReaderForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
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
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
                
                NSString* path_ = SCHidedPath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession itemReaderForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
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
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

                NSString* path_ = SCHidedPath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession itemReaderForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
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

-(void)testReadItemWithAuthWithoutAuth
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
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

                NSString* path_ = SCHomePath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession itemReaderForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
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
        
        GHAssertTrue( [ item_error_ isMemberOfClass: [ SCResponseError class ] ] , @"error class mismatch" );
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
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword ];
                apiContext_ = strongContext_;
                apiContext_.defaultSite = @"/sitecore/shell";
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
                
                NSString* path_ = SCHomePath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession itemReaderForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
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