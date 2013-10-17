#import "SCItemsCacheOperationsFactory.h"

#import "SCItemSourcePOD.h"
#import "SCItemRecordCache.h"
#import "SCMutableItemRecordCache.h"
#import "SCItemSource.h"

#import "SCItemRecord.h"

@implementation SCItemsCacheOperationsFactory

+(JFFAsyncOperation)unregisterItemsWithItemsIdsArrayLoader:( JFFAsyncOperation )loader_
                                                 fromCache:(id<SCItemRecordCache>)cache_
                                            fromItemSource:( id<SCItemSource> )itemSource_
{
    SCItemSourcePOD* plainSource = [ itemSource_ toPlainStructure ];
    
    JFFAsyncOperationBinder unregisterLoaderBinder_ = ^JFFAsyncOperation( NSArray* itemsIds_ )
    {
        for ( NSString* itemId_ in itemsIds_ )
        {
            SCItemRecord* itemRecord = [ cache_ itemRecordForItemWithId: itemId_
                                                             itemSource: plainSource ];

            [ itemRecord unregisterFromCacheItemAndChildren: YES ];
        }
        return asyncOperationWithResult( itemsIds_ );
    };
    
    return bindSequenceOfAsyncOperations( loader_, unregisterLoaderBinder_, nil );
}


@end
