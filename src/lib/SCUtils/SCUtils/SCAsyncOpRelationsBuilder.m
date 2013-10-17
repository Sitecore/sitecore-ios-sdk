#import "SCAsyncOpRelationsBuilder.h"
#import "SCAsyncOpUtils.h"

@implementation SCAsyncOpRelationsBuilder

+(JFFAsyncOperation)jOperationFromSCAsyncOp:( SCAsyncOp )operation_
{
    operation_ = [ operation_ copy ];
    
    return ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                   , JFFCancelAsyncOperationHandler cancelCallback_
                                   , JFFDidFinishAsyncOperationHandler doneCallback_ )
    {
        operation_( doneCallback_ );

        return ^void( BOOL unsubscribeOnlyIfNo_ )
        {
            //IDLE : no cancel available
        };
    };
}

+(NSArray*)operationsToLowLevelOperations:( NSArray* )operations_
{
    NSArray* lowLevelOps_ = [ operations_ map: ^id( id operation_ )
    {
        return [ self jOperationFromSCAsyncOp: operation_ ];
    } ];
    
    return lowLevelOps_;
}

+(SCAsyncOp)group:( NSArray* )operations_
{
    NSArray* lowLevelOps_ = [ self operationsToLowLevelOperations: operations_ ];

    JFFAsyncOperation group_ = groupOfAsyncOperationsArray( lowLevelOps_ );
    return asyncOpWithJAsyncOp( group_ );    
}

+(SCAsyncOp)sequence:( NSArray* )operations_
{
    NSArray* lowLevelOps_ = [ self operationsToLowLevelOperations: operations_ ];
    
    JFFAsyncOperation group_ = sequenceOfAsyncOperationsArray( lowLevelOps_ );
    return  asyncOpWithJAsyncOp ( group_ );
}

+(SCAsyncOp)stopOnFirstSuccessInSequence:( NSArray* )operations
{
    NSArray* lowLevelOps = [ self operationsToLowLevelOperations: operations ];
    JFFAsyncOperation result = trySequenceOfAsyncOperationsArray( lowLevelOps );
    
    return asyncOpWithJAsyncOp( result );
}

+(SCAsyncOp)stopOnFirstErrorInGroup:( NSArray* )operations
{
    NSArray* lowLevelOps = [ self operationsToLowLevelOperations: operations ];
    JFFAsyncOperation result = failOnFirstErrorGroupOfAsyncOperationsArray( lowLevelOps );
    
    return asyncOpWithJAsyncOp( result );
}

+(SCAsyncOp)operationFromExtendedOperation:( SCExtendedAsyncOp )extendedOperation
{
    return asyncOpWithJAsyncOp( extendedOperation );
}


@end
