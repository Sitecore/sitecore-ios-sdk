//
//  SCMultilistField.h
//  SCMultilistField
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCChecklistField.h"

/**
 The SCMultilistField object identifies a Sitecore system item's multilist field.
 The field with [SCField type] is equal to "Multilist" has the SCMultilistField type.
 
 It provides a getter for the items in multilist and an asynchronous loader for reading items of multilist.
 */
@interface SCMultilistField : SCChecklistField

/**
 Used for loading the array of items in multilist.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSArray of SCItems objects or nil if error happens.
 */
- (SCAsyncOp)readFieldValueOperation;

/**
 The value of the field. [SCMultilistField fieldValue] is NSArray object. It is nil by default, so use [SCChecklistField readFieldValueOperation] to load NSArray of items. SCMultilistField object does not own loaded items to avoid retain cycles.
 */
@property(nonatomic,readonly) id fieldValue;

@end
