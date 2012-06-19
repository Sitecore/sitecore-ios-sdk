#import "SqlitePersistentDateFormatter.h"

#import "testDateUtils.h"

#import <SenTestingKit/SenTestingKit.h>

@interface HalfYearAndFullYearTest : SenTestCase
@end

@implementation HalfYearAndFullYearTest

-(void)setUp
{
    [ [ SqlitePersistentDateFormatter instance ] setFormat: nil
                                                    locale: @"ru_RU" ];
}

-(void)testJan1IsInFirstSeason
{
    NSString* result_ = nil;

    NSDate* date_ = dateFromString( @"2012-01-01" );
    result_ = [ [ SqlitePersistentDateFormatter instance ] getHalfYearAndFullYearFromDate: date_ ];
    STAssertTrue( [ result_ isEqualToString: @"H1 '2012" ], @"H1 expected - %@", result_ );
}

-(void)testMarch31IsInFirstSeason
{
    NSString* result_ = nil;

    NSDate* date_ = dateFromString( @"2012-03-31" );
    result_ = [ [ SqlitePersistentDateFormatter instance ] getHalfYearAndFullYearFromDate: date_ ];
    STAssertTrue( [ result_ isEqualToString: @"H1 '2012" ], @"H1 expected - %@", result_ );
}

-(void)testApril1IsInSecondSeason
{
    NSString* result_ = nil;

    NSDate* date_ = dateFromString( @"2012-04-01" );
    result_ = [ [ SqlitePersistentDateFormatter instance ] getHalfYearAndFullYearFromDate: date_ ];
    STAssertTrue( [ result_ isEqualToString: @"H1 '2012" ], @"H1 expected - %@", result_ );
}

-(void)testJun30IsInSecondSeason
{
    NSString* result_ = nil;

    NSDate* date_ = dateFromString( @"2011-06-30" );
    result_ = [ [ SqlitePersistentDateFormatter instance ] getHalfYearAndFullYearFromDate: date_ ];
    STAssertTrue( [ result_ isEqualToString: @"H1 '2011" ], @"H1 expected - %@", result_ );
}

-(void)testJuly1IsInThirdSeason
{
    NSString* result_ = nil;

    NSDate* date_ = dateFromString( @"2012-07-01" );
    result_ = [ [ SqlitePersistentDateFormatter instance ] getHalfYearAndFullYearFromDate: date_ ];
    STAssertTrue( [ result_ isEqualToString: @"H2 '2012" ], @"H1 expected - %@", result_ );
}

-(void)testSep30IsInThirdSeason
{
    NSString* result_ = nil;

    NSDate* date_ = dateFromString( @"2012-09-30" );
    result_ = [ [ SqlitePersistentDateFormatter instance ] getHalfYearAndFullYearFromDate: date_ ];
    STAssertTrue( [ result_ isEqualToString: @"H2 '2012" ], @"H1 expected - %@", result_ );
}

-(void)testOct1IsInFourthSeason
{
    NSString* result_ = nil;

    NSDate* date_ = dateFromString( @"2012-10-01" );
    result_ = [ [ SqlitePersistentDateFormatter instance ] getHalfYearAndFullYearFromDate: date_ ];
    STAssertTrue( [ result_ isEqualToString: @"H2 '2012" ], @"H1 expected - %@", result_ );
}

-(void)testDec31IsInFourthSeason
{
    NSString* result_ = nil;

    NSDate* date_ = dateFromString( @"2012-12-31" );
    result_ = [ [ SqlitePersistentDateFormatter instance ] getHalfYearAndFullYearFromDate: date_ ];
    STAssertTrue( [ result_ isEqualToString: @"H2 '2012" ], @"H1 expected - %@", result_ );
}

@end
