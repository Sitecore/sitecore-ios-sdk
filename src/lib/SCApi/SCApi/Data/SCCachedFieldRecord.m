#import "SCCachedFieldRecord.h"


@implementation SCCachedFieldRecord

@synthesize itemSource = _itemSource;
@synthesize itemId     = _itemId    ;

-(SCItemSourcePOD*)itemSource
{
    if ( nil == self->_itemSource )
    {
        return [ super itemSource ];
    }

    return self->_itemSource;
}

-(NSString*)itemId
{
    if ( nil == self->_itemId )
    {
        return [ super itemId ];
    }
    
    return self->_itemId;
    
}

@end
