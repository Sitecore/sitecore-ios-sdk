#import "SCEventValuesParser.h"
#import "GTMNSString+HTML.h"

@implementation SCEventValuesParser

+(NSString *)getTitleValueFromDict:( NSDictionary *)args
{
    NSString * result = [ args firstValueIfExsistsForKey: @"title" ];
    
    if (!result)
    {
        result = @"";
    }
    
    return [result gtm_stringByUnescapingFromHTML];
}

+(NSString *)getLocationValueFromDict:( NSDictionary *)args
{
    NSString * result = [ args firstValueIfExsistsForKey: @"location" ];
    
    if (!result)
    {
        result = @"";
    }
    
    return [result gtm_stringByUnescapingFromHTML];
}

+(NSString *)getNotesValueFromDict:( NSDictionary *)args
{
    NSString * result = [ args firstValueIfExsistsForKey: @"notes" ];
    
    if (!result)
    {
        result = @"";
    }
    
    return [result gtm_stringByUnescapingFromHTML];
}

+(NSTimeInterval)getAlarmValueFromDict:( NSDictionary *)args
{
    NSString * value = [ args firstValueIfExsistsForKey: @"alarm" ];
    NSTimeInterval result = 0;
    if ( value )
        result = [ value doubleValue ];
    
    return result;
}

+(NSDate *)getStartDateValueFromDict:( NSDictionary *)args
{
    NSString* value_ = [ args firstValueIfExsistsForKey: @"startDate" ];

    return [ self dateValueFromTimestampString: value_ ];
}

+(NSDate *)getEndDateValueFromDict:( NSDictionary *)args
{
    NSString* value_ = [ args firstValueIfExsistsForKey: @"endDate" ];
    
    return [ self dateValueFromTimestampString: value_ ];
}

+(NSDate *)dateValueFromTimestampString:( NSString *)timestampString
{
    NSTimeInterval timeInterval_ = [ timestampString longLongValue ] / 1000.;
    NSDate *result = timeInterval_ == 0. ? nil : [ NSDate dateWithTimeIntervalSince1970: timeInterval_ ];
    
    return result;
}

@end
