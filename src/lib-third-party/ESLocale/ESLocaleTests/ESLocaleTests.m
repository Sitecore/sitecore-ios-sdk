#import <ESLocale/ESLocale.h>

#import <SenTestingKit/SenTestingKit.h>

@interface ESLocaleTests : SenTestCase

@end

@implementation ESLocaleTests

-(void)testPosixLocaleIdentifier
{
   NSLocale* result_ = [ ESLocaleFactory posixLocale ];
   STAssertTrue( [ result_.localeIdentifier isEqualToString: @"en_US_POSIX" ], @"locale identifier mismatch" );
}

-(void)testGregCalendarIdentifier
{
   NSCalendar* result_ = [ ESLocaleFactory gregorianCalendar ];
   STAssertTrue( [ result_.calendarIdentifier isEqualToString: NSGregorianCalendar ], @"greg calendar mismatch" );
}

-(void)testPosixCalendarIsGregCalendar
{
   NSCalendar* result_ = [ ESLocaleFactory posixCalendar ];
   STAssertTrue( [ result_.calendarIdentifier isEqualToString: NSGregorianCalendar ], @"greg calendar mismatch" );
}

-(void)testPosixCalendarHasPosixLocale
{
   NSCalendar* result_ = [ ESLocaleFactory posixCalendar ];
   STAssertTrue( [ result_.locale.localeIdentifier isEqualToString: @"en_US_POSIX" ], @"posix calendar locale mismatch" );
}

-(void)testPosixDateFormatterHasPosixLocale
{
   NSDateFormatter* result_ = [ ESLocaleFactory posixDateFormatter ];
   STAssertTrue( [ result_.locale.localeIdentifier isEqualToString: @"en_US_POSIX" ], @"posix formatter locale mismatch" );
}

-(void)testPosixDateFormatterHasPosixCalendar
{
   NSDateFormatter* result_ = [ ESLocaleFactory posixDateFormatter ];

   STAssertTrue( [ result_.calendar.locale.localeIdentifier isEqualToString: @"en_US_POSIX" ], @"posix formatter calendar locale mismatch" );
   STAssertTrue( [ result_.calendar.calendarIdentifier isEqualToString: NSGregorianCalendar ], @"posix formatter calendar mismatch" );
}

@end
