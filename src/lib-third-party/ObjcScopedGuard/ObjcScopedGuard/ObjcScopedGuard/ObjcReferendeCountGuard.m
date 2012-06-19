#import "ObjcReferendeCountGuard.h"

@implementation ObjcReferendeCountGuard
{
@private
    GuardCallbackBlock _block;
    BOOL _isActive;
}

-(void)dealloc
{
    if ( self->_isActive )
    {
        self->_block();
    }
}

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithBlock:( GuardCallbackBlock )block_
{
    if ( nil == block_ )
    {
        return nil;
    }

    self = [ super init ];
    self->_block = [ block_ copy ];
    self->_isActive = YES;

    return self;
}

-(void)releaseGuard
{
    self->_isActive = NO;
}

@end
