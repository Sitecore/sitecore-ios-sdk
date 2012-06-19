#import <SenTestingKit/SenTestingKit.h>

#import "testDateUtils.h"

#import "ESLocaleFactory.h"

#import "NSCalendar+DateAlignment.h"

@interface WeakDateAlignmentTest : SenTestCase
@end

@implementation WeakDateAlignmentTest

//////////////////// PAST ////////////////////

//January 2011
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30 31
-(void)testPastJan01_2011_WeekDateResolution
{
    NSDate* date_ = dateFromString( @"2011-01-01" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESWeekDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2011-01-01", @"ok" );
    
    NSInteger weekday_ = weekdayFromDateString( result_, calendar_ );
    STAssertEquals( weekday_, 7, @"ok" );//should be saturday
}

//May 2012
//Su Mo Tu We Th Fr Sa
//      1  2  3  4  5
//6  7  8  9 10 11 12
//13 14 15 16 17 18 19
//20 21 22 23 24 25 26
//27 28 29 30 31
-(void)testPastMay22_2012_WeekDateResolution
{
    NSDate* date_ = dateFromString( @"2012-05-22" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESWeekDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-05-19", @"ok" );
    
    NSInteger weekday_ = weekdayFromDateString( result_, calendar_ );
    STAssertEquals( weekday_, 7, @"ok" );//should be saturday
}

//May 2012
//Su Mo Tu We Th Fr Sa
//      1  2  3  4  5
//6  7  8  9 10 11 12
//13 14 15 16 17 18 19
//20 21 22 23 24 25 26
//27 28 29 30 31
-(void)testRuSundayPastMay22_2012_WeekDateResolution
{
    NSDate* date_ = dateFromString( @"2012-05-22" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    [ calendar_ setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: @"ru_RU" ] ];
    
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESWeekDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-05-20", @"ok" );
    
    NSInteger weekday_ = weekdayFromDateString( result_, calendar_ );
    STAssertEquals( weekday_, 1, @"ok" );//should be sunday
}

//January 2012
//Su Mo Tu We Th Fr Sa
//1  2  3  4  5  6  7
//8  9 10 11 12 13 14
//15 16 17 18 19 20 21
//22 23 24 25 26 27 28
//29 30 31
-(void)testPastJan01_2012_WeekDateResolution
{
    NSDate* date_ = dateFromString( @"2012-01-01" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESWeekDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2011-12-31", @"ok" );
    
    NSInteger weekday_ = weekdayFromDateString( result_, calendar_ );
    STAssertEquals( weekday_, 7, @"ok" );//should be saturday
}

//////////////////// FUTURE ////////////////////

//December 2010
//Su Mo Tu We Th Fr Sa
//         1  2  3  4
//5  6  7  8  9 10 11
//12 13 14 15 16 17 18
//19 20 21 22 23 24 25
//26 27 28 29 30 31
-(void)testFutureDec30_2010_WeekDateResolution
{
    NSDate* date_ = dateFromString( @"2010-12-30" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESWeekDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2011-01-02", @"ok" );
    
    NSInteger weekday_ = weekdayFromDateString( result_, calendar_ );
    STAssertEquals( weekday_, 1, @"ok" );//should be sunday
}

//December 2010
//Su Mo Tu We Th Fr Sa
//         1  2  3  4
//5  6  7  8  9 10 11
//12 13 14 15 16 17 18
//19 20 21 22 23 24 25
//26 27 28 29 30 31
-(void)testRuMondayFutureDec30_2010_WeekDateResolution
{
    NSDate* date_ = dateFromString( @"2010-12-30" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    [ calendar_ setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: @"ru_RU" ] ];
    
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESWeekDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2011-01-03", @"ok" );
    
    NSInteger weekday_ = weekdayFromDateString( result_, calendar_ );
    STAssertEquals( weekday_, 2, @"ok" );//should be monday
}

//January 2011
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30 31
-(void)testFutureJan02_2011_WeekDateResolution
{
    NSDate* date_ = dateFromString( @"2011-01-02" );

    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESWeekDateResolution ];

    NSString* result_ = stringFromDate( date_ );

    STAssertEqualObjects( result_, @"2011-01-02", @"ok" );

    NSInteger weekday_ = weekdayFromDateString( result_, calendar_ );
    STAssertEquals( weekday_, 1, @"ok" );//should be sunday
}

//December 2011
//Su Mo Tu We Th Fr Sa
//            1  2  3
//4  5  6  7  8  9 10
//11 12 13 14 15 16 17
//18 19 20 21 22 23 24
//25 26 27 28 29 30 31
-(void)testFutureDec31_2011_WeekDateResolution
{
    NSDate* date_ = dateFromString( @"2011-12-31" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESWeekDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-01-01", @"ok" );
    
    NSInteger weekday_ = weekdayFromDateString( result_, calendar_ );
    STAssertEquals( weekday_, 1, @"ok" );//should be sunday
}

@end
