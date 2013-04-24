#import "SCAsyncTestCase.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface WebViewVersionTest : SCAsyncTestCase
@end

@implementation WebViewVersionTest

-(void)testViewDeviceVersionWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"version_tests"
                     javasript: @"testViewDeviceVersion()" ];
}

-(void)testViewDeviceNameWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"version_tests"
                     javasript: @"testViewDeviceName()" ];
}

-(void)testViewDeviceUUIDWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"version_tests"
                     javasript: @"testViewDeviceUUID()" ];
}

-(void)testViewDeviceInfo
{
    [ self testViewDeviceVersionWithSelector: _cmd ];
    [ self testViewDeviceUUIDWithSelector: _cmd ];
    [ self testViewDeviceNameWithSelector: _cmd ];
}


@end