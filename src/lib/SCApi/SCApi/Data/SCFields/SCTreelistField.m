#import "SCTreelistField.h"

@implementation SCTreelistField

@dynamic fieldValue;

-(SCAsyncOp)fieldValueReader
{
    return [ super fieldValueReader ];
}

@end
