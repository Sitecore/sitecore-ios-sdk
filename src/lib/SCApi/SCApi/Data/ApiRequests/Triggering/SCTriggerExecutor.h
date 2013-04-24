#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>


@class SCTriggeringRequest;
@class SCTriggeringImplRequest;

@interface SCTriggerExecutor : NSObject

+(JFFAsyncOperation)triggerLoaderWithRequest:( SCTriggeringRequest* )request_
                                        host:(NSString *)host_;

+(JFFAsyncOperation)executeTriggerRequest:( SCTriggeringImplRequest* )request_;

@end
