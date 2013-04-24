//
//  SCMultilistField.h
//  SCMultilistField
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCChecklistField.h"

/**
 The SCTreelistField object identifies a Sitecore system item's treelist field.
 The field with [SCField type] is equal to "Treelist" has the SCTreelistField type.
 
 It provides a getter for the items in treelist and an asynchronous loader for reading items of treelist.
 */
@interface SCTreelistField : SCChecklistField

/**
 Used for loading the array of items in treelist.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSArray of SCItems objects or nil if error happens.
 */
- (SCAsyncOp)fieldValueReader;

/**
 The value of the field. [SCTreelistField fieldValue] is NSArray object. It is nil by default, so use [SCTreelistField fieldValueReader] to load NSArray of items. SCTreelistField object does not own loaded items to avoid retain cycles.
 */
@property(nonatomic,readonly) id fieldValue;

@end
