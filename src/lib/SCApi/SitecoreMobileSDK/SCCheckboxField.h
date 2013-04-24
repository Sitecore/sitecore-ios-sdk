//
//  SCCheckboxField.h
//  SCCheckboxField
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCField.h"

/**
 The SCCheckboxField object identifies a Sitecore system item's checkbox field.
 The field with [SCField type] is equal to "Checkbox" has the SCCheckboxField type.
 
 It provides a getter for the checkbox flag.
 */
@interface SCCheckboxField : SCField

/**
 The value of the field. [SCCheckboxField fieldValue] is NSNumber object. [NSNumber boolValue] is NO if checkbox does not selected and YES otherwise.
 */
@property(nonatomic,readonly) id fieldValue;

@end
