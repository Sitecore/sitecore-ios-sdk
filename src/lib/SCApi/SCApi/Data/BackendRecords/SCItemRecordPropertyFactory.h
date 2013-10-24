#import <Foundation/Foundation.h>

#import "SCItemPropertyGetterBlock.h"

@interface SCItemRecordPropertyFactory : NSObject

+(SCItemPropertyGetter)parentIdGetter;
+(SCItemPropertyGetter)parentPathGetter;

@end
