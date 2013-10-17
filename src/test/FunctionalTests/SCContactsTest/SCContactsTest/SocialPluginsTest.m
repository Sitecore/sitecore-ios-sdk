@interface SocialPluginsTest : SCAsyncTestCase
@end


@implementation SocialPluginsTest

-(void)testTwitter
{
    [ self runTestWithSelector: _cmd
                     testsPath: @"social_test"
                     javasript: @"testTwitter()" ];
}

-(void)testFacebook
{
    [ self runTestWithSelector: _cmd
                     testsPath: @"social_test"
                     javasript: @"testFacebook()" ];
}

-(void)testSocial
{
    [ self runTestWithSelector: _cmd
                     testsPath: @"social_test"
                     javasript: @"testSocial()" ];
}

@end
