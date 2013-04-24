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

+(SCAsyncOp)groupOfAsyncOperations:( NSArray* )operations_
{
    NSArray* lowLevelOps_ = [ operations_ map: ^id( id operation_ )
    {
        return [ self jOperationFromSCAsyncOp: operation_ ];
    } ];

    JFFAsyncOperation group_ = groupOfAsyncOperationsArray( lowLevelOps_ );
    return asyncOpWithJAsyncOp( group_ );    
}

+(SCAsyncOp)sequenceOfAsyncOperations:( NSArray* )operations_
{
    NSArray* lowLevelOps_ = [ operations_ map: ^id( id operation_ )
    {
        return [ self jOperationFromSCAsyncOp: operation_ ];
    } ];
    
    JFFAsyncOperation group_ = sequenceOfAsyncOperationsArray( lowLevelOps_ );
    return asyncOpWithJAsyncOp( group_ );
}

@end
