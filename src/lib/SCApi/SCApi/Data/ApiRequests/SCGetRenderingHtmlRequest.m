//
//  SCGetRenderingHtmlRequest.m
//  SCApi
//
//  Created by Igor on 10/3/13.
//
//

#import "SCGetRenderingHtmlRequest.h"

@implementation SCGetRenderingHtmlRequest


-(id)copyWithZone:( NSZone* )zone_
{
    SCGetRenderingHtmlRequest * result_ = [ [ [ self class ] allocWithZone: zone_ ] init ];

    result_.language    = [ self.language copyWithZone: zone_ ];
    result_.database    = [ self.database copyWithZone: zone_ ];
    result_.site        = [ self.site copyWithZone: zone_ ];
    result_.itemVersion = [ self.itemVersion copyWithZone: zone_ ];
    result_.renderingId = [ self.renderingId copyWithZone: zone_ ];
    result_.sourceId    = [ self.sourceId copyWithZone: zone_ ];
    
    return result_;
}

@end
