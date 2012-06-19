#import <Foundation/Foundation.h>

@interface NSDateComponents (Constants)

+(NSDateComponents*)getAddOneDayComponents;
+(NSDateComponents*)getSubtractOneDayComponents;

+(NSDateComponents*)getAddSomeDaysComponents:( NSUInteger )daysCount_;

@end
