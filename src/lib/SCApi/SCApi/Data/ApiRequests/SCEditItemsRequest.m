#import "SCEditItemsRequest.h"

@interface SCReadItemsRequest (SCEditItemsRequest)

-(BOOL)isEqualToItemsReaderRequest:( SCReadItemsRequest * )other_;

@end

@implementation SCEditItemsRequest

-(id)copyWithZone:( NSZone* )zone_
{
    SCEditItemsRequest* result_ = [ super copyWithZone: zone_ ];

    if ( result_ )
    {
        result_->_fieldsRawValuesByName = [ self.fieldsRawValuesByName copyWithZone: zone_ ];
    }

    return result_;
}

-(BOOL)isEqual:( SCEditItemsRequest* )other_
{
    if ( other_ == self )
        return YES;

    if ( !other_ || ![ other_ isKindOfClass: [ self class ] ] )
        return NO;

    return [ self isEqualToEditItemsRequest: other_ ];
}

-(BOOL)isEqualToEditItemsRequest:( SCEditItemsRequest* )other_
{
    if ( self == other_ )
        return YES;

    return [ self isEqualToItemsReaderRequest: other_ ]
        && [ NSObject object: self.fieldsRawValuesByName isEqualTo: other_.fieldsRawValuesByName ];
}

@end
