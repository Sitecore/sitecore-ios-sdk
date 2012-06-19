//
//  SChartDateFrequency.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
 An SChartDateFrequency is used to specify the desired frequency of tick marks on an SChartDateTimeAxis. For example, a frequency of 2 hours will attempt to display a tick mark at every 2 hour mark on the axis. No class type other than SChartDateFrequency (and subclasses) may be used to define a date frequency.
 
 A frequency of a particular calendar unit may be set from the following supported components: year, month, week, day, hour, minute, second. This can be done by initialising an SChartDateFrequency object, then using the setter method for the appropriate component (as listed above), or by using the convenience init methods (such as initWithSecond:). 
 
 A frequency may only be of one unit type. For example - a frequency of 1 hour AND 3 minutes cannot be set. In this case the frequency can only be of the type hour or of the type minute and will be set to the last component specified. To specify partial units it is necessary to use the lowest denominator - in the case of 1 hour and 3 minutes we would create a frequency of 63 minutes.
 
 If an attempt is made to set frequency to a negative or zero value, a default of 1 for the given component will be set. For example, if an attempt is made to set a frequency of -9 years the actual frequency set will be 1 year.
 
 *Frequency Denominations:*<br>
 <code>typedef enum {<br>
 SChartDateFrequencyDenominationSeconds,<br>
 SChartDateFrequencyDenominationMinutes,<br>
 SChartDateFrequencyDenominationHours,<br>
 SChartDateFrequencyDenominationDays,<br>
 SChartDateFrequencyDenominationWeeks,<br>
 SChartDateFrequencyDenominationMonths,<br>
 SChartDateFrequencyDenominationYears<br>
 } SChartDateFrequencyDenomination;</code>
 
 */

typedef enum {
    SChartDateFrequencyDenominationSeconds,
    SChartDateFrequencyDenominationMinutes,
    SChartDateFrequencyDenominationHours, 
    SChartDateFrequencyDenominationDays,
    SChartDateFrequencyDenominationWeeks,
    SChartDateFrequencyDenominationMonths,
    SChartDateFrequencyDenominationYears
} SChartDateFrequencyDenomination;

@interface SChartDateFrequency : NSObject {
    NSDateComponents *dateComponents;
}

#pragma mark -
#pragma mark Initialising
/** @name Creating a frequency*/
/** Allows an SChartDateFrequency object to be initialised with a year component*/
- (id)initWithYear:(NSInteger)newYear;
/** Allows an SChartDateFrequency object to be initialised with a month component*/
- (id)initWithMonth:(NSInteger)newMonth;
/** Allows an SChartDateFrequency object to be initialised with a week component*/
- (id)initWithWeek:(NSInteger)newWeek;
/** Allows an SChartDateFrequency object to be initialised with a day component*/
- (id)initWithDay:(NSInteger)newDay;
/** Allows an SChartDateFrequency object to be initialised with a hour component*/
- (id)initWithHour:(NSInteger)newHour;
/** Allows an SChartDateFrequency object to be initialised with a minute component*/
- (id)initWithMinute:(NSInteger)newMinute;
/** Allows an SChartDateFrequency object to be initialised with a second component*/
- (id)initWithSecond:(NSInteger)newSecond;

#pragma mark -
#pragma mark Initialising
/** @name Setting a new frequency*/
/** Clear any other frequency components and set a number of years*/
- (void)setYear:(NSInteger)v;
/** Clear any other frequency components and set a number of months*/
- (void)setMonth:(NSInteger)v;
/** Clear any other frequency components and set a number of weeks*/
- (void)setWeek:(NSInteger)v;
/** Clear any other frequency components and set a number of days*/
- (void)setDay:(NSInteger)v;
/** Clear any other frequency components and set a number of hours*/
- (void)setHour:(NSInteger)v;
/** Clear any other frequency components and set a number of minutes*/
- (void)setMinute:(NSInteger)v;
/** Clear any other frequency components and set a number of seconds*/
- (void)setSecond:(NSInteger)v;


#pragma mark -
#pragma mark Internal: Date components
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)week;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;


- (double)toSeconds;

@property (nonatomic, assign) SChartDateFrequencyDenomination denomination;

@end
