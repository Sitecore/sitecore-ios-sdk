#import "SCDroptreeField.h"

@implementation SCDroptreeField

@dynamic fieldValue;

-(SCAsyncOp)fieldValueReader
{
    return [ super fieldValueReader ];
}

@end
