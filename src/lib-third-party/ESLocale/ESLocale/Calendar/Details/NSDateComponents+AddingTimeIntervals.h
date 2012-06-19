#import <Foundation/Foundation.h>

@interface NSDateComponents (AddingTimeIntervals)

+(id)dayComponentsWithTimeInterval:( NSInteger )interval_;

+(id)weekComponentsWithTimeInterval:( NSInteger )interval_;

+(id)monthComponentsWithTimeInterval:( NSInteger )interval_;

+(id)quarterComponentsWithTimeInterval:( NSInteger )interval_;

+(id)halfYearComponentsWithTimeInterval:( NSInteger )interval_;

+(id)yearAlignComponentsWithTimeInterval:( NSInteger )interval_;

@end
