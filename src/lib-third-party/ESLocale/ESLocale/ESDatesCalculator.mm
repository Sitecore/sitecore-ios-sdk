#import "ESDatesCalculator.h"

#import "ESLocaleFactory.h"
#import "NSDateComponentsFactory.h"

#import <objc/message.h>
#include <vector>


@implementation ESDatesCalculator
{
@private
    NSInteger _resolution;
    NSDate*   _startDate ;
    NSDate*   _endDate   ;
    
@private
    std::vector<SEL> _dateComponentSelectors;
}

@synthesize resolution = _resolution;
@synthesize startDate  = _startDate ;
@synthesize endDate    = _endDate   ;


#pragma mark - 
#pragma mark init
-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithResolution:( NSInteger )resolution_
              startDate:( NSDate* )startDate_
                endDate:( NSDate* )endDate_
{
    BOOL resolutionOk_ = ( 0 != resolution_  );
    BOOL startDateOk_  = ( nil != startDate_ );
    BOOL endDateOk_    = ( nil != endDate_   );
    BOOL dateRangeOk_  = ( NSOrderedDescending != [ startDate_ compare: endDate_ ] );

    NSParameterAssert( resolutionOk_ );
    NSParameterAssert( startDateOk_  );
    NSParameterAssert( endDateOk_    );
    NSParameterAssert( dateRangeOk_  );
    if ( !resolutionOk_ || !startDateOk_ || !endDateOk_ || !dateRangeOk_ )
    {
        return nil;
    }
    

    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }

    self->_resolution = resolution_;
    self->_startDate  = startDate_ ;
    self->_endDate    = endDate_   ;
    
    self->_dateComponentSelectors.push_back( NULL );
    self->_dateComponentSelectors.push_back( @selector(addSomeMonths:) );
    self->_dateComponentSelectors.push_back( @selector(addSomeWeeks:) );
    self->_dateComponentSelectors.push_back( @selector(addSomeQuarters:) );
    self->_dateComponentSelectors.push_back( @selector(addSomeHalfYear:) );
    self->_dateComponentSelectors.push_back( @selector(addSomeYears:) );

    return self;
}


#pragma mark - 
#pragma mark Busyness logic
-(NSDate*)startOfIntervalWithIndex:( NSInteger )intervalIndex_
{
    size_t castedIntervalIndex_ = static_cast<size_t>(intervalIndex_);
    if ( castedIntervalIndex_ >= self->_dateComponentSelectors.size() )
    {
        return nil;
    }
    
    SEL selector_ = self->_dateComponentSelectors[castedIntervalIndex_];
    NSDateComponents* diff_ = objc_msgSend( [ NSDateComponentsFactory new ], selector_, intervalIndex_ );


    NSCalendar* cal_ = [ ESLocaleFactory posixCalendar ];
    NSDate* result_ = [ cal_ dateByAddingComponents: diff_ 
                                             toDate: self->_startDate 
                                            options: 0 ];
    
    return result_;
}

-(NSDate*)endOfIntervalWithIndex:( NSInteger )intervalIndex_
{
    NSInteger nextIndex_ = intervalIndex_ + 1;
    if ( nextIndex_ < 0 )
    {
        return nil;
    }

    NSDateComponents* subtractOneDay_ = [ NSDateComponents new ];
    subtractOneDay_.day = -1;

    NSDate* nextIntervalStart_ = [ self startOfIntervalWithIndex: nextIndex_ ];
    NSCalendar* cal_ = [ ESLocaleFactory posixCalendar ];
    NSDate* result_ = [ cal_ dateByAddingComponents: subtractOneDay_
                                             toDate: nextIntervalStart_
                                            options: 0 ];
    
    
    return result_;    
}

@end
