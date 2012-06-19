#import "SCCheckboxField.h"

@implementation SCCheckboxField

@dynamic fieldValue;

-(id)createFieldValue
{
    return [ [ NSNumber alloc ] initWithBool: [ self.rawValue isEqualToString: @"1" ] ];
}

@end
