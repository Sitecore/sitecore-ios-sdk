#import "SCWebApiUrlBuilder.h"

@interface WebApiUrlBuilrerTest : XCTestCase
@end

@implementation WebApiUrlBuilrerTest

-(void)testUrlBuilderRejectsInit
{
    XCTAssertThrows( [ SCWebApiUrlBuilder new ], @"assert expected" );
}

-(void)testUrlBuilderRejectsNilVersion
{
    SCWebApiUrlBuilder* result = nil;
    
    XCTAssertThrows
    (
       result = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: nil ],
       @"assert expected"
    );
}

-(void)testUrlBuilderRejectsEmptyVersion
{
    SCWebApiUrlBuilder* result = nil;
    
    XCTAssertThrows
    (
       result = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"" ],
       @"assert expected"
    );
}


-(void)testUrlBuilderSavesVersionCorrectly
{
    SCWebApiUrlBuilder* result = nil;
    
    {
        result = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1"];
        XCTAssertEqualObjects( result.webApiVersion, @"v1", @"version mismatch" );
    }


    {
        result = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"achtung"];
        XCTAssertEqualObjects( result.webApiVersion, @"achtung", @"version mismatch" );
    }
}

@end
