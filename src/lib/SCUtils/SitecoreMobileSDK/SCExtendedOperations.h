#import <Foundation/Foundation.h>
#import <SitecoreMobileSDK/SCUploadProgress.h>

@class NSError;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wtypedef-redefinition"

/**
 This block will be called each time the asynchronous operation completes some of its parts.
 @param progressInfo - some operation dependent progress information. For example, it can be completeness percentage or downloaded data amount.
 */
typedef void (^SCAsyncOperationProgressHandler)(id<SCUploadProgress> progressInfo);

/**
 This will be called after the operation is completed. It is same as SCAsyncOpResult.
 @param result - some operation dependent result object. In most cases it is SCItem, SCField object or NSArray containing one of these.
 @param error - an error that occured while executing an operation.
 
 @warning Either result or error must be nil. The other one must contain a valid object.
 */
typedef void (^SCDidFinishAsyncOperationHandler)(id result, NSError *error);

/**
 Invoke this block if you want to cancel the operation.
 
 @param unsubscribeOnlyIfNo - this flag determines whether the operation is actually going to be cancelled.
 unsubscribeOnlyIfNo == YES  ===> The operation will be cancelled
 unsubscribeOnlyIfNo == NO   ===> The operation will still run in the background but the SCDidFinishAsyncOperationHandler  block will not be called.
 
 @warning You should not construct this kind of blocks manually. All of them should be returned as async operations are launched.
 
 When the operation is cancelled, the SCCancelAsyncOperationHandler block will be called regardless of the unsubscribeOnlyIfNo value.
 */
typedef void (^SCCancelAsyncOperation)(BOOL unsubscribeOnlyIfNo);

/**
 This block is called when the operation is cancelled.
 @param unsubscribeOnlyIfNo - the flag that was used to cancel the operation.
 */
typedef SCCancelAsyncOperation SCCancelAsyncOperationHandler;

/**
 Invoke this block in order to start the asynchronous operation.
 
 @param progressCallback -- This block will be called each time the asynchronous operation completes some of its parts. See SCAsyncOperationProgressHandler for details. Set this block to nil if you do not want getting a notification.
 @param cancelCallback   -- This block is called when the operation is cancelled. See SCCancelAsyncOperation for details. Set this block to nil if you do not want getting a notification.
 @param doneCallback     -- This will be called after the operation is completed. See SCDidFinishAsyncOperationHandler for details. Set this block to nil if you do not want getting a notification.
 
 @return - a block that cancels the given operation when invoked.
 
 */
typedef SCCancelAsyncOperation (^SCExtendedAsyncOp)(SCAsyncOperationProgressHandler progressCallback,
SCCancelAsyncOperationHandler cancelCallback,
SCDidFinishAsyncOperationHandler doneCallback);

/**
 This block builds an asynchronous operation based on the previous operation input.
 This is a unit of the callbacks chain in waterfall operations.
 
 @param result - the result or error of previous async operation execution. It cannot be nil.
 @return - asynchronous operation that will be executed in chain.
 */
typedef SCExtendedAsyncOp (^SCExtendedOpChainUnit)(id result);

#pragma clang diagnostic pop
