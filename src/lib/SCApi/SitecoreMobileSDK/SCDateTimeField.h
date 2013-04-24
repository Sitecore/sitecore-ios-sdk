//
//  SCDateTimeField.h
//  SCDateTimeField
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCDateField.h"

/**
 The SCDateTimeField object identifies a Sitecore system item's dateTime field.
 The field with [SCField type] is equal to "Datetime" has the SCDateTimeField type.
 
 It provides a getter for the field date.
 */
@interface SCDateTimeField : SCDateField

/**
 The value of the field. [SCDateTimeField fieldValue] is NSDate object. [SCDateTimeField fieldValue] property represents [SCField rawValue] as NSDate object.
 */
@property(nonatomic,readonly) id fieldValue;

@end
