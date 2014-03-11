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
    XCTAssertNotNil( self->_apiSession   , @"session initialization error" );
    
    NSString* expectedDefaultPath = @"/SITECORE/MEDIA LIBRARY";
    
    XCTAssertEqualObjects( expectedDefaultPath, [ SCExtendedApiSession defaultMediaLibraryPath ], @"default path mismatch" );
    XCTAssertEqualObjects( expectedDefaultPath, [ SCApiSession         defaultMediaLibraryPath ], @"default path mismatch" );
    
    XCTAssertEqualObjects( expectedDefaultPath, self->_apiSession   .mediaLibraryPath, @"default media path mismatch" );
    XCTAssertEqualObjects( expectedDefaultPath, self->_legacySession.mediaLibraryPath, @"default media path mismatch" );
}

-(void)testMediaLibraryPathIsSetForBothSessions_FromLegacySession
{
    NSString* expectedDefaultPath = @"/SITECORE/MEDIA LIBRARY";
    NSString* expectedNewPath     = @"/SITECORE/CONTENT/XYZ/MEDIA LIBRARY";
    
    self->_legacySession.mediaLibraryPath = expectedNewPath;
    
    XCTAssertEqualObjects( expectedNewPath, self->_apiSession   .mediaLibraryPath, @"default media path mismatch" );
    XCTAssertEqualObjects( expectedNewPath, self->_legacySession.mediaLibraryPath, @"default media path mismatch" );

    XCTAssertEqualObjects( expectedDefaultPath, [ SCExtendedApiSession defaultMediaLibraryPath ], @"default path mismatch" );
    XCTAssertEqualObjects( expectedDefaultPath, [ SCApiSession         defaultMediaLibraryPath ], @"default path mismatch" );
}

-(void)testMediaLibraryPathIsSetForBothSessions_FromExtendedSession
{
    NSString* expectedDefaultPath = @"/SITECORE/MEDIA LIBRARY";
    NSString* expectedNewPath     = @"/SITECORE/CONTENT/XYZ/MEDIA LIBRARY";
    
    self->_apiSession.mediaLibraryPath = expectedNewPath;
    
    XCTAssertEqualObjects( expectedNewPath, self->_apiSession   .mediaLibraryPath, @"default media path mismatch" );
    XCTAssertEqualObjects( expectedNewPath, self->_legacySession.mediaLibraryPath, @"default media path mismatch" );
    
    XCTAssertEqualObjects( expectedDefaultPath, [ SCExtendedApiSession defaultMediaLibraryPath ], @"default path mismatch" );
    XCTAssertEqualObjects( expectedDefaultPath, [ SCApiSession         defaultMediaLibraryPath ], @"default path mismatch" );
}

-(void)testMediaLibraryPathIsStoredInUpperCase_FromLegacySession
{
    NSString* expectedDefaultPath = @"/SITECORE/MEDIA LIBRARY";
    
    NSString* newPath             = @"/sitecore/Content/xYZ/Media Library";
    NSString* expectedNewPath     = @"/SITECORE/CONTENT/XYZ/MEDIA LIBRARY";
    
    self->_legacySession.mediaLibraryPath = newPath;
    
    XCTAssertEqualObjects( expectedNewPath, self->_apiSession   .mediaLibraryPath, @"default media path mismatch" );
    XCTAssertEqualObjects( expectedNewPath, self->_legacySession.mediaLibraryPath, @"default media path mismatch" );
    
    XCTAssertEqualObjects( expectedDefaultPath, [ SCExtendedApiSession defaultMediaLibraryPath ], @"default path mismatch" );
    XCTAssertEqualObjects( expectedDefaultPath, [ SCApiSession         defaultMediaLibraryPath ], @"default path mismatch" );
    
}

-(void)testMediaPathIsAssignedOnce_FromExtendedSession
{
    NSString* newPath             = @"/sitecore/Content/abc/Media";
    NSString* expectedNewPath     = @"/SITECORE/CONTENT/XYZ/MEDIA LIBRARY";
    
    self->_apiSession.mediaLibraryPath = expectedNewPath;
    XCTAssertThrows( self->_apiSession.mediaLibraryPath = newPath, @"assert expected" );
}

-(void)testMediaPathIsAssignedOnce_FromLegacySession
{
    NSString* newPath             = @"/sitecore/Content/abc/Media";
    NSString* expectedNewPath     = @"/SITECORE/CONTENT/XYZ/MEDIA LIBRARY";
    
    self->_legacySession.mediaLibraryPath = expectedNewPath;
    XCTAssertThrows( self->_legacySession.mediaLibraryPath = newPath, @"assert expected" );
}

-(void)testMediaPathIsAssignedOnce_Mix1
{
    NSString* newPath             = @"/sitecore/Content/abc/Media";
    NSString* expectedNewPath     = @"/SITECORE/CONTENT/XYZ/MEDIA LIBRARY";
    
    self->_apiSession.mediaLibraryPath = expectedNewPath;
    XCTAssertThrows( self->_legacySession.mediaLibraryPath = newPath, @"assert expected" );
}

-(void)testMediaPathIsAssignedOnce_Mix2
{
    NSString* newPath             = @"/sitecore/Content/abc/Media";
    NSString* expectedNewPath     = @"/SITECORE/CONTENT/XYZ/MEDIA LIBRARY";
    
    self->_legacySession.mediaLibraryPath = expectedNewPath;
    XCTAssertThrows( self->_apiSession.mediaLibraryPath = newPath, @"assert expected" );
}


@end
