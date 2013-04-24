#import "SCTriggeringRequest+Factory.h"

@implementation SCTriggeringRequest (Factory)

-(SCTriggeringImplRequest *)getImplRequestWithHost:( NSString * )host_
{
    NSAssert( NO, @"override in child class");
    return nil;
}

@end
