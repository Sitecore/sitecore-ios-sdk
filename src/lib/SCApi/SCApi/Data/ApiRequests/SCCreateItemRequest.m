#import "SCCreateItemRequest.h"

#import "SCApiContext.h"
#import "SCItemsReaderRequest+Factory.h"

@interface SCItemsReaderRequest (SCCreateItemRequest)

-(BOOL)isEqualToItemsReaderRequest:( SCItemsReaderRequest* )other_;

@end

@implementation SCCreateItemRequest

@synthesize itemName              = _itemName;
@synthesize itemTemplate          = _itemTemplate;
@synthesize fieldsRawValuesByName = _fieldsRawValuesByName;

-(SCItemsReaderRequest*)itemsReaderRequestWithApiContext:( SCApiContext* )context_
{
    SCCreateItemRequest* result_ = (SCCreateItemRequest*)[ super itemsReaderRequestWithApiContext: context_ ];

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
