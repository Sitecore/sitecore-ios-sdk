#import "NSDateComponents+DateAlignment.h"

#include "CalendarAlignmentConstants.h"

@implementation NSDateComponents (DateAlignment)

+(id)weekAlignComponentsToFuture:( BOOL )toFuture_
                            date:( NSDate* )date_
                        calendar:( NSCalendar* )calendar_
{
    NSCalendarUnit unit_ = NSYearForWeekOfYearCalendarUnit | NSWeekOfYearCalendarUnit;
    NSDateComponents* components_ = [ calendar_ components: unit_
                                                  fromDate: date_ ];

    NSInteger firstWeekday_ = (NSInteger)[ calendar_ firstWeekday ];
    [ components_ setWeekday: firstWeekday_ ];

    if ( toFuture_ )
    {
        [ components_ setWeekOfYear: [ components_ weekOfYear ] + 1 ];
    }

    return components_;
}

+(id)monthAlignComponentsToFuture:( BOOL )toFuture_
                             date:( NSDate* )date_
                         calendar:( NSCalendar* )calendar_
{
    NSCalendarUnit unit_ = NSYearCalendarUnit | NSMonthCalendarUnit;

    NSDateComponents* components_ = [ calendar_ components: unit_
                                                  fromDate: date_ ];

    if ( toFuture_ )
    {
        [ components_ setMonth: [ components_ month ] + 1 ];
    }

    return components_;
}

+(id)quarterAlignComponentsToFuture:( BOOL )toFuture_
                               date:( NSDate* )date_
                           calendar:( NSCalendar* )calendar_
{
    //NSDateComponents.quarter property does not work properly,
    //so own range calulation used here
    //TODO: try to use NSQuarterCalendarUnit

    NSCalendarUnit unit_ = NSYearCalendarUnit | NSMonthCalendarUnit;

    NSDateComponents* components_ = [ calendar_ components: unit_
                                                  fromDate: date_ ];

    NSInteger quarterStartMonth_ = ( [ components_ month ] - 1 )
    / ESCalendarMonthPerQuarter * ESCalendarMonthPerQuarter + 1;
    if ( toFuture_ )
    {
        quarterStartMonth_ += ESCalendarMonthPerQuarter;
    }
    [ components_ setMonth: quarterStartMonth_ ];

    return components_;
}

+(id)halfYearAlignComponentsToFuture:( BOOL )toFuture_
                                date:( NSDate* )date_
                            calendar:( NSCalendar* )calendar_
{
    NSCalendarUnit unit_ = NSYearCalendarUnit | NSMonthCalendarUnit;

    NSDateComponents* components_ = [ calendar_ components: unit_
                                                  fromDate: date_ ];

    NSInteger monthStart_ = ( [ components_ month ] - 1 ) / ESCalendarMonthPerHalfYear * ESCalendarMonthPerHalfYear + 1;
    if ( toFuture_ )
    {
        monthStart_ += ESCalendarMonthPerHalfYear;
    }
    [ components_ setMonth: monthStart_ ];

    return components_;
}

+(id)yearAlignComponentsToFuture:( BOOL )toFuture_
                            date:( NSDate* )date_
                        calendar:( NSCalendar* )calendar_
{
    NSCalendarUnit unit_ = NSYearCalendarUnit;

    NSDateComponents* components_ = [ calendar_ components: unit_
                                                  fromDate: date_ ];

    if ( toFuture_ )
    {
        [ components_ setYear: [ components_ year ] + 1 ];
    }

    return components_;
}

@end
