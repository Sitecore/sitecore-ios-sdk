#include <SitecoreMobileSDK/SCArrayHelperBlocks.h>
#import <Foundation/Foundation.h>

@interface NSArray (SCBlocksAdditions)

//Calls block once for number from 0(zero) to (size_ - 1)
//Creates a new NSArray containing the values returned by the block.
+ (id)arrayWithSize:(NSUInteger)size
           producer:(SCProducerBlock)block;

//Calls block once for each element in self, passing that element as a parameter.
- (void)each:(SCActionBlock)block;

//Invokes block once for each element of self.
//Creates a new NSArray containing the values returned by the block.
- (NSArray*)map:(SCMappingBlock)block;

//Invokes the block passing in successive elements from self,
//Creates a new NSArray containing those elements for which the block returns a YES value 
- (NSArray*)select:(SCPredicateBlock)predicate;

//Invokes the block passing in successive elements from self,
//Creates a new NSArray containing all elements of all arrays returned the block
- (NSArray*)flatten:(SCFlattenBlock)block;

//Invokes the block passing in successive elements from self,
//returning a count of those elements for which the block returns a YES value 
- (NSUInteger)count:(SCPredicateBlock)predicate;

//Invokes the block passing in successive elements from self,
//returning the first element for which the block returns a YES value 
- (id)firstMatch:(SCPredicateBlock)predicate;

- (NSUInteger)firstIndexOfObjectMatch:(SCPredicateBlock)predicate;

//Invokes the block passing parallel in successive elements from self and other NSArray,
- (void)transformWithArray:(NSArray *)other
                 withBlock:(SCTransformBlock)block;

@end
