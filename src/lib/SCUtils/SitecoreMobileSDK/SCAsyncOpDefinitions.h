#ifndef SC_MONAD_ASYNC_OP_DEFINITIONS_H_INCLUDED
#define SC_MONAD_ASYNC_OP_DEFINITIONS_H_INCLUDED

@class NSError;

typedef void (^SCAsyncOpResult)(id result, NSError *error);
typedef void (^SCAsyncOp)(SCAsyncOpResult handler);

#endif //SC_MONAD_ASYNC_OP_DEFINITIONS_H_INCLUDED
