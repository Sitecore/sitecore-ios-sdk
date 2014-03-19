#import <SitecoreMobileSDK/SCAsyncOpDefinitions.h>
#import <SitecoreMobileSDK/SCExtendedOperations.h>

#import <Foundation/Foundation.h>



@interface SCAsyncOpRelationsBuilder : NSObject


/**
 Converts an extended operation to a simplified one by currying progress and cancel callbacks.
 
 @param extendedOperation - an operation with progress, cancel and completion callbacks.
 @return - an operation with completion callback only.
 */
+(SCAsyncOp)operationFromExtendedOperation:( SCExtendedAsyncOp )extendedOperation;

/**
 Converts operations array to a single operation. The operations will be executed one after another.
 If any operation fails, next ones won't be executed. The error will be returned in the callback.
 On success the callback receives the result of the last operation.
 
 
 @param operations - NSArray of SCAsyncOp objects
 
 @return a single SCAsyncOp as a combination
*/
+(SCAsyncOp)sequence:( NSArray* )operations;


/**
 Executes operations in array one after another until one of them succeeds.
 
 @param operations - NSArray of SCAsyncOp objects

 @return a single SCAsyncOp as a combination
 */
+(SCAsyncOp)stopOnFirstSuccessInSequence:( NSArray* )operations;


/**
 Converts operations array to a single operation. The operations will be executed in parallel.
 A callback will be called after all operations are finished.
 If any operation fails, next ones will be executed. However, an error of the failed operation will be returned in the callback.
 On success the callback receives an array of single operation results.
 
 @param operations - NSArray of SCAsyncOp objects
 
 @return a single SCAsyncOp as a combination
 
 
 [ SCAsyncOpRelationsBuilder group: @[a, b, c, d, e] ](
 void^( NSArray* result, NSError* error )
 {
    // when "c" and "e" failed
    // then a, b, d are still running
    // and result == nil
    // error is non determined. It may be either c.error or e.error
 } );
 
 */
+(SCAsyncOp)group:( NSArray* )operations;


/**
 Converts operations array to a single operation. The operations will be executed in parallel.
 If any operation fails, others are cancelled immediately. The error will be returned in the callback.
 On success the callback receives an array of single operation results.
 
 @param operations - NSArray of SCAsyncOp objects
 
 @return a single SCAsyncOp as a combination
 */
+(SCAsyncOp)stopOnFirstErrorInGroup:( NSArray* )operations;

@end
