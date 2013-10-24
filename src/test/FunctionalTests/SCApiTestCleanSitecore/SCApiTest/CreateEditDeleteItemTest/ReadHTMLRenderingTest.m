#import "SCAsyncTestCase.h"

@interface ReadHTMLRenderingTest : SCAsyncTestCase
@end

@implementation ReadHTMLRenderingTest


-(void)testReadHTMLRendering
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
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCHTMLReaderRequest* request_ = [ SCHTMLReaderRequest new ];
        
        request_.renderingId  = @"{someID}";
        request_.sourceId = @"{someId}";
        
        [ apiContext_ renderingHTMLReaderWithRequest: request_ ]( ^( NSString* render_, NSError* error_ )
                                                                 {
                                                                     rendering_ = render_;
                                                                     didFinishCallback_();
                                                                 } );
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( rendering_ == nil, @"rendering should be nil" );
}

-(void)testReadHTMLRenderingWithoutSite
{
    __block SCApiContext* apiContext_;
    __block NSString* rendering_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = nil;
    
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
    
    GHAssertTrue( rendering_ == nil, @"rendering should be nil" );
}

@end