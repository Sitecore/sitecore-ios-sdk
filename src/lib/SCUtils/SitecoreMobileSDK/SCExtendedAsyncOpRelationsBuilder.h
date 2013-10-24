#import <Foundation/Foundation.h>
#import <SitecoreMobileSDK/SCExtendedOperations.h>


@interface SCExtendedAsyncOpRelationsBuilder : NSObject

/**
 Converts operations array to a single operation. The operations will be executed one after another.
 If any operation fails, next ones won't be executed. The error will be returned in the callback.
 On success the callback receives the result of the last operation.
 
 
 @param operations - NSArray of SCExtendedAsyncOp objects
 
 @return a single SCExtendedAsyncOp as a combination
 */
+(SCExtendedAsyncOp)sequence:( NSArray* )operations_;


/**
 Executes operations in array one after another until one of them succeeds.
 
 @param operations - NSArray of SCExtendedAsyncOp objects
 
 @return a single SCExtendedAsyncOp as a combination
 */
+(SCExtendedAsyncOp)stopOnFirstSuccessInSequence:( NSArray* )operations_;


/**
 Converts operations array to a single operation. The operations will be executed in parallel.
 A callback will be called after all operations are finished.
 If any operation fails, next ones will be executed. However, an error of the failed operation will be returned in the callback.
 On success the callback receives an array of single operation results.
 
 @param operations - NSArray of SCExtendedAsyncOp objects
 
 @return a single SCExtendedAsyncOp as a combination
 
 
 [ SCExtendedAsyncOpRelationsBuilder group: @[a, b, c, d, e] ]( nil, nil,
 void^( NSArray* result, NSError* error )
 {
 // when "c" and "e" failed
 // then a, b, d are still running
 // and result == nil
 // error is non determined. It may be either c.error or e.error
 } );
 
 */
+(SCExtendedAsyncOp)group:( NSArray* )operations_;


/**
 Converts operations array to a single operation. The operations will be executed in parallel.
 If any operation fails, others are cancelled immediately. The error will be returned in the callback.
 On success the callback receives an array of single operation results.
 
 @param operations - NSArray of SCExtendedAsyncOp objects
 
 @return a single SCExtendedAsyncOp as a combination
 */
+(SCExtendedAsyncOp)stopOnFirstErrorInGroup:( NSArray* )operations_;



/**
 Converts operations array to a single operation. The operations will be executed one after another. The result of each operation will be passed to the next one.
 If any operation fails, next ones won't be executed. The error will be returned in the callback.
 On success the callback receives the result of the last operation.
 
 
 @param firstOperation - the first operation of SCExtendedAsyncOp type.
 @param chainingCallbacks - NSArray of SCExtendedOpChainUnit. Each of them takes the result of a previous operation and constructs a single SCExtendedAsyncOp
 
 @return a single SCExtendedAsyncOp as a combination
 */
+(SCExtendedAsyncOp)waterfallForOperation:( SCExtendedAsyncOp )firstOperation
                        chainingCallbacks:( NSArray* )chainingCallbacks;


/**
 Converts operations array to a single operation. Executes operations in array one after another until one of them succeeds. Error of each operation is forwarded to the next one until some operation succeeds.
 
 
 @param firstOperation - the first operation of SCExtendedAsyncOp type.
 @param chainingCallbacks - NSArray of SCExtendedOpChainUnit. Each of them takes the result of a previous operation and constructs a single SCExtendedAsyncOp
 
 @return a single SCExtendedAsyncOp as a combination
 */
+(SCExtendedAsyncOp)waterfallUntilSuccessForOperation:( SCExtendedAsyncOp )firstOperation
                                    chainingCallbacks:( NSArray* )chainingCallbacks;

@end
