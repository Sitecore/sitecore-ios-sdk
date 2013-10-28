@interface BadCredentialsAuthTest : SCAsyncTestCase
@end

@implementation BadCredentialsAuthTest
{
    SCApiContext* _extranetUserContext;
    SCApiContext* _extranetAdminContext;
    
    SCApiContext* _shellUserContext;
    SCApiContext* _shellAdminContext;
}


-(void)setUp
{
    [ super setUp ];
    
    self->_shellUserContext =
    [ [ SCApiContext alloc ] initWithHost: SCWebApiHostWithAuthRequest
                                    login: SCWebApiCreatorLogin
                                 password: @"xyz"
                                  version: SCWebApiMaxSupportedVersion ];

    self->_shellAdminContext =
    [ [ SCApiContext alloc ] initWithHost: SCWebApiHostWithAuthRequest
                                    login: SCWebApiAdminLogin
                                 password: @"xyz"
                                  version: SCWebApiMaxSupportedVersion ];

    
    self->_extranetAdminContext =
    [ [ SCApiContext alloc ] initWithHost: SCWebApiHostWithAuthRequest
                                    login: SCExtranetAdminLogin
                                 password: @"xyz"
                                  version: SCWebApiMaxSupportedVersion ];
    
    self->_extranetUserContext =
    [ [ SCApiContext alloc ] initWithHost: SCWebApiHostWithAuthRequest
                                    login: SCWebApiNoAccessLogin
                                 password: @"xyz"
                                  version: SCWebApiMaxSupportedVersion ];
}

-(void)tearDown
{
    self->_extranetUserContext  = nil;
    self->_extranetAdminContext = nil;
    self->_shellUserContext     = nil;
    self->_shellAdminContext    = nil;
    
    [ super tearDown ];
}

-(void)testAuthRequestFailsForWebsite_ExtranetUser
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_extranetUserContext credentialsCheckerForSite: nil ];
    
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

-(void)testAuthRequestFailsForShellSite_ExtranetUser
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_extranetUserContext credentialsCheckerForSite: SCSitecoreShellSite ];
    
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

-(void)testAuthRequestFailsForWebsite_ExtranetAdmin
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_extranetAdminContext credentialsCheckerForSite: nil ];
    
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

-(void)testAuthRequestFailsForShellSite_ExtranetAdmin
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_extranetAdminContext credentialsCheckerForSite: SCSitecoreShellSite ];
    
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

-(void)testAuthRequestFailsForWebsite_ShellUser
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_shellUserContext credentialsCheckerForSite: nil ];
    
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

-(void)testAuthRequestFailsForShellSite_ShellUser
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_shellUserContext credentialsCheckerForSite: SCSitecoreShellSite ];
    
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

-(void)testAuthRequestFailsForWebsite_ShellAdmin
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_shellAdminContext credentialsCheckerForSite: nil ];
    
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

-(void)testAuthRequestFailsForShellSite_ShellAdmin
{
    __block NSNull* result = nil;
    __block NSError* error = nil;
    SCAsyncOp authOp = [ self->_shellAdminContext credentialsCheckerForSite: SCSitecoreShellSite ];
    
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
