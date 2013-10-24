#import "NSString+URLWithItemsReaderRequest.h"

@interface SchemeAutocompleteTest : SenTestCase
@end

@implementation SchemeAutocompleteTest

-(void)testHttpSchemeIsDetected
{
    NSString* src = @"http://linux.org.ru";
    NSString* result = [ src scHostWithURLScheme ];
    
    STAssertEqualObjects( result, src, @"http scheme error" );
}

-(void)testHttpsSchemeIsDetected
{
    NSString* src = @"https://github.com";
    NSString* result = [ src scHostWithURLScheme ];
    
    STAssertEqualObjects( result, src, @"https scheme error" );
}

-(void)testNonHttpSchemeIsDetected
{
    NSString* src = @"ftp://gnu.org";
    NSString* result = [ src scHostWithURLScheme ];
    
    STAssertEqualObjects( result, src, @"non http scheme error" );
}

-(void)testHttpSchemeIsDefault
{
    NSString* src = @"sitecore.net";
    NSString* result = [ src scHostWithURLScheme ];
    NSString* expected = @"http://sitecore.net";
    
    STAssertEqualObjects( result, expected, @"auto scheme error" );
}

@end
