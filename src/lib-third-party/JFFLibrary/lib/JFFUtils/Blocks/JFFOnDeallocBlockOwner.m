#import "JFFOnDeallocBlockOwner.h"

@implementation JFFOnDeallocBlockOwner

@synthesize block = _block;

-(id)initWithBlock:( JFFSimpleBlock )block_
{
    self = [ super init ];

    NSParameterAssert( block_ );
    self->_block = [ block_ copy ];

    return self;
}

-(void)dealloc
{
    if ( _block )
        _block();
}

@end
