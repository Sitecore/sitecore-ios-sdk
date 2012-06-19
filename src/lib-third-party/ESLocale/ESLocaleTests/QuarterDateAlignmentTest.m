#import <SenTestingKit/SenTestingKit.h>

#import "testDateUtils.h"

#import "ESLocaleFactory.h"

#import "NSCalendar+DateAlignment.h"

@interface QuarterDateAlignmentTest : SenTestCase
@end

@implementation QuarterDateAlignmentTest

//////////////////// PAST ////////////////////

//January 2012
//Su Mo Tu We Th Fr Sa
//1  2  3  4  5  6  7
//8  9 10 11 12 13 14
//15 16 17 18 19 20 21
//22 23 24 25 26 27 28
//29 30 31
-(void)testPastJan01_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-01-01" );

    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESQuarterDateResolution ];

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
-(void)testPastMay22_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-05-22" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESQuarterDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-03-31", @"ok" );
}

//September 2012
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30
-(void)testPastSep22_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-09-22" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESQuarterDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-06-30", @"ok" );
}

//October 2012
//Su Mo Tu We Th Fr Sa
//   1  2  3  4  5  6
//7  8  9 10 11 12 13
//14 15 16 17 18 19 20
//21 22 23 24 25 26 27
//28 29 30 31
-(void)testPastOct22_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-10-22" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESQuarterDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-09-30", @"ok" );
}

//December 2012
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30 31
-(void)testPastDec31_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-03-31" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToPastDate: date_ resolution: ESQuarterDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-03-31", @"ok" );
}

//////////////////// FUTURE ////////////////////

//January 2012
//Su Mo Tu We Th Fr Sa
//1  2  3  4  5  6  7
//8  9 10 11 12 13 14
//15 16 17 18 19 20 21
//22 23 24 25 26 27 28
//29 30 31
-(void)testFutureJan01_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-01-01" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESQuarterDateResolution ];
    
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
-(void)testFutureJan02_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-01-02" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESQuarterDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-04-01", @"ok" );
}

//May 2012
//Su Mo Tu We Th Fr Sa
//      1  2  3  4  5
//6  7  8  9 10 11 12
//13 14 15 16 17 18 19
//20 21 22 23 24 25 26
//27 28 29 30 31
-(void)testFutureMay22_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-05-22" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESQuarterDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-07-01", @"ok" );
}

//September 2012
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30
-(void)testFutureSep22_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-09-22" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESQuarterDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2012-10-01", @"ok" );
}

//October 2012
//Su Mo Tu We Th Fr Sa
//   1  2  3  4  5  6
//7  8  9 10 11 12 13
//14 15 16 17 18 19 20
//21 22 23 24 25 26 27
//28 29 30 31
-(void)testFutureOct22_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-10-22" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESQuarterDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2013-01-01", @"ok" );
}

//December 2012
//Su Mo Tu We Th Fr Sa
//                  1
//2  3  4  5  6  7  8
//9 10 11 12 13 14 15
//16 17 18 19 20 21 22
//23 24 25 26 27 28 29
//30 31
-(void)testFutureDec31_2012_QuarterDateResolution
{
    NSDate* date_ = dateFromString( @"2012-12-31" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    date_ = [ calendar_ alignToFutureDate: date_ resolution: ESQuarterDateResolution ];
    
    NSString* result_ = stringFromDate( date_ );
    
    STAssertEqualObjects( result_, @"2013-01-01", @"ok" );
}

@end
