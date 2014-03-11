//
//  SCDroptreeField.h
//  SCDroptreeField
//
//  Created on 2/29/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCDroplinkField.h"

/**
 The SCDroptreeField object identifies a Sitecore system item's droplink field.
 The field with [SCField type] is equal to "Droplink" has the SCDroptreeField type.
 
 It provides a getter for the linked item in droplink and an asynchronous loader for reading the selected item of droplink.
 */
@interface SCDroptreeField : SCDroplinkField

/**
 Used for loading the selected item in droplink.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is SCItem object or nil if error happens.
 */
- (SCAsyncOp)readFieldValueOperation;

/**
 The value of the field. [SCDroptreeField fieldValue] is SCItem object. It is nil by default, so use [SCDroptreeField readFieldValueOperation] to load selected item. SCDroptreeField object does not own loaded item to avoid retain cycles.
 */
@property(nonatomic,readonly) id fieldValue;

@end
