#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>
#import <Foundation/Foundation.h>

@protocol SCItemRecordCache;
@protocol SCItemSource;

@interface SCItemsCacheOperationsFactory : NSObject

+(JFFAsyncOperation)unregisterItemsWithItemsIdsArrayLoader:( JFFAsyncOperation )loader_
                                                 fromCache:( id<SCItemRecordCache> )cache_
                                            fromItemSource:( id<SCItemSource> )itemSource_;

@end
