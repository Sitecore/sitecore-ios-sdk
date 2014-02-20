@interface BadCredentialsAuthTest : SCAsyncTestCase
@end

@implementation BadCredentialsAuthTest
{
    SCApiSession* _extranetUserContext;
    SCApiSession* _extranetAdminContext;
    
    SCApiSession* _shellUserContext;
    SCApiSession* _shellAdminContext;
}


-(void)setUp
{
    [ super setUp ];
    
    self->_shellUserContext =
    [ [ SCApiSession alloc ] initWithHost: SCWebApiHostWithAuthRequest
                                    login: SCWebApiCreatorLogin
                                 password: @"xyz"
                                  version: SCWebApiMaxSupportedVersion ];

    self->_shellAdminContext =
    [ [ SCApiSession alloc ] initWithHost: SCWebApiHostWithAuthRequest
                                    login: SCWebApiAdminLogin
                                 password: @"xyz"
                                  version: SCWebApiMaxSupportedVersion ];

    
    self->_extranetAdminContext =
    [ [ SCApiSession alloc ] initWithHost: SCWebApiHostWithAuthRequest
                                    login: SCExtranetAdminLogin
                                 password: @"xyz"
                                  version: SCWebApiMaxSupportedVersion ];
    
    self->_extranetUserContext =
    [ [ SCApiSession alloc ] initWithHost: SCWebApiHostWithAuthRequest
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
    SCAsyncOp authOp = [ self->_extranetUserContext checkCredentialsOperationForSite: nil ];
    
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
    SCAsyncOp authOp = [ self->_extranetUserContext checkCredentialsOperationForSite: SCSitecoreShellSite ];
    
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
    SCAsyncOp authOp = [ self->_extranetAdminContext checkCredentialsOperationForSite: nil ];
    
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
    SCAsyncOp authOp = [ self->_extranetAdminContext checkCredentialsOperationForSite: SCSitecoreShellSite ];
    
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
    SCAsyncOp authOp = [ self->_shellUserContext checkCredentialsOperationForSite: nil ];
    
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
    SCAsyncOp authOp = [ self->_shellUserContext checkCredentialsOperationForSite: SCSitecoreShellSite ];
    
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
    SCAsyncOp authOp = [ self->_shellAdminContext checkCredentialsOperationForSite: nil ];
    
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
    SCAsyncOp authOp = [ self->_shellAdminContext checkCredentialsOperationForSite: SCSitecoreShellSite ];
    
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
