#import "NSDateComponents+AddingTimeIntervals.h"

#include "CalendarAlignmentConstants.h"

@implementation NSDateComponents (AddingTimeIntervals)

+(id)dayComponentsWithTimeInterval:( NSInteger )interval_
{
    NSDateComponents* result_ = [ self new ];
    result_.day = interval_;
    return result_;
}

+(id)weekComponentsWithTimeInterval:( NSInteger )interval_
{
    NSDateComponents* result_ = [ self new ];
    result_.week = interval_;
    return result_;
}

+(id)monthComponentsWithTimeInterval:( NSInteger )interval_
{
    NSDateComponents* result_ = [ self new ];
    result_.month = interval_;
    return result_;
}

+(id)quarterComponentsWithTimeInterval:( NSInteger )interval_
{
    NSDateComponents* result_ = [ self new ];
    result_.month = ESCalendarMonthPerQuarter * interval_;
    return result_;
}

+(id)halfYearComponentsWithTimeInterval:( NSInteger )interval_
{
    NSDateComponents* result_ = [ self new ];
    result_.month = ESCalendarMonthPerHalfYear * interval_;
    return result_;
}

+(id)yearAlignComponentsWithTimeInterval:( NSInteger )interval_
{
    NSDateComponents* result_ = [ self new ];
    result_.year = interval_;
    return result_;
}

@end
