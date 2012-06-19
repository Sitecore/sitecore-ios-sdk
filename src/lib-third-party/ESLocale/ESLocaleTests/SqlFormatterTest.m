#import "ESLocaleFactory.h"
#import "SqlLocalizedDateFormatter.h"

#import <SenTestingKit/SenTestingKit.h>

@interface SqlFormatterTest : SenTestCase

@end

@implementation SqlFormatterTest

-(void)test2011_01_02US
{
    SqlLocalizedDateFormatter* fmt_ = [ [ SqlLocalizedDateFormatter alloc ] initWithDate: @"2011-01-02"
                                                                                  format: @"YYYY-ww"
                                                                                  locale: @"en_US" ];    
    NSString* result_ = [ fmt_ getFormattedDate ];
    NSString* expected_ = @"2011-02";
    STAssertTrue( [ result_ isEqualToString: expected_ ], @"Week mismatch. %@ != %@", result_, expected_ );
}


-(void)test2011_01_02RUS
{
    {
        SqlLocalizedDateFormatter* fmt_ = [ [ SqlLocalizedDateFormatter alloc ] initWithDate: @"2011-01-02"
                                                                                      format: @"YYYY-ww"
                                                                                      locale: @"ru_RU" ];    
        NSString* result_ = [ fmt_ getFormattedDate ];
        NSString* expected_ = @"2011-01";
        STAssertTrue( [ result_ isEqualToString: expected_ ], @"Week mismatch. %@ != %@", result_, expected_ );
    }


    {
        SqlLocalizedDateFormatter* fmt_ = [ [ SqlLocalizedDateFormatter alloc ] initWithDate: @"2010-12-30"
                                                                                      format: @"YYYY-ww"
                                                                                      locale: @"ru_RU" ];    
        NSString* result_ = [ fmt_ getFormattedDate ];
        NSString* expected_ = @"2011-01";
        STAssertTrue( [ result_ isEqualToString: expected_ ], @"Week mismatch. %@ != %@", result_, expected_ );
    }
}

-(void)test2010_12_26BelongsTo2010_RUS
{
    SqlLocalizedDateFormatter* fmt_ = [ [ SqlLocalizedDateFormatter alloc ] initWithDate: @"2010-12-26"
                                                                                  format: @"YYYY-ww"
                                                                                  locale: @"ru_RU" ];    
    NSString* result_ = [ fmt_ getFormattedDate ];
    NSString* expected_ = @"2010-52";
    STAssertTrue( [ result_ isEqualToString: expected_ ], @"Week mismatch. %@ != %@", result_, expected_ );
}

-(void)testFormatterRejectsInit
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    STAssertThrows
    (
        [ [ SqlLocalizedDateFormatter alloc ] init ],
        @"Unexpected init"
    );
#pragma clang diagnostic pop
}

-(void)testFormatterRejectsNilInput
{
    SqlLocalizedDateFormatter* result_ = nil;
    
    
    result_ = [ [ SqlLocalizedDateFormatter alloc ] initWithDate: nil
                                                          format: @"YYYY-ww"
                                                          locale: @"ru_RU" ];
    STAssertNil( result_, @"nil input should not be valid" );
    
    
    result_ = [ [ SqlLocalizedDateFormatter alloc ] initWithDate: @"2011-01-02"
                                                          format: nil
                                                          locale: @"ru_RU" ];
    STAssertNil( result_, @"nil input should not be valid" );
    
    
    result_ = [ [ SqlLocalizedDateFormatter alloc ] initWithDate: @"2011-01-02"
                                                          format: @"YYYY-ww"
                                                          locale: nil ];
    STAssertNil( result_, @"nil input should not be valid" );
}

@end
