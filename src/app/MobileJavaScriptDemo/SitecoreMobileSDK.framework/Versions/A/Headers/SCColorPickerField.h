//
//  SCColorPickerField.h
//  SCColorPickerField
//
//  Created on 10/02/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCField.h"

/**
 The SCColorPickerField object identifies a Sitecore system item's "Color Picker" field.
 The field with [SCField type] is equal to "Color Picker" has the SCColorPickerField type.
 
 It provides a getter for the "Color Picker" color.
 */
@interface SCColorPickerField : SCField

/**
 The value of the field. [SCColorPickerField fieldValue] is UIColor object. [SCColorPickerField fieldValue] property represents [SCField rawValue] as UIColor object.
 */
@property(nonatomic,readonly) id fieldValue;

@end
