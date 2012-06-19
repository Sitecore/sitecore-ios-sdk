#import "JWSTestListener.h"

#import <JFFScheduler/JFFScheduler.h>

@implementation JWSTestListener
{
    JFFScheduler* _scheduler;
}

+(NSString*)requestURLPath
{
    return @"/scmobile/test";
}

-(void)didOpen
{
    [ super didOpen ];

    _scheduler = [ JFFScheduler new ];
    __weak JWSTestListener* self_ = self;
    [ _scheduler addBlock: ^void( JFFCancelScheduledBlock cancel_ )
    {
//      dispatch_async( dispatch_get_main_queue(), ^()
        {
            [ self_ sendMessage: @"tst msg" ];
        }
      //);

//      [ self_ sendMessage: @"tst msg" ];
    } duration: 0.1 ];
//   [ self stop ];
}

@end
