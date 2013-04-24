#import "SCError.h"

@class SCTriggeringImplRequest;

@interface SCTriggeringError (PrivateConstructor)

@property (nonatomic) NSString *itemPath;
@property (nonatomic) NSString *actionType;
@property (nonatomic) NSString *actionValue;
@property (nonatomic) NSError  *underlyingError;

-(id)initWithTriggerRequest:( SCTriggeringImplRequest* )request
            underlyingError:( NSError * )error;

@end
