#import <Foundation/Foundation.h>

@interface SCEventValuesParser : NSObject

+(NSString *)getTitleValueFromDict:( NSDictionary *)args;
+(NSString *)getLocationValueFromDict:( NSDictionary *)args;
+(NSString *)getNotesValueFromDict:( NSDictionary *)args;
+(NSTimeInterval)getAlarmValueFromDict:( NSDictionary *)args;
+(NSDate *)getStartDateValueFromDict:( NSDictionary *)args;
+(NSDate *)getEndDateValueFromDict:( NSDictionary *)args;

@end
