@interface WebViewDmsTriggeringTest : SCAsyncTestCase
@end

@implementation WebViewDmsTriggeringTest

-(void)testTriggerHomeItemGoal
{
    [ self runTestWithSelector: _cmd
                     testsPath: @"analytics_test"
                     javasript: @"testTriggerHomeGoal()" ];
}

-(void)testTriggerHomeItemCampaign
{
    [ self runTestWithSelector: _cmd
                     testsPath: @"analytics_test"
                     javasript: @"testTriggerHomeCampaign()" ];
}


@end
