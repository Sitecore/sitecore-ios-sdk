#import "SCAsyncTestCase.h"

@interface InvalidRequestErrorTest : SCAsyncTestCase
@end

@implementation InvalidRequestErrorTest

-(void)testInvalidRequestTypeItemIDWithPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCApiError* error_ = nil;

    NSString* path_ = @"/sitecore/content/home";

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;

            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: path_
                                                                          fieldsNames: [ NSSet new ] ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* resultItems_, NSError* result_error_ )
            {
                items_ = resultItems_;
                error_ = (SCApiError*)result_error_;
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( items_ == nil, @"OK" );
    GHAssertTrue( error_ != nil, @"OK" );

    GHAssertTrue( [ error_ isKindOfClass: [ SCInvalidItemIdError class ] ] == TRUE, @"OK" );
}


-(void)testInvalidRequestTypeItemPathWithQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCApiError* error_ = nil;

    NSString* path_ = @"/sitecore/content/*[@@key='home']";

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword ];
            apiContext_ = strongContext_;
            apiContext_.defaultSite = @"/sitecore/shell";
            
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                            fieldsNames: [ NSSet new ] ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* resultItems_, NSError* resultError_ )
            {
                items_ = resultItems_;
                error_ = (SCApiError*)resultError_;
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( items_ == nil, @"OK" );
    GHAssertTrue( error_ != nil, @"OK" );
    GHAssertTrue( [ error_ isKindOfClass: [ SCNetworkError class ] ] == TRUE, @"OK" );
}

-(void)testInvalidRequestTypeItemPathWithId
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCApiError* error_ = nil;

    NSString* path_ = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}";

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                            fieldsNames: [ NSSet new ] ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* resultItems_
                                                                , NSError* resultError_ )
            {
                items_ = resultItems_;
                error_ = (SCApiError*)resultError_;
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( items_ == nil, @"OK" );
    GHAssertTrue( error_ != nil, @"OK" );
    GHAssertTrue( [ error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}


-(void)testInvalidRequestTypeItemQueryWithId
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCApiError* error_ = nil;

    NSString* path_ = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}";

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword ];
            apiContext_ = strongContext_;
            apiContext_.defaultSite = @"/sitecore/shell";
            
            
            SCItemsReaderRequest* request_ = [SCItemsReaderRequest new ];
            request_.request = path_;
            request_.fieldNames = [ NSSet new ];
            request_.requestType = SCItemReaderRequestQuery;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* resultItems_, NSError* resultError_ )
            {
                items_ = resultItems_;
                error_ = (SCApiError*)resultError_;
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    GHAssertTrue( error_ == nil, @"OK" );
}

-(void)testInvalidRequestTypeItemIdWithPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCApiError* error_ = nil;
    
    NSString* path_ = @"/sitecore/content/home";
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword ];
            apiContext_ = strongContext_;
            apiContext_.defaultSite = @"/sitecore/shell";
            
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: path_
                                                                          fieldsNames: [ NSSet new ] ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* resultItems_, NSError* resultError_ )
            {
                items_ = resultItems_;
                error_ = (SCApiError*)resultError_;
                didFinishCallback_();
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( items_ == nil, @"OK" );
    GHAssertTrue( error_ != nil, @"OK" );
    GHAssertTrue( [ error_ isKindOfClass: [ SCInvalidItemIdError class ] ] == TRUE, @"OK" );
}

@end
