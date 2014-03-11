#import "SCDroptreeField.h"

@implementation SCDroptreeField

@dynamic fieldValue;

-(SCAsyncOp)readFieldValueOperation
{
    return [ super readFieldValueOperation ];
}

@end
