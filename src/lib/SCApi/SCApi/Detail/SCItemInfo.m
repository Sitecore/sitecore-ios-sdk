#import "SCItemInfo.h"

@implementation SCItemInfo

-(NSString*)description
{
    return [ [ NSString alloc ] initWithFormat: @"<SCItemInfo itemId:\"%@\" itemPath:\"%@\" language:\"%@\" version:\"%d\" >"
            , self->_itemId
            , self->_itemPath
            , self->_language
            , self->_version ];
}

@end
