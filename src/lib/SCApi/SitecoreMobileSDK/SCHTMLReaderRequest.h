//
//  SCHTMLReaderRequest.h
//  SCHTMLReaderRequest
//
//  Created on 10/03/2013.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCBaseItemRequest.h"

/**
 The SCHTMLReaderRequest contains the set of params for the requested html rendering from the backend.
 It used for [SCApiContext renderingHTMLReaderWithRequest:] method.
 */
@interface SCHTMLReaderRequest : SCBaseItemRequest

/**
id of rendering which you want to request
 */
@property(nonatomic,strong) NSString *renderingId;

/**
item's id for render using rendering with renderingId
 */
@property(nonatomic,strong) NSString *sourceId;

@end
