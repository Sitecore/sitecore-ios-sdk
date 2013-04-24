#import "SCTriggeringRequest.h"

@class SCTriggeringImplRequest;

@interface SCTriggeringRequest (Factory)

-(SCTriggeringImplRequest *)getImplRequestWithHost:( NSString * )host_;

@end
