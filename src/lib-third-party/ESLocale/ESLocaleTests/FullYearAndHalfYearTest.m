#import "SqlitePersistentDateFormatter.h"

#import "testDateUtils.h"

#import <SenTestingKit/SenTestingKit.h>

@interface FullYearAndHalfYearTest : SenTestCase
@end

@implementation FullYearAndHalfYearTest

-(void)setUp
{
    [ [ SqlitePersistentDateFormatter instance ] setFormat: nil
                                                    locale: @"ru_RU" ];
}

-(void)testJan1IsInFirstSeason
{
    NSString* result_ = nil;
    
    result_ = [ [ SqlitePersistentDateFormatter instance ] getFullYearAndHalfYear: @"2012-01-01" ];
    STAssertTrue( [ result_ isEqualToString: @"2012-1" ], @"expected - %@", result_ );
}

-(void)testMarch31IsInFirstSeason
{
    NSString* result_ = nil;
    
    result_ = [ [ SqlitePersistentDateFormatter instance ] getFullYearAndHalfYear: @"2012-03-31" ];
    STAssertTrue( [ result_ isEqualToString: @"2012-1" ], @"expected - %@", result_ );
}

-(void)testApril1IsInSecondSeason
{
    NSString* result_ = nil;
    
    result_ = [ [ SqlitePersistentDateFormatter instance ] getFullYearAndHalfYear: @"2012-04-01" ];
    STAssertTrue( [ result_ isEqualToString: @"2012-1" ], @"expected - %@", result_ );
}

-(void)testJun30IsInSecondSeason
{
    NSString* result_ = nil;
    
    result_ = [ [ SqlitePersistentDateFormatter instance ] getFullYearAndHalfYear: @"2011-06-30" ];
    STAssertTrue( [ result_ isEqualToString: @"2011-1" ], @"expected - %@", result_ );
}

-(void)testJuly1IsInThirdSeason
{
    NSString* result_ = nil;
    
    result_ = [ [ SqlitePersistentDateFormatter instance ] getFullYearAndHalfYear: @"2012-07-01" ];
    STAssertTrue( [ result_ isEqualToString: @"2012-2" ], @"expected - %@", result_ );
}

-(void)testSep30IsInThirdSeason
{
    NSString* result_ = nil;

    result_ = [ [ SqlitePersistentDateFormatter instance ] getFullYearAndHalfYear: @"2012-09-30" ];
    STAssertTrue( [ result_ isEqualToString: @"2012-2" ], @"expected - %@", result_ );
}

-(void)testOct1IsInFourthSeason
{
    NSString* result_ = nil;

    result_ = [ [ SqlitePersistentDateFormatter instance ] getFullYearAndHalfYear: @"2012-10-01" ];
    STAssertTrue( [ result_ isEqualToString: @"2012-2" ], @"expected - %@", result_ );
}

-(void)testDec31IsInFourthSeason
{
    NSString* result_ = nil;

    result_ = [ [ SqlitePersistentDateFormatter instance ] getFullYearAndHalfYear: @"2012-12-31" ];
    STAssertTrue( [ result_ isEqualToString: @"2012-2" ], @"expected - %@", result_ );
}

@end
