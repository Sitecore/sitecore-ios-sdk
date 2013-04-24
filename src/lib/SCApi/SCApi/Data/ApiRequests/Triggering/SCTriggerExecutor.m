#import "SCTriggerExecutor.h"

#import "SCTriggeringImplRequest.h"
#import "SCTriggeringRequest+Factory.h"

#import "NSURL+URLWithItemsReaderRequest.h"
#import "SCTriggeringError+PrivateConstructor.h"
#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import "SCError.h"

@implementation SCTriggerExecutor

+(JFFAsyncOperation)triggerLoaderWithRequest:( SCTriggeringRequest* )request_
                                        host:(NSString *)host_
{
    SCTriggeringImplRequest *implRequest_ = [ request_ getImplRequestWithHost:host_ ];
    
    return [ self executeTriggerRequest: implRequest_ ];
}

+(JFFAsyncOperation)executeTriggerRequest:( SCTriggeringImplRequest* )request_
{
    NSURL* url_ = [ NSURL URLToTriggerAction: request_.itemPath
                                   paramName: request_.actionType
                                  paramValue: request_.actionValue ];

    JFFAsyncOperation rendering = dataURLResponseLoader( url_, nil, nil );
    
    
       JFFDidFinishAsyncOperationHook parserAndErrorFix =
       ^void(NSData *result, NSError *error, JFFDidFinishAsyncOperationHandler doneCallback)
       {
           NSLog( @"[DONE] : Triggering item [%@] \n with event [%@] \n by URL [%@]", request_.itemPath, request_.actionValue, url_ );
           
           if ( nil != result )
           {
               NSParameterAssert( nil == error );
               NSString* parsedResult = [ [ NSString alloc ] initWithData: result
                                                                 encoding: NSUTF8StringEncoding ];
               doneCallback( parsedResult, nil );
    
               return;
           }
           
           NSParameterAssert( nil == result );
           NSParameterAssert( nil != error  );
           SCTriggeringError* newError = [ [ SCTriggeringError alloc ] initWithTriggerRequest: request_
                                                                              underlyingError: error ];
           doneCallback( nil, newError );
       };
    
       JFFAsyncOperation result = asyncOperationWithFinishHookBlock ( rendering, parserAndErrorFix );
    
    return result;
}
    
@end
