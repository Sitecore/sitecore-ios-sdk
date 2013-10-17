#import "SCItemRecord+IsCacheStub.h"

@implementation SCItemRecord (IsCacheStub)

-(BOOL)isCacheStub
{
    return ( nil == self.itemTemplate );
}

@end
