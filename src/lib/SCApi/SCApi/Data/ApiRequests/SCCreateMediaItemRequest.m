#import "SCCreateMediaItemRequest.h"

@implementation SCCreateMediaItemRequest

-(id)copyWithZone:( NSZone* )zone_
{
    SCCreateMediaItemRequest* result_ = [ [ [ self class ] allocWithZone: zone_ ] init ];

    if ( result_ )
    {
        result_->_itemName      = [ self.itemName      copyWithZone: zone_ ];
        result_->_itemTemplate  = [ self.itemTemplate  copyWithZone: zone_ ];
        result_->_mediaItemData = [ self.mediaItemData copyWithZone: zone_ ];
        result_->_fileName      = [ self.fileName      copyWithZone: zone_ ];
        result_->_contentType   = [ self.contentType   copyWithZone: zone_ ];
        result_->_folder        = [ self.folder        copyWithZone: zone_ ];
        result_->_fieldNames    = [ self.fieldNames    copyWithZone: zone_ ];
        
        result_.itemSource = [ self.itemSource copyWithZone: zone_ ];
//        result_->_language  = [ self.language copyWithZone: zone_ ];
//        result_->_site      = [ self.site     copyWithZone: zone_ ];
//        result_->_database  = [ self.database copyWithZone: zone_ ];
    }

    return result_;
}

-(BOOL)isEqual:( SCCreateMediaItemRequest* )other_
{
    if ( other_ == self )
    {
        return YES;
    }

    if ( !other_ || ![ other_ isKindOfClass: [ self class ] ] )
    {
        return NO;
    }

    return [ self isEqualToCreateMediaItemRequest: other_ ];
}

-(BOOL)isEqualToCreateMediaItemRequest:( SCCreateMediaItemRequest* )other_
{
    if ( self == other_ )
    {
        return YES;
    }

    return [ NSObject object: self.itemName      isEqualTo: other_.itemName      ]
        && [ NSObject object: self.itemTemplate  isEqualTo: other_.itemTemplate  ]
        && [ NSObject object: self.mediaItemData isEqualTo: other_.mediaItemData ]
        && [ NSObject object: self.fileName      isEqualTo: other_.fileName      ]
        && [ NSObject object: self.contentType   isEqualTo: other_.contentType   ]
        && [ NSObject object: self.folder        isEqualTo: other_.folder        ]
        && [ NSObject object: self.fieldNames    isEqualTo: other_.fieldNames    ]
        && [ NSObject object: self.language      isEqualTo: other_.language      ]
        && [ NSObject object: self.site          isEqualTo: other_.site          ]
        && [ NSObject object: self.database      isEqualTo: other_.database      ];
}

@end
