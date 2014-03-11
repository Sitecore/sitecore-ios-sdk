#import "SCMultilistField.h"

@implementation SCMultilistField

@dynamic fieldValue;

-(SCAsyncOp)readFieldValueOperation
{
    return [ super readFieldValueOperation ];
}

@end
