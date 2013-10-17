#import "SCItemRecordPropertyFactory.h"

#import "SCItemRecord.h"

@implementation SCItemRecordPropertyFactory

+(SCItemPropertyGetter)parentIdGetter
{
    SCItemPropertyGetter result = ^NSString *(SCItemRecord *itemRecord)
    {
        return itemRecord.parentId;
    };
    
    return [ result copy ];
}

+(SCItemPropertyGetter)parentPathGetter
{
    SCItemPropertyGetter result = ^NSString *(SCItemRecord *itemRecord)
    {
        return itemRecord.parentPath;
    };

    return [ result copy ];
}

@end
