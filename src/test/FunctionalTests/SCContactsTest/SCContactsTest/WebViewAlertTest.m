#import "SCAsyncTestCase.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface WebViewAlertTest : SCAsyncTestCase
@end

@implementation WebViewAlertTest

-(void)testShowAlertAndSelectFirstButton
{
    [ self runTestWithSelector: _cmd
                     testsPath: @"alert_tests"
                     javasript: @"testShowAlertAndSelectFirstButton()" ];
}

-(void)testShowAlertAndSelectLastButton
{
    [ self runTestWithSelector: _cmd
                     testsPath: @"alert_tests"
                     javasript: @"testShowAlertAndSelectLastButton()" ];
}

@end
