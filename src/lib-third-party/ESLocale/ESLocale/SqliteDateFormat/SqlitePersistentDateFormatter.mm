#import "SqlitePersistentDateFormatter.h"

#import "ESLocaleFactory.h"

#include <utility>

typedef std::pair<NSInteger, NSInteger> ESDateComponentsPair;
typedef ESDateComponentsPair(^ESComponentsForDate)( NSDate* );

typedef std::pair<NSInteger, NSInteger> ESYearAndQuarter ;
typedef std::pair<NSInteger, NSInteger> ESYearAndHalfYear;

#define QUARTER_UNIT_DOES_NOT_WORK

static const NSInteger yearAndQuarterMask_ = NSQuarterCalendarUnit | 
                                             NSYearCalendarUnit    ;

static const NSInteger yearMonthMask_ = NSYearCalendarUnit  | 
                                        NSMonthCalendarUnit ;

static SqlitePersistentDateFormatter* instance_ = nil;


@implementation SqlitePersistentDateFormatter
{
@private
    NSDateFormatter* _ansiFormatter  ;
    NSDateFormatter* _targetFormatter;
    NSCalendar*      _targetCalendar ;
}

@synthesize validateLocale ;
@synthesize checkSameLocale;

#pragma mark -
#pragma mark Singletone
+(SqlitePersistentDateFormatter*)instance
{
    if ( nil == instance_ )
    {
        @synchronized ( self )
        {
            if ( nil == instance_ )
            {
                instance_ = [ SqlitePersistentDateFormatter new ];
            }
        }
    }

    return instance_;
}

+(void)freeInstance
{
    @synchronized ( self )
    {
        instance_ = nil;
    }
}

-(id)init
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }

    self->_ansiFormatter = [ ESLocaleFactory ansiDateFormatter ];

    return self;
}

#pragma mark -
#pragma mark LazyLoad
-(BOOL)setFormat:( NSString* )dateFormat_
          locale:( NSString* )locale_
{
    NSParameterAssert( nil != locale_ );

    BOOL isNoFormatter_ = ( nil == self->_targetFormatter );
    BOOL isOtherLocale_ = NO;
    if ( self.checkSameLocale )
    {
        isOtherLocale_ = ![ self->_targetFormatter.locale.localeIdentifier isEqualToString: locale_ ];
    }

    if ( isNoFormatter_ || isOtherLocale_ )
    {
        if ( self.validateLocale ) 
        {
            NSArray* validlocaleIdentifiers_ = [ NSLocale availableLocaleIdentifiers ];
            if ( ![ validlocaleIdentifiers_ containsObject: locale_ ] )
            {
                NSLog( @"Invalid locale error" );
                return NO;
            }
        }        

        self->_targetCalendar = [ ESLocaleFactory gregorianCalendarWithLocaleId: locale_ ];       

        self->_targetFormatter = [ NSDateFormatter new ];
        [ ESLocaleFactory setCalendar: self->_targetCalendar 
                     forDateFormatter: self->_targetFormatter ];  
    }

    if ( nil != dateFormat_ )
    {
        self->_targetFormatter.dateFormat = dateFormat_;
    }

    return YES;
}

+(NSInteger)halfYearForDate:( NSDate* )date_
              usingCalendar:( NSCalendar* )calendar_
{
    // This class must not throw ever
    if ( nil == date_ ) 
    {
        return -1;
    }
    else if ( nil == calendar_ )
    {
        return -2;
    }


    NSDateComponents* dateComp_ = [ calendar_ components: yearMonthMask_ 
                                                fromDate: date_ ];
    

    // Gregorian calendar hard code
    
    static const NSInteger june_ = 6;
    if ( dateComp_.month <= june_ )
    {
        return 1;
    }
    else 
    {
        return 2;
    }

    return 0;
}


#pragma mark -
#pragma mark Getters
-(NSString*)getFormattedDate:( NSString* )strDate_
{
    NSDate*   date_   = [ self->_ansiFormatter   dateFromString: strDate_ ];
    NSString* result_ = [ self->_targetFormatter stringFromDate: date_    ];

    return result_;
}


-(ESYearAndQuarter)getRawYearAndQuarter:( NSDate* )date_
{
    // http://openradar.appspot.com/9270112       
    //    NSQuarterCalendarUnit does not work
    //Originator:	victor.jalencas	
    //Number:	rdar://9270112	Date Originated:	2011-04-12
    //Status:	Open	Resolved:	
    //Product:	iPhone SDK	Product Version:	4.2
    //Classification:	Other bug	Reproducible:	Always        
#ifdef QUARTER_UNIT_DOES_NOT_WORK
    
    //gregorian calendar hard code
    NSDateComponents* result_ = [ self->_targetCalendar components: yearMonthMask_ 
                                                          fromDate: date_ ];    
    
    
    static const NSInteger monthsInQuarter_ = 3;
    NSInteger quarter_ = (result_.month - 1) / monthsInQuarter_;
    NSInteger quarterStartingWithOne_ = 1 + quarter_;    
#else
    NSDateComponents* result_ = [ self->targetCalendar components: yearAndQuarterMask_ 
                                                         fromDate: date_ ];
    
    NSInteger quarterStartingWithOne_ = 1 + result_.quarter;
#endif


    ESYearAndQuarter ret_;
    ret_.first = result_.year;
    ret_.second = quarterStartingWithOne_;

    return ret_;
}

-(ESYearAndHalfYear)getRawYearAndHalfYear:( NSDate* )date_
{
    NSInteger hYear_ = [ [ self class ] halfYearForDate: date_ 
                                          usingCalendar: self->_targetCalendar ];

    NSDateComponents* result_ = [ self->_targetCalendar components: NSYearCalendarUnit 
                                                          fromDate: date_ ];

    ESYearAndHalfYear ret_;
    ret_.first = result_.year;
    ret_.second = hYear_;

    return ret_;
}

-(NSString*)stringFromDate:( NSDate* )date_
         componentsForDate:( ESComponentsForDate )componentsForDate_
                dateFormat:( NSString* )dateFormat_

{
    ESYearAndQuarter result_ = componentsForDate_( date_ );
    return [ NSString stringWithFormat: dateFormat_
            , result_.first
            , result_.second ];
}

-(NSString*)stringFromStrDate:( NSString* )strDate_
            componentsForDate:( ESComponentsForDate )componentsForDate_
                   dateFormat:( NSString* )dateFormat_
{
    NSDate* date_ = [ self->_ansiFormatter dateFromString: strDate_ ];
    if ( nil == date_ )
    {
        return nil;
    }
    return [ self stringFromDate: date_
               componentsForDate: componentsForDate_
                      dateFormat: dateFormat_ ];
}

-(NSString*)getYearAndQuarter:( NSString* )strDate_
{
    ESComponentsForDate componentsForDate_ = ^ESDateComponentsPair( NSDate* date_ )
    {
        ESYearAndQuarter result_ = [ self getRawYearAndQuarter: date_ ];
        NSInteger shortYear_ = result_.first % 100;
        return std::make_pair( result_.second, shortYear_ );
    };

    return [ self stringFromStrDate: strDate_
                  componentsForDate: componentsForDate_
                         dateFormat: @"Q%d '%02d" ];
}

-(NSString*)getYearAndHalfYear:( NSString* )strDate_
{
    ESComponentsForDate componentsForDate_ = ^ESDateComponentsPair( NSDate* date_ )
    {
        ESYearAndHalfYear result_ = [ self getRawYearAndHalfYear: date_ ];
        NSInteger shortYear_ = result_.first % 100;
        return std::make_pair( result_.second, shortYear_ );
    };

    return [ self stringFromStrDate: strDate_
                  componentsForDate: componentsForDate_
                         dateFormat: @"H%d '%02d" ];
}

-(NSString*)getHalfYearAndFullYearFromDate:( NSDate* )date_
{
    ESComponentsForDate componentsForDate_ = ^ESDateComponentsPair( NSDate* date_ )
    {
        ESYearAndHalfYear result_ = [ self getRawYearAndHalfYear: date_ ];
        return std::make_pair( result_.second, result_.first );
    };

    return [ self stringFromDate: date_
               componentsForDate: componentsForDate_
                      dateFormat: @"H%d '%d" ];
}

-(NSString*)getQuarterAndFullYearFromDate:( NSDate* )date_  //throw()
{
    ESComponentsForDate componentsForDate_ = ^ESDateComponentsPair( NSDate* date_ )
    {
        ESYearAndQuarter result_ = [ self getRawYearAndQuarter: date_ ];
        return std::make_pair( result_.second, result_.first );
    };

    return [ self stringFromDate: date_
               componentsForDate: componentsForDate_
                      dateFormat: @"Q%d %d" ];
}

-(NSString*)getQuarterAndFullYear:( NSString* )strDate_  //throw()
{
    NSDate* date_ = [ self->_ansiFormatter dateFromString: strDate_ ];
    return [ self getQuarterAndFullYearFromDate: date_ ];
}

-(NSString*)getFullYearAndHalfYear:( NSString* )strDate_ //throw()
{
    ESComponentsForDate componentsForDate_ = ^ESDateComponentsPair( NSDate* date_ )
    {
        return [ self getRawYearAndHalfYear: date_ ];
    };

    return [ self stringFromStrDate: strDate_
                  componentsForDate: componentsForDate_
                         dateFormat: @"%d-%d" ];
}

@end
