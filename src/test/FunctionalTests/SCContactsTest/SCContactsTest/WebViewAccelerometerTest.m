#import "SCAsyncTestCase.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface WebViewAccelerometerTest : SCAsyncTestCase
@end

@implementation WebViewAccelerometerTest

#if !(TARGET_IPHONE_SIMULATOR)
-(void)testGetAccelerometerXYZData
{
    [ self runTestWithSelector: _cmd
                     testsPath: @"accelerometer_tests"
                     javasript: @"testAccelerometer()" ];
}
#endif

@end
