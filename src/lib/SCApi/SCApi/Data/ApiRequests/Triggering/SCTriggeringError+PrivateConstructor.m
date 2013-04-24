#import "SCTriggeringError+PrivateConstructor.h"

#import "SCTriggeringImplRequest.h"

@implementation SCTriggeringError (PrivateConstructor)

@dynamic itemPath;
@dynamic actionType;
@dynamic actionValue;
@dynamic underlyingError;

-(id)initWithTriggerRequest:( SCTriggeringImplRequest* )request
            underlyingError:( NSError * )error
{
    self = [super init];
    
    NSAssert( [ request isMemberOfClass: [ SCTriggeringImplRequest class ] ], @"wrong param type");
    
    if ( nil == self )
    {
        return nil;
    }

    self.itemPath    = request.itemPath   ;
    self.actionType  = request.actionType ;
    self.actionValue = request.actionValue;
    self.underlyingError = error;
    
    return self;
}


@end
