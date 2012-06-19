#import <Foundation/Foundation.h>

@interface NSDateFormatter (MultiThreading)

-(NSString*)synchronizedStringFromDate:(NSDate *)date_;
-(NSDate*)synchronizedDateFromString:(NSString *)string_;


@end
