#import "testDateUtils.h"

#import "ESLocaleFactory.h"

NSDate* dateFromString( NSString* date_ )
{
    NSDateFormatter* dateFormatter_ = [ ESLocaleFactory ansiDateFormatter ];
    return [ dateFormatter_ dateFromString: date_ ];
}

NSString* stringFromDate( NSDate* string_ )
{
    NSDateFormatter* dateFormatter_ = [ ESLocaleFactory ansiDateFormatter ];
    return [ dateFormatter_ stringFromDate: string_ ];
}

NSInteger weekdayFromDateString( NSString* string_, NSCalendar* calendar_ )
{
    NSDateFormatter* dateFormatter_ = [ ESLocaleFactory ansiDateFormatter ];
    NSDate* date_ = [ dateFormatter_ dateFromString: string_ ];

    NSCalendarUnit unit_ = NSYearForWeekOfYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents* components_ = [ calendar_ components: unit_
                                                  fromDate: date_ ];

    return [ components_ weekday ];
}
