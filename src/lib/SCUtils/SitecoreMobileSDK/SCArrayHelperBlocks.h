#ifndef SCUTILS_ARRAY_HELPER_BLOCKS_H_INCLUDED
#define SCUTILS_ARRAY_HELPER_BLOCKS_H_INCLUDED

#import <Foundation/Foundation.h>

typedef BOOL (^SCPredicateBlock)(id object);
typedef void (^SCActionBlock)(id object);
typedef id (^SCMappingBlock)(id object);
typedef id (^SCProducerBlock)(NSUInteger index);
typedef NSArray* (^SCFlattenBlock)(id object);

typedef void (^SCTransformBlock)(id firstObject, id secondObject);
typedef BOOL (^SCEqualityCheckerBlock)(id firstObject, id secondObject);

#endif //SCUTILS_ARRAY_HELPER_BLOCKS_H_INCLUDED
