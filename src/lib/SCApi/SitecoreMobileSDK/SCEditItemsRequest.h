//
//  SCEditItemsRequest.h
//  SCEditItemsRequest
//
//  Created on 04/02/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCItemsReaderRequest.h"

/**
 The SCEditItemsRequest contains the set of params to edit existing items.
 It used for [SCApiContext editItemsWithRequest:] method.
 This class is inherited from SCItemsReaderRequest class whose fields is used to search items to edit.
 */
@interface SCEditItemsRequest : SCItemsReaderRequest

/**
 The dictionary of fields raw values by fields names which will be edited.
 */
@property(nonatomic) NSDictionary *fieldsRawValuesByName;

@end
