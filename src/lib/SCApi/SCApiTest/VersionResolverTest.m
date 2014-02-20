#import "SCWebApiVersionResolver.h"


@interface VersionResolverTest : XCTestCase
@end

@implementation VersionResolverTest

-(void)testUnknownVersion
{
    NSString* result = [ SCWebApiVersionResolver webApiVersionToString: SCWebApiUnknown ];
    XCTAssertNil( result, @"version name mismatch" );
}

-(void)testV1Version
{
    NSString* result = [ SCWebApiVersionResolver webApiVersionToString: SCWebApiV1 ];
    XCTAssertEqualObjects( @"v1", result, @"version name mismatch" );
}

-(void)testVersionUnderflow
{
    NSString* result = [ SCWebApiVersionResolver webApiVersionToString: (SCWebApiVersion)(-1) ];
    XCTAssertNil( result, @"version name mismatch" );
}

-(void)testVersionOverflow
{
    NSString* result = [ SCWebApiVersionResolver webApiVersionToString: (SCWebApiVersion)(2) ];
    XCTAssertNil( result, @"version name mismatch" );
}

@end
