#import "SCAsyncTestCase.h"

@interface ReadHTMLRenderingTest : SCAsyncTestCase
@end

@implementation ReadHTMLRenderingTest


-(void)testReadHTMLRendering
{
    __block SCApiContext* apiContext_;
    __block NSString* rendering_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    //apiContext_.defaultDatabase = @"web";

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCHTMLReaderRequest* request_ = [ SCHTMLReaderRequest new ];

        request_.renderingId  = @"{5FAC342C-AC30-4F74-8B61-6C38B527CF32}";
        request_.sourceId = @"{7272BE8E-8C4C-4F2A-8EC8-F04F512B04CB}";
        request_.language = @"da";
        request_.database = @"master";
        
        [ apiContext_ renderingHTMLReaderWithRequest: request_ ]( ^( NSString* render_, NSError* error_ )
        {
            rendering_ = render_;
            didFinishCallback_();
        } );

    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( rendering_ != nil, @"rendering should not be nil" );
    GHAssertTrue( [ rendering_ containsString: @"Master Language Item 3 Danish" ], @"OK" );
    
}

-(void)testReadHTMLRenderingWithDanishLanguage
{
    __block SCApiContext* apiContext_;
    __block NSString* rendering_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCHTMLReaderRequest* request_ = [ SCHTMLReaderRequest new ];
        
        request_.renderingId  = @"{493B3A83-0FA7-4484-8FC9-4680991CF743}";
        request_.sourceId = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}";
        request_.language = @"en";
        request_.database = @"web";
        
        [ apiContext_ renderingHTMLReaderWithRequest: request_ ]( ^( NSString* render_, NSError* error_ )
                                                                 {
                                                                     rendering_ = render_;
                                                                     didFinishCallback_();
                                                                 } );
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( rendering_ != nil, @"rendering should not be nil" );
    GHAssertTrue( [ rendering_ containsString: @"<div>Welcome to Sitecore!</div>" ], @"OK" );
    
}

-(void)testReadHTMLRenderingWithDefaultDatabaseLanguage
{
    __block SCApiContext* apiContext_;
    __block NSString* rendering_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCHTMLReaderRequest* request_ = [ SCHTMLReaderRequest new ];
        
        request_.renderingId  = @"{0B301A61-1FD4-4009-8117-D112025B68C1}";
        request_.sourceId = @"{D6BC2E09-964E-4E48-90B2-6E09FEDC3286}";

        [ apiContext_ renderingHTMLReaderWithRequest: request_ ]( ^( NSString* render_, NSError* error_ )
                                                                 {
                                                                     rendering_ = render_;
                                                                     didFinishCallback_();
                                                                 } );
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( rendering_ != nil, @"rendering should not be nil" );
}

-(void)testReadHTMLRenderingWithWrongIDs
{
    __block SCApiContext* apiContext_;
    __block NSString* rendering_ = nil;
    __block NSError* error_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCHTMLReaderRequest* request_ = [ SCHTMLReaderRequest new ];
        
        // @adk : GUID is validated on the client side
        // Item Web API call is not invoked in case of error
        request_.renderingId  = @"{someID}";
        request_.sourceId = @"{someId}";
        
        [ apiContext_ renderingHTMLReaderWithRequest: request_ ]( ^( NSString* render, NSError* error )
         {
             rendering_ = render;
             error_ = error;
             didFinishCallback_();
         } );
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( rendering_ == nil, @"rendering should be nil" );
    GHAssertTrue([ error_ isMemberOfClass: [ SCInvalidItemIdError class ] ] == YES, @"wrong error format");
    SCInvalidItemIdError* err_ = (SCInvalidItemIdError*)error_;
    GHAssertTrue( err_ != nil, @"error should appears" );

}

-(void)testReadHTMLRenderingWithNotExistentRenderingId
{
    __block SCApiContext* apiContext_;
    __block NSString* rendering_ = nil;
    __block NSError* error_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCHTMLReaderRequest* request_ = [ SCHTMLReaderRequest new ];
        
        // @adk - valid guids are sent to the server.
        // Only HTTP errors should be returned by this action
        request_.renderingId  = @"{493B3A83-0FFF-4484-8FC9-4680991CF743}";
        request_.sourceId = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}";

        
        [ apiContext_ renderingHTMLReaderWithRequest: request_ ]( ^( NSString* render, NSError* error )
        {
            rendering_ = render;
            error_ = error;
            didFinishCallback_();
        } );
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( rendering_ == nil, @"rendering should be nil" );
    GHAssertTrue( error_ != nil, @"error should appear" );
    NSLog( @"error: %@", [ error_ class ] );
    GHAssertTrue([ error_ isMemberOfClass: [ SCNetworkError class ] ] == YES, @"wrong error format");
    
    SCNetworkError* castedError = (SCNetworkError*)error_;
    GHAssertTrue( [[ castedError underlyingError ] isMemberOfClass: [ JHttpError class ] ], @"underlying error class mismatch" );
    
    JHttpError* httpError = (JHttpError*)[ castedError underlyingError ];
    GHAssertTrue( 400 == httpError.code, @"http error code mismatch" );
}


-(void)testReadHTMLRenderingWithoutSite
{
    __block SCApiContext* apiContext_;
    __block NSString* rendering_ = nil;
    __block NSError* error = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = nil;
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCHTMLReaderRequest* request_ = [ SCHTMLReaderRequest new ];
        
        request_.renderingId  = @"{0B301A61-1FD4-4009-8117-D112025B68C1}";
        request_.sourceId = @"{D6BC2E09-964E-4E48-90B2-6E09FEDC3286}";
        
        [ apiContext_ renderingHTMLReaderWithRequest: request_ ]( ^( NSString* render_, NSError* blockError_ )
         {
             error = blockError_;
             rendering_ = render_;
             didFinishCallback_();
         } );
        
    };
    

    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];

    if ( !IS_ANONYMOUS_ACCESS_ENABLED )
    {
        GHAssertNil( rendering_, @"rendering should be nil" );
        GHAssertTrue( [ error isMemberOfClass: [ SCNetworkError class] ], @"error class mismatch" );
        
        SCNetworkError* castedError = (SCNetworkError*)error;
        GHAssertTrue( [ [castedError underlyingError] isMemberOfClass: [ JHttpError class] ], @"underlying error class mismatch" );
        JHttpError* httpError = (JHttpError*)[ castedError underlyingError ];

        GHAssertTrue( 403 == httpError.code, @"error code mismatch" );
        
    }
    else
    {
        GHAssertNotNil( rendering_, @"rendering must be returned according to " );
    }
}

@end