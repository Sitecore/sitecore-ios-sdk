#import "ESLocaleFactory.h"
#import "SqlitePersistentDateFormatter.h"

#import <SenTestingKit/SenTestingKit.h>

@interface HalfYearNumberTest : SenTestCase

@property( nonatomic, strong ) NSDateFormatter* ansiDateFormatter;

@end

@implementation HalfYearNumberTest
{
    NSDateFormatter* _ansiFormatter;
}

@synthesize ansiDateFormatter = _ansiFormatter;

-(NSDateFormatter*)ansiDateFormatter
{
    if ( nil == self->_ansiFormatter )
    {
        self->_ansiFormatter = [ ESLocaleFactory ansiDateFormatter ];
    }
    
    return self->_ansiFormatter;
}

-(void)setUp
{
    [ [ SqlitePersistentDateFormatter instance ] setFormat: nil
                                                    locale: @"en_US_POSIX" ];
}

-(void)testHalfYearRejectsNilInput
{
    NSInteger result_ = 0;
    

    {
        result_ = [ SqlitePersistentDateFormatter halfYearForDate: nil
                                                    usingCalendar: [ NSCalendar currentCalendar ] ];

        STAssertTrue( -1 == result_, @"valid error code expected - %d", result_ );
    }

    {
        result_ = [ SqlitePersistentDateFormatter halfYearForDate: [ NSDate date ]
                                                    usingCalendar: nil ];

        STAssertTrue( -2 == result_, @"valid error code expected - %d", result_ );
    }
}

-(void)testJune30IsInFirstSeason
{
    NSDateFormatter* ansiFormatter_ = self.ansiDateFormatter ;
    NSCalendar*      posixCalendar_ = ansiFormatter_.calendar;
    
    NSDate*   date_   = nil;
    NSInteger result_ = 0  ;
    
    
    date_ = [ ansiFormatter_ dateFromString: @"2012-06-30" ];
    result_ = [ SqlitePersistentDateFormatter halfYearForDate: date_
                                                usingCalendar: posixCalendar_ ]; 
    
    STAssertTrue( 1 == result_, @"H1 expected" );    
}

-(void)testJuly1IsInSecondSeason
{
    NSDateFormatter* ansiFormatter_ = self.ansiDateFormatter ;
    NSCalendar*      posixCalendar_ = ansiFormatter_.calendar;
    
    NSDate*   date_   = nil;
    NSInteger result_ = 0  ;
    
    
    date_ = [ ansiFormatter_ dateFromString: @"2012-07-01" ];
    result_ = [ SqlitePersistentDateFormatter halfYearForDate: date_
                                                usingCalendar: posixCalendar_ ]; 
    
    STAssertTrue( 2 == result_, @"H2 expected" );    
}


-(void)testDec31IsInSecondSeason
{
    NSDateFormatter* ansiFormatter_ = self.ansiDateFormatter ;
    NSCalendar*      posixCalendar_ = ansiFormatter_.calendar;
    
    NSDate*   date_   = nil;
    NSInteger result_ = 0  ;
    
    
    date_ = [ ansiFormatter_ dateFromString: @"2011-12-31" ];
    result_ = [ SqlitePersistentDateFormatter halfYearForDate: date_
                                                usingCalendar: posixCalendar_ ]; 
    
    STAssertTrue( 2 == result_, @"H2 expected" );    
}

-(void)testJan1IsInFirstSeason
{
    NSDateFormatter* ansiFormatter_ = self.ansiDateFormatter ;
    NSCalendar*      posixCalendar_ = ansiFormatter_.calendar;
    
    NSDate*   date_   = nil;
    NSInteger result_ = 0  ;
    
    
    date_ = [ ansiFormatter_ dateFromString: @"2012-01-01" ];
    result_ = [ SqlitePersistentDateFormatter halfYearForDate: date_
                                                usingCalendar: posixCalendar_ ]; 
    
    STAssertTrue( 1 == result_, @"H1 expected" ); 
}

-(void)testJune30IsInFirstSeasonStringOutput
{
    NSString* result_ = nil;
    
    result_ = [ [ SqlitePersistentDateFormatter instance ] getYearAndHalfYear: @"2012-06-30" ];
    STAssertTrue( [ result_ isEqualToString: @"H1 '12" ], @"H1 expected" );
}

-(void)testJuly1IsInSecondSeasonStringOutput
{
    NSString* result_ = nil;
    
    result_ = [ [ SqlitePersistentDateFormatter instance ] getYearAndHalfYear: @"2012-07-01" ];
    STAssertTrue( [ result_ isEqualToString: @"H2 '12" ], @"H2 expected" );
}


-(void)testDec31IsInSecondSeasonStringOutput
{
    NSString* result_ = nil;
    
    result_ = [ [ SqlitePersistentDateFormatter instance ] getYearAndHalfYear: @"2011-12-31" ];
    STAssertTrue( [ result_ isEqualToString: @"H2 '11" ], @"H2 expected" );
}

-(void)testJan1IsInFirstSeasonStringOutput
{
    NSString* result_ = nil;
    
    result_ = [ [ SqlitePersistentDateFormatter instance ] getYearAndHalfYear: @"2012-01-01" ];
    STAssertTrue( [ result_ isEqualToString: @"H1 '12" ], @"H1 expected" );
}

@end
