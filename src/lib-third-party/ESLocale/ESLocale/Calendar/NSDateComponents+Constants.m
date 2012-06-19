#import "NSDateComponents+Constants.h"

@implementation NSDateComponents (Constants)

+(NSDateComponents*)getAddOneDayComponents
{
    static NSDateComponents* addOneDay_;

    static dispatch_once_t onceToken_;
    dispatch_once( &onceToken_, ^
    {
        addOneDay_ = [ NSDateComponents new ];
        addOneDay_.day = 1;
    } );

    return addOneDay_;
}

+(NSDateComponents*)getSubtractOneDayComponents
{
    static NSDateComponents* subtractOneDay_;

    static dispatch_once_t onceToken_;
    dispatch_once( &onceToken_, ^
    {
        subtractOneDay_ = [ NSDateComponents new ];
        subtractOneDay_.day = -1;
    } );

    return subtractOneDay_;
}

+(NSDateComponents*)getAddSomeDaysComponents:( NSUInteger )daysCount_;
{
    NSDateComponents* result_ = [ [ self getAddOneDayComponents ] copy ];
    result_.day *= daysCount_;

    return result_;
}

@end
