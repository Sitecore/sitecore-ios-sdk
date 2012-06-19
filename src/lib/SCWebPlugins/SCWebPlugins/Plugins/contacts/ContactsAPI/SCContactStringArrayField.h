#import "SCContactField.h"

@interface SCContactStringArrayField : SCContactField

+(id)contactFieldWithName:( NSString* )name_
               propertyID:( ABPropertyID )propertyID_
                   labels:( NSArray* )labels_;

@end
