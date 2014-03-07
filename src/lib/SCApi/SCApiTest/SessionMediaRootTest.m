#import <XCTest/XCTest.h>

#import "SCApiSession+Init.h"

@interface SessionMediaRootTest : XCTestCase
@end

@implementation SessionMediaRootTest
{
@private
    SCApiSession        * _legacySession;
    SCExtendedApiSession* _apiSession   ;
}


-(void)setUp
{
    [ super setUp ];

    self->_legacySession = [ [ SCApiSession alloc] initWithHost: @"localhost" ];
    self->_apiSession = self->_legacySession.extendedApiSession;
}

-(void)tearDown
{
    self->_legacySession = nil;
    self->_apiSession    = nil;

    [ super tearDown ];
}

-(void)testDefaultMediaLibraryPath
{
    XCTAssertNotNil( self->_legacySession, @"session initialization error" );
    XCTAssertNotNil( self->_apiSession, @"session initialization error" );
    
    XCTAssertEqualObjects( @"/SITECORE/MEDIA LIBRARY", self->_apiSession.mediaLibraryPath, @"default media path mismatch" );
    XCTAssertEqualObjects( @"/SITECORE/MEDIA LIBRARY", self->_legacySession.mediaLibraryPath, @"default media path mismatch" );
}

@end
