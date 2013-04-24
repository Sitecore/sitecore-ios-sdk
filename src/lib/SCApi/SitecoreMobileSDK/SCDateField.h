//
//  SCDateField.h
//  SCDateField
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCField.h"

/**
 The SCDateField object identifies a Sitecore system item's date field.
 The field with [SCField type] is equal to "Date" has the SCDateField type.
 
 It provides a getter for the field date.
 */
@interface SCDateField : SCField

/**
 The value of the field. [SCDateField fieldValue] is NSDate object. [SCDateField fieldValue] property represents [SCField rawValue] as NSDate object.
 */
@property(nonatomic,readonly) id fieldValue;

@end
