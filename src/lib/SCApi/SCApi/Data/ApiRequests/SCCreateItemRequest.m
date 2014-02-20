#import "SCCreateItemRequest.h"

#import "SCExtendedApiSession.h"
#import "SCReadItemsRequest+Factory.h"

@interface SCReadItemsRequest (SCCreateItemRequest)

-(BOOL)isEqualToItemsReaderRequest:( SCReadItemsRequest * )other_;

@end

@implementation SCCreateItemRequest

-(SCReadItemsRequest *)itemsReaderRequestWithApiSession:( SCExtendedApiSession* )context_
{
    SCCreateItemRequest* result_ = (SCCreateItemRequest*)[ super itemsReaderRequestWithApiSession: context_ ];

    result_.scope = SCItemReaderSelfScope;

    return result_;
}

-(id)copyWithZone:( NSZone* )zone_
{
    SCCreateItemRequest* result_ = [ super copyWithZone: zone_ ];

    result_->_itemName              = [ self.itemName              copyWithZone: zone_ ];
    result_->_itemTemplate          = [ self.itemTemplate          copyWithZone: zone_ ];
    result_->_fieldsRawValuesByName = [ self.fieldsRawValuesByName copyWithZone: zone_ ];

    return result_;
}

-(BOOL)isEqual:( SCCreateItemRequest* )other_
{
    if ( other_ == self )
        return YES;

    if ( !other_ || ![ other_ isKindOfClass: [ self class ] ] )
        return NO;

    return [ self isEqualToCreateItemRequest: other_ ];
}

-(BOOL)isEqualToCreateItemRequest:( SCCreateItemRequest* )other_
{
    if ( self == other_ )
        return YES;

    return [ NSObject object: self.itemName     isEqualTo: other_.itemName     ]
        && [ NSObject object: self.itemTemplate isEqualTo: other_.itemTemplate ]
        && [ NSObject object: self.fieldsRawValuesByName isEqualTo: other_.fieldsRawValuesByName ]
        && [ self isEqualToItemsReaderRequest: other_ ];
}

@end
