@interface ExtranetUserAuthTest : SCAsyncTestCase
@end


@implementation ExtranetUserAuthTest
{
    SCApiSession* _context;
}


-(void)setUp
{
    [ super setUp ];
    
    self->_context =
    [ [ SCApiSession alloc ] initWithHost: SCWebApiHostWithAuthRequest
                                    login: SCWebApiNoAccessLogin
                                 password: SCWebApiNoAccessPassword
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
    SCAsyncOp authOp = [ self->_context checkCredentialsOperationForSite: nil ];
    
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
    SCAsyncOp authOp = [ self->_context checkCredentialsOperationForSite: SCSitecoreShellSite ];
    
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
    
    //@igk [new webApi] checkCredentials not depends on site parameter
    // @adk - same behaviour for both anonymous access modes
    GHAssertNotNil( result, @"[auth failed] : unexpected result" );
    GHAssertNil( error, @"[auth failed] : error expected" );
    
}

@end

