#import <SenTestingKit/SenTestingKit.h>

#import "testDateUtils.h"

#import "ESLocaleFactory.h"

#import "NSCalendar+DateAlignment.h"

@interface YearDateAlignmentTest : SenTestCase
@end

@implementation YearDateAlignmentTest

//////////////////// PAST ////////////////////

//March 2011
//Su Mo Tu We Th Fr Sa
//      1  2  3  4  5
//6  7  8  9 10 11 12
//13 14 15 16 17 18 19
//20 21 22 23 24 25 26
//27 28 29 30 31
-(void)testPastMar31_2011_YearDateResolution
{
    NSDate* date_ = dateFromString( @"2011-03-31" );

    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESYearDateResolution ];

    NSString* result_ = stringFromDate( date_ );

    STAssertEqualObjects( result_, @"2010-12-31", @"ok" );
}

//January 2010
//Su Mo Tu We Th Fr Sa
//               1  2
//3  4  5  6  7  8  9
//10 11 12 13 14 15 16
//17 18 19 20 21 22 23
//24 25 26 27 28 29 30
//31
-(void)testPastJan01_2010_YearDateResolution
{
    NSDate* date_ = dateFromString( @"2010-01-01" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESYearDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2009-12-31", @"ok" );
}

//December 2012
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30 31
-(void)testPastDec31_2012_YearDateResolution
{
    NSDate* date_ = dateFromString( @"2012-12-31" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESYearDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-12-31", @"ok" );
}

//////////////////// FUTURE ////////////////////

//March 2011
//Su Mo Tu We Th Fr Sa
//      1  2  3  4  5
//6  7  8  9 10 11 12
//13 14 15 16 17 18 19
//20 21 22 23 24 25 26
//27 28 29 30 31
-(void)testFutureMar31_2011_YearDateResolution
{
    NSDate* date_ = dateFromString( @"2011-03-31" );

    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESYearDateResolution ];

    NSString* result_ = stringFromDate( date_ );

    STAssertEqualObjects( result_, @"2012-01-01", @"ok" );
}

//January 2010
//Su Mo Tu We Th Fr Sa
//               1  2
//3  4  5  6  7  8  9
//10 11 12 13 14 15 16
//17 18 19 20 21 22 23
//24 25 26 27 28 29 30
//31
-(void)testFutureJan01_2010_YearDateResolution
{
    NSDate* date_ = dateFromString( @"2010-01-01" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESYearDateResolution ];

    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2010-01-01", @"ok" );
}

//December 2012
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30 31
-(void)testFutureDec31_2012_YearDateResolution
{
    NSDate* date_ = dateFromString( @"2012-12-31" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESYearDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2013-01-01", @"ok" );
}

@end
