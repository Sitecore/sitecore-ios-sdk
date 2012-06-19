#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import "SCItemsCache.h"

@interface SCItemsCache (UnregisterItems)

-(JFFAsyncOperation)unregisterItemsWithItemsIdsArrayLoader:( JFFAsyncOperation )loader_;

@end
