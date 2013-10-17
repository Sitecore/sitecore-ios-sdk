#import "SCWebApiUrlBuilder.h"

@interface WebApiUrlBuilrerTest : SenTestCase
@end

@implementation WebApiUrlBuilrerTest

-(void)testUrlBuilderRejectsInit
{
    STAssertThrows( [ SCWebApiUrlBuilder new ], @"assert expected" );
}

-(void)testUrlBuilderRejectsNilVersion
{
    SCWebApiUrlBuilder* result = nil;
    
    STAssertThrows
    (
       result = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: nil ],
       @"assert expected"
    );
}

-(void)testUrlBuilderRejectsEmptyVersion
{
    SCWebApiUrlBuilder* result = nil;
    
    STAssertThrows
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
        STAssertEqualObjects( result.webApiVersion, @"v1", @"version mismatch" );
    }


    {
        result = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"achtung"];
        STAssertEqualObjects( result.webApiVersion, @"achtung", @"version mismatch" );
    }
}

@end
