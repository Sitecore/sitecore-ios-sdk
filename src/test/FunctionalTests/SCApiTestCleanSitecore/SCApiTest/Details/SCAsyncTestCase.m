#import "SCAsyncTestCase.h"

@implementation SCAsyncTestCase

//STODO remove
-(NSString*)defaultLogin
{
    return @"admin";
}

//STODO remove
-(NSString*)defaultPassword
{
    return @"b";
}

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

//STODO move to other place
-(SCAsyncOp)resultIntoArrayReader:( SCAsyncOp )reader_
{
    reader_ = [ reader_ copy ];
    return ^( SCAsyncOpResult handler_ )
    {
        handler_ = [ handler_ copy ];
        reader_( ^( id result_, NSError* error_ )
        {
            result_ = result_ ? [ NSArray arrayWithObject: result_ ] : nil;
            if ( handler_ )
                handler_( result_, error_ );
        } );
    };
}

@end
