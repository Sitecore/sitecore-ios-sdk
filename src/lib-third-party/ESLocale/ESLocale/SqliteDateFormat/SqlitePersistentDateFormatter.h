#import <Foundation/Foundation.h>

@interface SqlitePersistentDateFormatter : NSObject

+(SqlitePersistentDateFormatter*)instance;
+(void)freeInstance;

@property ( nonatomic, assign ) BOOL validateLocale ;
@property ( nonatomic, assign ) BOOL checkSameLocale;

-(BOOL)setFormat:( NSString* )dateFormat_
          locale:( NSString* )locale_;

-(NSString*)getFormattedDate:( NSString* )strDate_;   //throw()
-(NSString*)getYearAndQuarter:( NSString* )strDate_;  //throw()
-(NSString*)getYearAndHalfYear:( NSString* )strDate_; //throw()

-(NSString*)getHalfYearAndFullYearFromDate:( NSDate* )date_; //throw()

+(NSInteger)halfYearForDate:( NSDate* )date_
              usingCalendar:( NSCalendar* )calendar_; //throw()

-(NSString*)getQuarterAndFullYearFromDate:( NSDate* )date_;  //throw()
-(NSString*)getQuarterAndFullYear:( NSString* )strDate_;  //throw()

-(NSString*)getFullYearAndHalfYear:( NSString* )strDate_; //throw()


@end
