#import "SCDateField.h"

@implementation SCDateField

@dynamic fieldValue;

-(id)createFieldValue
{
    NSString* rawValue = self.rawValue;
    if ( ![ rawValue hasSymbols ] )
    {
        return [ NSNull null ];
    }
    
    
    NSTimeZone* utc_ = [ NSTimeZone timeZoneWithAbbreviation: @"UTC" ];
    NSLocale* posixLocale_ = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    NSCalendar* cal_ = nil;
    {
        cal_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
        [ cal_ setLocale: posixLocale_ ];
    }


    NSDateFormatter* formatter_ = [ NSDateFormatter new ];
    {
        [ formatter_ setDateFormat: @"yyyyMMdd'T'HHmmss" ];
        [ formatter_ setLocale: posixLocale_ ];
        [ formatter_ setCalendar: cal_ ];
        [ formatter_ setTimeZone: utc_ ];
    }

    return [ formatter_ dateFromString: self.rawValue ];
}

@end
