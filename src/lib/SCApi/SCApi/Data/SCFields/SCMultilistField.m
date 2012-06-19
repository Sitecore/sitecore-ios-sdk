#import "SCMultilistField.h"

@implementation SCMultilistField

@dynamic fieldValue;

-(SCAsyncOp)fieldValueReader
{
    return [ super fieldValueReader ];
}

@end
