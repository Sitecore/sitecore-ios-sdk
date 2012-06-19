#import <SenTestingKit/SenTestingKit.h>

#import "testDateUtils.h"

#import "ESLocaleFactory.h"

#import "NSCalendar+DateAlignment.h"

static ESDateResolution initialResolution_ = ESQuarterDateResolution;

@interface AlignDateRangeTestWithQuarterResolution : SenTestCase
@end

@implementation AlignDateRangeTestWithQuarterResolution

/////////////////// RESULT: QUARTER RESOLUTION ///////////////////

-(void)testAlignDates_Sep20_2011_Mar31_2012_toTwoQuarterResolution
{
    NSDate* startDate_ = dateFromString( @"2011-09-20" );
    NSDate* endDate_   = dateFromString( @"2012-03-31" );

    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    ESDateResolution resolution_ = initialResolution_;

    [ calendar_ alignDateRangeFromDate: &startDate_
                                toDate: &endDate_
                            resolution: &resolution_ ];
    
    STAssertEquals( ESQuarterDateResolution, resolution_, @"ok" );
    
    NSString* startDateStr_ = stringFromDate( startDate_ );
    NSString* endDateStr_   = stringFromDate( endDate_ );
    
    STAssertEqualObjects( startDateStr_, @"2011-10-01", @"ok" );
    STAssertEqualObjects( endDateStr_  , @"2012-03-31", @"ok" );
}

-(void)testAlignDates_Oct01_2011_Apr01_2012_toOneQuarterResolution
{
    NSDate* startDate_ = dateFromString( @"2011-10-01" );
    NSDate* endDate_   = dateFromString( @"2012-04-01" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    ESDateResolution resolution_ = initialResolution_;
    
    [ calendar_ alignDateRangeFromDate: &startDate_
                                toDate: &endDate_
                            resolution: &resolution_ ];
    
    STAssertEquals( ESQuarterDateResolution, resolution_, @"ok" );
    
    NSString* startDateStr_ = stringFromDate( startDate_ );
    NSString* endDateStr_   = stringFromDate( endDate_ );
    
    STAssertEqualObjects( startDateStr_, @"2011-10-01", @"ok" );
    STAssertEqualObjects( endDateStr_  , @"2012-03-31", @"ok" );
}

/////////////////// RESULT: MONTH RESOLUTION ///////////////////

-(void)testAlignDates_Sep20_2011_Mar31_2012_toFourMonthResolution
{
    NSDate* startDate_ = dateFromString( @"2011-10-02" );
    NSDate* endDate_   = dateFromString( @"2012-03-30" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    ESDateResolution resolution_ = initialResolution_;
    
    [ calendar_ alignDateRangeFromDate: &startDate_
                                toDate: &endDate_
                            resolution: &resolution_ ];
    
    STAssertEquals( ESMonthDateResolution, resolution_, @"ok" );
    
    NSString* startDateStr_ = stringFromDate( startDate_ );
    NSString* endDateStr_   = stringFromDate( endDate_ );
    
    STAssertEqualObjects( startDateStr_, @"2011-11-01", @"ok" );
    STAssertEqualObjects( endDateStr_  , @"2012-02-29", @"ok" );
}

/////////////////// RESULT: WEEK RESOLUTION ///////////////////

//May 2012
//Su Mo Tu We Th Fr Sa
//      1  2  3  4  5
//6  7  8  9 10 11 12
//13 14 15 16 17 18 19
//20 21 22 23 24 25 26
//27 28 29 30 31
-(void)testAlignDates_May02_2012_May24_2012_toTwoWeekResolution
{
    NSDate* startDate_ = dateFromString( @"2012-05-02" );
    NSDate* endDate_   = dateFromString( @"2012-05-24" );
    
    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    ESDateResolution resolution_ = initialResolution_;
    
    [ calendar_ alignDateRangeFromDate: &startDate_
                                toDate: &endDate_
                            resolution: &resolution_ ];
    
    STAssertEquals( ESWeekDateResolution, resolution_, @"ok" );
    
    NSString* startDateStr_ = stringFromDate( startDate_ );
    NSString* endDateStr_   = stringFromDate( endDate_ );
    
    STAssertEqualObjects( startDateStr_, @"2012-05-06", @"ok" );
    STAssertEqualObjects( endDateStr_  , @"2012-05-19", @"ok" );
}

/////////////////// RESULT: SEVERAL DAYS ///////////////////

//May 2012
//Su Mo Tu We Th Fr Sa
//      1  2  3  4  5
//6  7  8  9 10 11 12
//13 14 15 16 17 18 19
//20 21 22 23 24 25 26
//27 28 29 30 31
-(void)testAlignDates_May14_2012_May17_2012_toTwoWeekResolution
{
    NSDate* startDate_ = dateFromString( @"2012-05-14" );
    NSDate* endDate_   = dateFromString( @"2012-05-17" );

    NSCalendar* calendar_ = [ ESLocaleFactory gregorianCalendar ];
    ESDateResolution resolution_ = initialResolution_;

    [ calendar_ alignDateRangeFromDate: &startDate_
                                toDate: &endDate_
                            resolution: &resolution_ ];

    STAssertEquals( ESDateResolutionUndefined, resolution_, @"ok" );

    NSString* startDateStr_ = stringFromDate( startDate_ );
    NSString* endDateStr_   = stringFromDate( endDate_ );
    
    STAssertEqualObjects( startDateStr_, @"2012-05-14", @"ok" );
    STAssertEqualObjects( endDateStr_  , @"2012-05-17", @"ok" );
}

@end
