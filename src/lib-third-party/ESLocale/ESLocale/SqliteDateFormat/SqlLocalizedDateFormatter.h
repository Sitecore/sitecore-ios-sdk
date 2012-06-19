#import <Foundation/Foundation.h>

@interface SqlLocalizedDateFormatter : NSObject

-(id)initWithDate:( NSString* )strDate_
           format:( NSString* )format_
           locale:( NSString* )localeIdentifier_;

-(NSString*)getFormattedDate;

@end
