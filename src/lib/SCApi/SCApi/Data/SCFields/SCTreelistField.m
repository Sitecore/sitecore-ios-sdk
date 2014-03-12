#import "SCTreelistField.h"

@implementation SCTreelistField

@dynamic fieldValue;

-(SCAsyncOp)readFieldValueOperation
{
    return [ super readFieldValueOperation ];
}

@end
