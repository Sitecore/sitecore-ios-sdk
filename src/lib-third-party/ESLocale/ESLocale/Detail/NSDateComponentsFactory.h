#import <Foundation/Foundation.h>

@interface NSDateComponentsFactory : NSObject


+(NSDateComponents*)addSomeMonths:( NSInteger )monthCount_;
+(NSDateComponents*)addSomeWeeks:( NSInteger )weekCount_;

+(NSDateComponents*)addSomeQuarters:( NSInteger )quarterCount_;

+(NSDateComponents*)addSomeHalfYear:( NSInteger )hYearCount_;
+(NSDateComponents*)addSomeYears:( NSInteger )yearCount_;


-(NSDateComponents*)addSomeMonths:( NSInteger )monthCount_;
-(NSDateComponents*)addSomeWeeks:( NSInteger )weekCount_;

-(NSDateComponents*)addSomeQuarters:( NSInteger )quarterCount_;

-(NSDateComponents*)addSomeHalfYear:( NSInteger )hYearCount_;
-(NSDateComponents*)addSomeYears:( NSInteger )yearCount_;

@end
