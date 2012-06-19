#import <Foundation/Foundation.h>

@interface ESLocaleFactory : NSObject

+(NSLocale*)posixLocale;
+(NSCalendar*)gregorianCalendar;


+(NSCalendar*)posixCalendar;
+(NSDateFormatter*)posixDateFormatter;
+(NSDateFormatter*)ansiDateFormatter;


+(NSCalendar*)gregorianCalendarWithLocaleId:( NSString* )localeIdentifier_;
+(NSCalendar*)gregorianCalendarWithLocale:( NSLocale* )locale_;
+(NSDateFormatter*)gregorianDateFormatterWithLocale:( NSLocale* )locale_;

+(void)setCalendar:( NSCalendar* )calendar_
  forDateFormatter:( NSDateFormatter* )result_;

@end
