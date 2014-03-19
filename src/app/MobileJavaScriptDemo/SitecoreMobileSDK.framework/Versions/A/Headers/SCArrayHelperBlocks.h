#ifndef SCUTILS_ARRAY_HELPER_BLOCKS_H_INCLUDED
#define SCUTILS_ARRAY_HELPER_BLOCKS_H_INCLUDED

#import <Foundation/Foundation.h>

/**
 A predicate. It takes an object and returns YES if the object matches a certain condition.
 
 @param object - an object to check 
 @return - YES if object matches the condition
 */
typedef BOOL (^SCPredicateBlock)(id object);

/**
 Performs some action with the given object.
 */
typedef void (^SCActionBlock)(id object);

/**
 Converts an object to some other object.
 For example,

 SCMappingBlock getValue = ^id( SCField* field )
 {
    return field.fieldValue;
 }
 */
typedef id (^SCMappingBlock)(id object);

/**
 A generator to initialize NSArray quickly. For example,
 SCProducerBlock geometryProgression = ^NSNumber*( NSUInteger index )
 {
    return @( index * 3 );
 }
 */
typedef id (^SCProducerBlock)(NSUInteger index);


/**
 A block used to convert some object to array. 
 Similar to SCMappingBlock. Result type is limited to NSArray.
 */
typedef NSArray* (^SCFlattenBlock)(id object);


/**
 Performs some action with the given pair of objects.
 */
typedef void (^SCTransformBlock)(id firstObject, id secondObject);


/**
 Similar to SCPredicateBlock. Uses two objects to check some condition.
 
 @param object - an object to check
 @return - YES if object matches the condition
 */
typedef BOOL (^SCEqualityCheckerBlock)(id firstObject, id secondObject);

#endif //SCUTILS_ARRAY_HELPER_BLOCKS_H_INCLUDED
