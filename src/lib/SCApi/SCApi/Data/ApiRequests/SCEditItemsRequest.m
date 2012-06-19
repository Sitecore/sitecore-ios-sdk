#import "SCEditItemsRequest.h"

@interface SCItemsReaderRequest (SCEditItemsRequest)

-(BOOL)isEqualToItemsReaderRequest:( SCItemsReaderRequest* )other_;

@end

@implementation SCEditItemsRequest

@synthesize fieldsRawValuesByName = fieldsRawValuesByName;

-(id)copyWithZone:( NSZone* )zone_
{
    SCEditItemsRequest* result_ = [ super copyWithZone: zone_ ];

    result_->fieldsRawValuesByName = [ self.fieldsRawValuesByName copyWithZone: zone_ ];

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
