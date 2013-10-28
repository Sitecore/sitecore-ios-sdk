#import "SCItemInfo.h"

@implementation SCItemInfo

-(NSString*)description
{
    return [ [ NSString alloc ] initWithFormat: @"<SCItemInfo itemId:\"%@\" itemPath:\"%@\" language:\"%@\" version:\"%ld\" >"
            , self->_itemId
            , self->_itemPath
            , self->_language
            , (long)self->_version ];
}

@end
