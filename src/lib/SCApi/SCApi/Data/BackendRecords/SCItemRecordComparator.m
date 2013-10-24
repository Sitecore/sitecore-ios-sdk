#import "SCItemRecordComparator.h"

#import "SCItemRecord+SCItemSource.h"

@implementation SCItemRecordComparator

+(BOOL)metadataOfItemRecord:( SCItemRecord* )first
                  isEqualTo:( SCItemRecord* )second
{
    JUncertainLogicStates pointerCheckResult = [ NSObject quickCheckObject: first
                                                                 isEqualTo: second ];
    if ( ULMaybe != pointerCheckResult )
    {
        return (BOOL)pointerCheckResult;
    }
    
    BOOL result =
        [ NSObject objcBoolean: first.hasChildren isEqualTo: second.hasChildren ]
    &&  [ NSObject object: first.itemId      isEqualTo: second.itemId ]
    &&  [ NSObject object: first.longID      isEqualTo: second.longID ]
    &&  [ NSObject object: first.path        isEqualTo: second.path   ]
    &&  [ NSObject object: first.displayName isEqualTo: second.displayName ];
    
    return result;
}

+(BOOL)sourceOfItemRecord:( SCItemRecord* )first
                isEqualTo:( SCItemRecord* )second
{
    return [ NSObject object: first.itemSource
                   isEqualTo: second.itemSource ];
}

@end
