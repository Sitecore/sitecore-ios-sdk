#import "SCCheckboxField.h"

@implementation SCCheckboxField

@dynamic fieldValue;

-(id)createFieldValue
{
    return @( [ self.rawValue isEqualToString: @"1" ] );
}

@end
