#import "SCFieldImageParams.h"


@interface ImageParamsTest : SenTestCase
@end

@implementation ImageParamsTest

-(void)testParamsStringCorrectWithEmptyObject
{
    SCFieldImageParams *params = [ SCFieldImageParams new ];

    NSString *result = objc_msgSend(params, @selector(paramsString));
    
    STAssertEqualObjects(result, @"", @"wrong param string");
}

-(void)testParamsStringCorrectWithDefaultsValues
{
    SCFieldImageParams *params = [ SCFieldImageParams new ];
    
    params.width              = 0;
    params.height             = 0;
    params.maxWidth           = 0;
    params.maxHeight          = 0;
    params.disableMediaCache  = NO;
    params.allowStrech        = NO;
    params.scale              = 0;
    params.displayAsThumbnail = NO;
    
    NSString *result = objc_msgSend(params, @selector(paramsString));
    NSString *expected = @"?w=0&h=0&mw=0&mh=0&sc=0.00";
    
    STAssertEqualObjects(result, expected, @"wrong param string");

}

-(void)testParamsStringCorrectWithFilledValues
{
    SCFieldImageParams *params = [ SCFieldImageParams new ];
    
    params.width              = 10;
    params.height             = 10;
    params.maxWidth           = 10;
    params.maxHeight          = 10;
    params.disableMediaCache  = YES;
    params.allowStrech        = YES;
    params.scale              = 10;
    params.displayAsThumbnail = YES;
    params.language           = @"somelanguage";
    params.version            = @"someversion";
    params.database           = @"somedatabase";
    params.backgroundColor    = @"somecolor";
    
    NSString *result = objc_msgSend(params, @selector(paramsString));
    NSString *expected = @"?w=10&h=10&mw=10&mh=10&la=somelanguage&vs=someversion&db=somedatabase&bc=somecolor&dmc=1&as=1&thn=1&sc=10.00";
    
    STAssertEqualObjects(result, expected, @"wrong param string");
}

-(void)testParamsStringScaleParamIsCorrect
{
    SCFieldImageParams *params = [ SCFieldImageParams new ];
    
    params.scale              = 0.1;
    NSString *result = objc_msgSend(params, @selector(paramsString));
    STAssertEqualObjects(result, @"?sc=0.10", @"wrong param string");
    
    params.scale              = 1.1;
    result = objc_msgSend(params, @selector(paramsString));
    STAssertEqualObjects(result, @"?sc=1.10", @"wrong param string");
    
    params.scale              = 1.11;
    result = objc_msgSend(params, @selector(paramsString));
    STAssertEqualObjects(result, @"?sc=1.11", @"wrong param string");
    
    params.scale              = 1.111;
    result = objc_msgSend(params, @selector(paramsString));
    STAssertEqualObjects(result, @"?sc=1.11", @"wrong param string");
}

-(void)testParamsStringSizeParams
{
    SCFieldImageParams *params = [ SCFieldImageParams new ];
    
    params.height = 1;
    params.width = 1;
    NSString *result = objc_msgSend(params, @selector(paramsString));
    STAssertEqualObjects(result, @"?w=1&h=1", @"wrong param string");
    
    params.height = 1.1;
    params.width = 1.1;
    result = objc_msgSend(params, @selector(paramsString));
    STAssertEqualObjects(result, @"?w=1&h=1", @"wrong param string");
    
    params.height = 1.5;
    params.width = 1.5;
    result = objc_msgSend(params, @selector(paramsString));
    STAssertEqualObjects(result, @"?w=2&h=2", @"wrong param string");
}

@end
