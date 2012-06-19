#import "SCItemIdPathAndLanguage.h"

@implementation SCItemIdPathAndLanguage

@synthesize itemIdPath, language;

-(NSString*)itemIdPath
{
    return itemIdPath ? itemIdPath : @"";
}

-(BOOL)isEqual:( SCItemIdPathAndLanguage* )other_
{
    if ( other_ == self )
        return YES;

    if ( !other_ || ![ other_ isKindOfClass: [ self class ] ] )
        return NO;

    return [ self isEqualToItemIdPathAndLanguage: other_ ];
}

-(BOOL)isEqualToItemIdPathAndLanguage:( SCItemIdPathAndLanguage* )other_
{
    if ( self == other_ )
        return YES;

    return [ itemIdPath isEqualToString: other_.itemIdPath ]
        && [ language   isEqualToString: other_.language ];
}

-(NSUInteger)hash
{
    return [ itemIdPath hash ];
}

-(id)copyWithZone:(NSZone *)zone_
{
    SCItemIdPathAndLanguage* result_ = [ [ [ self class ] allocWithZone: zone_ ] init ];

    result_->itemIdPath = [ itemIdPath copyWithZone: zone_ ];
    result_->language   = [ language   copyWithZone: zone_ ];

    return result_;
}

-(NSString*)description
{
    return [ NSString stringWithFormat: @"<SCItemIdPathAndLanguage itemIdPath:\"%@\" language:\"%@\" >"
            , self.itemIdPath
            , self.language ];
}

@end
