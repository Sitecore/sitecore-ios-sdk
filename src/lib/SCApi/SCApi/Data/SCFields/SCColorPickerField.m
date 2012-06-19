#import "SCColorPickerField.h"

@implementation SCColorPickerField

@dynamic fieldValue;

-(id)createFieldValue
{
    return [ UIColor colorForHex: self.rawValue ];
}

@end
