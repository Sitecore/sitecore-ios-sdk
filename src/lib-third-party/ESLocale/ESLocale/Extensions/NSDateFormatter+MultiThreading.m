#import "NSDateFormatter+MultiThreading.h"

@implementation NSDateFormatter (MultiThreading)

-(NSString*)synchronizedStringFromDate:(NSDate *)date_
{
    @synchronized( self )
    {
        return [ self stringFromDate: date_ ];
    }
}


-(NSDate*)synchronizedDateFromString:(NSString *)string_
{
    @synchronized( self )
    {
        return [ self dateFromString: string_ ];
    }    
}

@end
