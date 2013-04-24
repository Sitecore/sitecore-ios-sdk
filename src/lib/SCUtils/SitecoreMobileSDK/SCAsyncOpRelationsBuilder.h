#import <Foundation/Foundation.h>
#import <SitecoreMobileSDK/SCAsyncOpDefinitions.h>


@interface SCAsyncOpRelationsBuilder : NSObject

+(SCAsyncOp)groupOfAsyncOperations:( NSArray* )operations_;
+(SCAsyncOp)sequenceOfAsyncOperations:( NSArray* )operations_;

@end
