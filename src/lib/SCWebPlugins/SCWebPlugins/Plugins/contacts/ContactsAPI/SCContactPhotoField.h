#import "SCContactField.h"

@interface SCContactPhotoField : SCContactField

+(id)contactFieldWithName:( NSString* )name_;
@property ( nonatomic ) UIImage* value;

@end
