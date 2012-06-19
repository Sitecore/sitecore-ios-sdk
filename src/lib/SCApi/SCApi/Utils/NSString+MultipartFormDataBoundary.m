#import "NSString+MultipartFormDataBoundary.h"

@implementation NSString (MultipartFormDataBoundary)

+(NSString*)multipartFormDataBoundary
{
    long long timeInMilliSeconds_ = (long long)floor( [ [ NSDate new ] timeIntervalSince1970 ] * 1000. );
    return [ self stringWithFormat: @"----------------------------%d"
            , timeInMilliSeconds_ ];
}

@end
