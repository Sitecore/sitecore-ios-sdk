#import "ESLocaleFactory.h"

#import <SenTestingKit/SenTestingKit.h>

@interface DayOfWeekTest : SenTestCase

@end

@implementation DayOfWeekTest

-(void)testUSAWeekStartsOnSunday
{
   NSLocale* usLocale_ = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US" ];
   NSCalendar* usCal_ = [ ESLocaleFactory gregorianCalendarWithLocale: usLocale_ ];

   //(1 == Sunday and 7 == Saturday)
   // http://stackoverflow.com/questions/1106943/nscalendar-first-day-of-week
   STAssertTrue( usCal_.firstWeekday == 1, @"US week should start on Sunday. %d", usCal_.firstWeekday ); 
}

-(void)testRussianWeekStartsOnMonday
{
   NSLocale* ruLocale_ = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"ru_RU" ];
   NSCalendar* ruCal_ = [ ESLocaleFactory gregorianCalendarWithLocale: ruLocale_ ];
   
   STAssertTrue( ruCal_.firstWeekday == 2, @"US week should start on Monday. %d", ruCal_.firstWeekday ); 
}

-(void)test2011_01_02US
{
    NSDate* date_ = [ [ ESLocaleFactory ansiDateFormatter ] dateFromString: @"2011-01-02" ];
    
    NSCalendar* usCal_ = [ ESLocaleFactory gregorianCalendarWithLocaleId: @"en_US" ];    
    NSDateFormatter* df_ = [ NSDateFormatter new ];
    [ ESLocaleFactory setCalendar: usCal_
                 forDateFormatter: df_ ];
    df_.dateFormat = @"YYYY-ww";
    
    NSString* result_ = [ df_ stringFromDate: date_ ];
    NSString* expected_ = @"2011-02";
    STAssertTrue( [ result_ isEqualToString: expected_ ], @"Week mismatch. %@ != %@", result_, expected_ );
}


-(void)test2011_01_02RUS
{
    NSDate* date_ = nil; 
    
    NSCalendar* usCal_ = [ ESLocaleFactory gregorianCalendarWithLocaleId: @"ru_RU" ];    
    NSDateFormatter* df_ = [ NSDateFormatter new ];
    [ ESLocaleFactory setCalendar: usCal_
                 forDateFormatter: df_ ];
    df_.dateFormat = @"YYYY-ww";
    
    NSDateFormatter* ansiFormatter_ = [ ESLocaleFactory ansiDateFormatter ];
    
    
    {
        //!!! Warning !!! Sat. 2011-01-02 is supposed to be in year 2011 in week based calendar
        /*
         cal jan 2011
         January 2011
         
         Su Mo Tu We Th Fr Sa
         1
         2  3  4  5  6  7  8
         9 10 11 12 13 14  15
         16 17 18 19 20 21 22
         23 24 25 26 27 28 29
         30 31    
         */            

        date_ = [ ansiFormatter_ dateFromString: @"2011-01-02" ];
        NSString* result_ = [ df_ stringFromDate: date_ ];
        NSString* expected_ = @"2011-01";
        STAssertTrue( [ result_ isEqualToString: expected_ ], @"Week mismatch. %@ != %@", result_, expected_ );
    }
    
    
    {
        date_ = [ ansiFormatter_ dateFromString: @"2010-12-30" ];
        NSString* result_ = [ df_ stringFromDate: date_ ];
        NSString* expected_ = @"2011-01";
        STAssertTrue( [ result_ isEqualToString: expected_ ], @"Week mismatch. %@ != %@", result_, expected_ );
        
    }
}

-(void)test2010_12_26BelongsTo2010_RUS
{
    NSDate* date_ = nil; 
    
    NSCalendar* usCal_ = [ ESLocaleFactory gregorianCalendarWithLocaleId: @"ru_RU" ];    
    NSDateFormatter* df_ = [ NSDateFormatter new ];
    [ ESLocaleFactory setCalendar: usCal_
                 forDateFormatter: df_ ];
    df_.dateFormat = @"YYYY-ww";
    
    NSDateFormatter* ansiFormatter_ = [ ESLocaleFactory ansiDateFormatter ];
    
    
    {
        date_ = [ ansiFormatter_ dateFromString: @"2010-12-26" ];
        NSString* result_ = [ df_ stringFromDate: date_ ];
        NSString* expected_ = @"2010-52";
        STAssertTrue( [ result_ isEqualToString: expected_ ], @"Week mismatch. %@ != %@", result_, expected_ );
        
    }
}

@end
