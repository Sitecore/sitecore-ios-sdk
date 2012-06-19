#import "SCItemInfo.h"

@implementation SCItemInfo

@synthesize itemId   = _itemId;
@synthesize itemPath = _itemPath;
@synthesize language = _language;
@synthesize version  = _version;

-(NSString*)description
{
    return [ NSString stringWithFormat: @"<SCItemInfo itemId:\"%@\" itemPath:\"%@\" language:\"%@\" version:\"%d\" >"
            , _itemId
            , _itemPath
            , _language
            , _version ];
}

@end
