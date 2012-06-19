#import <Foundation/Foundation.h>

@interface ESDatesCalculator : NSObject

@property ( nonatomic, assign, readonly ) NSInteger  resolution;
@property ( nonatomic, strong, readonly ) NSDate*    startDate ;
@property ( nonatomic, strong, readonly ) NSDate*    endDate   ;


-(id)initWithResolution:( NSInteger )resolution_
              startDate:( NSDate* )startDate_
                endDate:( NSDate* )endDate_;


-(NSDate*)startOfIntervalWithIndex:( NSInteger )intervalIndex_;
-(NSDate*)endOfIntervalWithIndex:( NSInteger )intervalIndex_;

@end
