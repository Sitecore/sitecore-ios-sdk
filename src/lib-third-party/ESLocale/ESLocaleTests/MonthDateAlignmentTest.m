#import <SenTestingKit/SenTestingKit.h>

#import "testDateUtils.h"

#import "ESLocaleFactory.h"

#import "NSCalendar+DateAlignment.h"

@interface MonthDateAlignmentTest : SenTestCase
@end

@implementation MonthDateAlignmentTest

//////////////////// PAST ////////////////////

//January 2012
//Su Mo Tu We Th Fr Sa
//1  2  3  4  5  6  7
//8  9 10 11 12 13 14
//15 16 17 18 19 20 21
//22 23 24 25 26 27 28
//29 30 31
-(void)testPastJan01_2012_MonthDateResolution
{
    NSDate* date_ = dateFromString( @"2012-01-01" );

    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESMonthDateResolution ];

    NSString* result_ = stringFromDate( date_ );

    STAssertEqualObjects( result_, @"2011-12-31", @"ok" );
}

//May 2012
//Su Mo Tu We Th Fr Sa
//      1  2  3  4  5
//6  7  8  9 10 11 12
//13 14 15 16 17 18 19
//20 21 22 23 24 25 26
//27 28 29 30 31
-(void)testPastMay22_2012_MonthDateResolution
{
    NSDate* date_ = dateFromString( @"2012-05-22" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESMonthDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-04-30", @"ok" );
}

//December 2012
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30 31
-(void)testPastDec31_2012_MonthDateResolution
{
    NSDate* date_ = dateFromString( @"2011-12-31" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESMonthDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2011-12-31", @"ok" );
}

//////////////////// FUTURE ////////////////////

//January 2012
//Su Mo Tu We Th Fr Sa
//1  2  3  4  5  6  7
//8  9 10 11 12 13 14
//15 16 17 18 19 20 21
//22 23 24 25 26 27 28
//29 30 31
-(void)testFutureJan01_2012_MonthDateResolution
{
    NSDate* date_ = dateFromString( @"2012-01-01" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESMonthDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-01-01", @"ok" );
}

//December 2012
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30 31
-(void)testFutureDec28_2012_MonthDateResolution
{
    NSDate* date_ = dateFromString( @"2011-12-28" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESMonthDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-01-01", @"ok" );
}

//January 2012
//Su Mo Tu We Th Fr Sa
//1  2  3  4  5  6  7
//8  9 10 11 12 13 14
//15 16 17 18 19 20 21
//22 23 24 25 26 27 28
//29 30 31
-(void)testFutureJan11_2012_MonthDateResolution
{
    NSDate* date_ = dateFromString( @"2012-01-11" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESMonthDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-02-01", @"ok" );
}

@end
