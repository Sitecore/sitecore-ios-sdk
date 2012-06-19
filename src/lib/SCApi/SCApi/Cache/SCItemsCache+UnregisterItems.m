#import "SCItemsCache+UnregisterItems.h"

#import "SCItemRecord.h"

@implementation SCItemsCache (UnregisterItems)

-(JFFAsyncOperation)unregisterItemsWithItemsIdsArrayLoader:( JFFAsyncOperation )loader_
{
    JFFAsyncOperationBinder unregisterLoaderBinder_ = ^JFFAsyncOperation( NSArray* itemsIds_ )
    {
        for ( NSString* itemId_ in itemsIds_ )
        {
            JFFMutableAssignArray* itemRecords_ = [ self itemRecordsWithItemId: itemId_ ];
            [ itemRecords_ enumerateObjectsUsingBlock: ^( SCItemRecord* itemRecord_, NSUInteger idx_, BOOL* stop_ )
            {
                [ itemRecord_ unregisterFromCacheItemAndChildren: YES ];
            } ];
        }
        return asyncOperationWithResult( itemsIds_ );
    };

    return bindSequenceOfAsyncOperations( loader_, unregisterLoaderBinder_, nil );
}

@end
