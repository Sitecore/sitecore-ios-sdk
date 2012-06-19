#import "NSDateComponentsFactory.h"

@implementation NSDateComponentsFactory

+(NSDateComponents*)addSomeMonths:( NSInteger )monthCount_
{
    NSDateComponents* result_ = [ NSDateComponents new ];
    result_.month = monthCount_;
    
    return result_;
}

+(NSDateComponents*)addSomeWeeks:( NSInteger )weekCount_
{
    NSDateComponents* result_ = [ NSDateComponents new ];
    result_.week = weekCount_;
    
    return result_;    
}

+(NSDateComponents*)addSomeQuarters:( NSInteger )quarterCount_
{
    NSInteger monthCount_ = quarterCount_ * 3;
    return [ self addSomeMonths: monthCount_ ];
}

+(NSDateComponents*)addSomeHalfYear:( NSInteger )quarterCount_
{
    // we can assume 6 month as we'll use it only with [ ESLocale posixCalendar ]

    NSInteger monthCount_ = quarterCount_ * 6;
    return [ self addSomeMonths: monthCount_ ];    
}

+(NSDateComponents*)addSomeYears:( NSInteger )yearCount_
{
    NSDateComponents* result_ = [ NSDateComponents new ];
    result_.year = yearCount_;
    
    return result_;  
}

#pragma mark -
#pragma mark instance wrappers

-(NSDateComponents*)addSomeMonths:( NSInteger )monthCount_
{
    return [ [ self class ] addSomeMonths: monthCount_ ];
}

-(NSDateComponents*)addSomeWeeks:( NSInteger )weekCount_
{
    return [ [ self class ] addSomeWeeks: weekCount_ ];
}

-(NSDateComponents*)addSomeQuarters:( NSInteger )quarterCount_
{
    return [ [ self class ] addSomeQuarters: quarterCount_ ];
}

-(NSDateComponents*)addSomeHalfYear:( NSInteger )hYearCount_
{
    return [ [ self class ] addSomeHalfYear: hYearCount_ ];
}

-(NSDateComponents*)addSomeYears:( NSInteger )yearCount_
{
    return [ [ self class ] addSomeYears: yearCount_ ];
}

@end
