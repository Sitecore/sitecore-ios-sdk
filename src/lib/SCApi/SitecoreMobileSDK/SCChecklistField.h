//
//  SCChecklistField.h
//  SCChecklistField
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCField.h"

/**
 The SCChecklistField object identifies a Sitecore system item's checklist field.
 The field with [SCField type] is equal to "Checklist" has the SCChecklistField type.
 
 It provides a getter for the items in checklist and an asynchronous loader for reading items of checklist.
 */
@interface SCChecklistField : SCField

/**
 Used for loading the array of items in checklist.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSArray of SCItems objects or nil if error happens.
 */
- (SCAsyncOp)fieldValueReader;

/**
 The value of the field. [SCChecklistField fieldValue] is NSArray object. It is nil by default, so use [SCChecklistField fieldValueReader] to load NSArray of items. SCChecklistField object does not own loaded items to avoid retain cycles.
 */
@property(nonatomic,readonly) id fieldValue;

@end
