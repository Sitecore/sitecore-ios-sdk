#import "SCReadItemsRequest+AllFields.h"

#import "SCItemRecord.h"
#import "SCReadItemsScopeType.h"

@implementation SCReadItemsRequest (AllFields)

-(BOOL)isAllFieldsRequested
{
    return ( nil == self.fieldNames );
}

-(NSUInteger)indexOfFirstChildItemInResponse
{
    SCReadItemScopeType myScope = self.scope;
    
    NSUInteger firstChildIndex_ =
        ( SCReadItemSelfScope   & myScope  ? 1 : 0 ) +
        ( SCReadItemParentScope & myScope  ? 1 : 0 );
    
    return firstChildIndex_;
}


-(SCItemRecord*)getAnyChildItemRecordFromItems:( NSArray* )receivedItems
{
    NSUInteger childIndex = [ self indexOfFirstChildItemInResponse ];
    NSUInteger receivedItemsCount = [ receivedItems count ];
    
    if ( childIndex >= receivedItemsCount )
    {
        return nil;
    }
    
    return receivedItems[ childIndex ];
}

@end
