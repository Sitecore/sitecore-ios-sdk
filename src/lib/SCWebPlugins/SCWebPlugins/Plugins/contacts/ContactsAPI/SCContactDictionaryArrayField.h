#import "SCContactField.h"

@interface SCContactDictionaryArrayField : SCContactField

+(id)contactFieldWithName:( NSString* )name_
               propertyID:( ABPropertyID )propertyID_
                   labels:( NSArray* )labels_;

@end
