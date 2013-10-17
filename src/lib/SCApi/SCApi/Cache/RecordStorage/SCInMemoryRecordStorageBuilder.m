#import "SCInMemoryRecordStorageBuilder.h"

#import "SCInMemoryRecordStorage.h"
#import "SCItemSourcePOD.h"

#import "SCItemStorageKinds.h"

@implementation SCInMemoryRecordStorageBuilder

-(SCItemStorageKinds*)newRecordStorageNodeForItemSource:( SCItemSourcePOD* )itemSource
{
    SCItemStorageKinds* result = [ SCItemStorageKinds new ];
    {
        result.itemRecordById = [ [ SCInMemoryRecordStorage alloc ] initWithItemSource: itemSource ];
        result.itemRecordByPath = [ [ SCInMemoryRecordStorage alloc ] initWithItemSource: itemSource ];
    }

    return result;
}

@end
