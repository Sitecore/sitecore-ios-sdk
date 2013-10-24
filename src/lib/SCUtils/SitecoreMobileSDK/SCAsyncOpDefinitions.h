#ifndef SC_MONAD_ASYNC_OP_DEFINITIONS_H_INCLUDED
#define SC_MONAD_ASYNC_OP_DEFINITIONS_H_INCLUDED

@class NSError;

/**
 This will be called after the operation is completed. It is same as SCDidFinishAsyncOperationHandler.
 @param result - some operation dependent result object. In most cases it is SCItem, SCField object or NSArray containing one of these.
 @param error - an error that occured while executing an operation.
 
 @warning Either result or error must be nil. The other one must contain a valid object.
 */
typedef void (^SCAsyncOpResult)(id result, NSError *error);


/**
 Invoke this block in order to start the asynchronous operation. This is a simplified version of SCExtendedAsyncOp. It has no cancellation and progress support.
 
 @param handler - This will be called after the operation is completed. See SCAsyncOpResult for details. Set this block to nil if you do not want getting a notification.
 */
typedef void (^SCAsyncOp)(SCAsyncOpResult handler);

#endif //SC_MONAD_ASYNC_OP_DEFINITIONS_H_INCLUDED
