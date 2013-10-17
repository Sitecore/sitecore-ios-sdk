@interface ExtranetUserAuthTest : SCAsyncTestCase
@end


@implementation ExtranetUserAuthTest
{
    SCApiContext* _context;
}


-(void)setUp
{
    [ super setUp ];
    
    self->_context =
    [ [ SCApiContext alloc ] initWithHost: SCWebApiHostWithAuthRequest
                                    login: SCWebApiLogin
                                 password: SCWebApiPassword
                                  version: SCWebApiMaxSupportedVersion ];
}

- (void)tearDown
{
    self->_context = nil;
    [ super tearDown ];
}

-(void)testAuthRequestSucceedsForWebsite
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_context credentialsCheckerForSite: nil ];
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCAsyncOpResult onAuthCompleted = ^void( NSNull* blockResult, NSError* blockError )
        {
            result = blockResult;
            error  = blockError ;
            
            didFinishCallback_();
        };
        
        authOp( onAuthCompleted );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertNotNil( result, @"[auth failed] : nil result - %@|%@", [ error class ], [ error localizedDescription ] );
    GHAssertNil( error, @"[auth failed] : error received  - %@|%@", [ error class ], [ error localizedDescription ] );
    
    GHAssertTrue( [ result isKindOfClass: [ NSNull class ] ], @"unexpected result class" );
}

-(void)testAuthRequestFailsForShellSite
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_context credentialsCheckerForSite: SCSitecoreShellSite ];
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCAsyncOpResult onAuthCompleted = ^void( NSNull* blockResult, NSError* blockError )
        {
            result = blockResult;
            error  = blockError ;
            
            didFinishCallback_();
        };
        
        authOp( onAuthCompleted );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    // @adk - same behaviour for both anonymous access modes
    GHAssertNil( result, @"[auth failed] : unexpected result" );
    GHAssertNotNil( error, @"[auth failed] : error expected" );
    
    GHAssertTrue( [ error isMemberOfClass: [ SCResponseError class ] ], @"unexpected result class" );
    SCResponseError* castedError = (SCResponseError*)error;
    
    GHAssertTrue( 401 == castedError.statusCode, @"status code mismatch" );
    GHAssertEqualObjects( castedError.message, @"Access to site is not granted.", @"error message mismatch" );
}

@end

