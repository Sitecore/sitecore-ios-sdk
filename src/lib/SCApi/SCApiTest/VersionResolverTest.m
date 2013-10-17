#import "SCWebApiVersionResolver.h"


@interface VersionResolverTest : SenTestCase
@end

@implementation VersionResolverTest

-(void)testUnknownVersion
{
    NSString* result = [ SCWebApiVersionResolver webApiVersionToString: SCWebApiUnknown ];
    STAssertNil( result, @"version name mismatch" );
}

-(void)testV1Version
{
    NSString* result = [ SCWebApiVersionResolver webApiVersionToString: SCWebApiV1 ];
    STAssertEqualObjects( @"v1", result, @"version name mismatch" );
}

-(void)testVersionUnderflow
{
    NSString* result = [ SCWebApiVersionResolver webApiVersionToString: (SCWebApiVersion)(-1) ];
    STAssertNil( result, @"version name mismatch" );
}

-(void)testVersionOverflow
{
    NSString* result = [ SCWebApiVersionResolver webApiVersionToString: (SCWebApiVersion)(2) ];
    STAssertNil( result, @"version name mismatch" );
}

@end
