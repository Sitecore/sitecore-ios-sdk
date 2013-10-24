#import "SCExtendedAsyncOpRelationsBuilder.h"

@implementation SCExtendedAsyncOpRelationsBuilder

+(SCExtendedAsyncOp)sequence:( NSArray* )operations_
{
    JFFAsyncOperation group_ = sequenceOfAsyncOperationsArray( operations_ );
    return  group_ ;
}

+(SCExtendedAsyncOp)stopOnFirstSuccessInSequence:( NSArray* )operations_
{
    return trySequenceOfAsyncOperationsArray( operations_ );
}

+(SCExtendedAsyncOp)group:( NSArray* )operations_
{
    return groupOfAsyncOperationsArray( operations_ );
}

+(SCExtendedAsyncOp)stopOnFirstErrorInGroup:( NSArray* )operations_
{
    return failOnFirstErrorGroupOfAsyncOperationsArray( operations_ );
}

+(SCExtendedAsyncOp)waterfallForOperation:( SCExtendedAsyncOp )firstOperation
                        chainingCallbacks:( NSArray* )chainingCallbacks
{
    return bindSequenceOfAsyncOperationsArray( firstOperation, chainingCallbacks );
}

+(SCExtendedAsyncOp)waterfallUntilSuccessForOperation:( SCExtendedAsyncOp )firstOperation
                                    chainingCallbacks:( NSArray* )chainingCallbacks
{
    return bindTrySequenceOfAsyncOperationsArray( firstOperation, chainingCallbacks );
}

@end
