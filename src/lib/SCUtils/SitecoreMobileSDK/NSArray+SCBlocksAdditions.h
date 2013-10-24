#include <SitecoreMobileSDK/SCArrayHelperBlocks.h>
#import <Foundation/Foundation.h>

@interface NSArray (SCBlocksAdditions)

/**
   Creates a new NSArray of length N containing the values returned by the block.
 
   @param size  - size of the new array
   @param block - a block that builds new objects to fill array with
 
   @return - a new NSArray instance
 */
+(instancetype)arrayWithSize:(NSUInteger)N
                    producer:(SCProducerBlock)block;

/**
Calls block once for each element in self, passing that element as a parameter.
 */
- (void)each:(SCActionBlock)block;

/**
Invokes block once for each element of self.
Creates a new NSArray containing the values returned by the block.
 
 @param block - a block that perfroms the transform of element in this array to element in the new array.
 @return a new NSArray of mapped objects
 
 */
- (NSArray*)map:(SCMappingBlock)block;

/**
 Invokes the block passing in successive elements from self.
 Creates a new NSArray containing all elements of all arrays returned the block.
 
 For example,
 
 NSArray* tree = @[ @[ @1, @2 ], @[ @3, @4 ]  ] ];
 NSArray result = [ tree flatten: ^NSArray*( id element )
 {
    return element;
 } ];
 // returns @[ @1, @2, @3, @4 ]
 */
- (NSArray*)flatten:(SCFlattenBlock)block;


/**
Invokes the block passing in successive elements from self.
Creates a new NSArray containing those elements for which the block returns a YES value.
 
 @param predicate - a predicate. It takes an object and returns YES if the object matches a certain condition.
 @return - a new NSArray of objects that fit predicate requirements
 */
- (NSArray*)select:(SCPredicateBlock)predicate;

/**
Invokes the block passing in successive elements from self, returning a count of those elements for which the block returns a YES value.
 
 @param predicate - a predicate. It takes an object and returns YES if the object matches a certain condition.
 @return - number of objects matching the predicate
 */
- (NSUInteger)count:(SCPredicateBlock)predicate;

/**
 Invokes the block passing in successive elements from self, returning the first element for which the block returns a YES value.
 
 @param predicate - a predicate. It takes an object and returns YES if the object matches a certain condition.
 @return - the first object matching the predicate
 */
- (id)firstMatch:(SCPredicateBlock)predicate;

/**
 Invokes the block passing in successive elements from self, returning an index of the first element for which the block returns a YES value.
 */
- (NSUInteger)firstIndexOfObjectMatch:(SCPredicateBlock)predicate;

/**
 Iterates two arrays simultaneously. Objects with same indices are passed to the block.
 */
- (void)transformWithArray:(NSArray *)other
                 withBlock:(SCTransformBlock)block;

@end
