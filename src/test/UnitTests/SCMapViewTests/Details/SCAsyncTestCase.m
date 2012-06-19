#import "SCAsyncTestCase.h"

@implementation SCAsyncTestCase

-(void)performAsyncRequestOnMainThreadWithBlock:( void (^)(JFFSimpleBlock) )block_
                                       selector:( SEL )selector_
{
    block_ = [ block_ copy ];
    void (^autorelease_block_)() = ^void()
    {
        @autoreleasepool
        {
            void (^didFinishCallback_)(void) = ^void()
            {
                [ self notify: kGHUnitWaitStatusSuccess forSelector: selector_ ];
            };

            block_( [ didFinishCallback_ copy ] );
        }
    };

    [ self prepare ];

    dispatch_async( dispatch_get_main_queue(), autorelease_block_ );

    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: 30000. ];
}

@end
