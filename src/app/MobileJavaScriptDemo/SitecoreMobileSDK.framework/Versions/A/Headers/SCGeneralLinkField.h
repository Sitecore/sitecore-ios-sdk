//
//  SCGeneralLinkField.h
//  SCGeneralLinkField
//
//  Created on 2/29/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCField.h"

@class SCFieldLinkData;

/**
 The SCGeneralLinkField object identifies a Sitecore system item's general link field.
 The field with [SCField type] is equal to "General Link" has the SCGeneralLinkField type.
 
 It provides a getter to general link as SCFieldLinkData object.
 */
@interface SCGeneralLinkField : SCField

/**
 Parsed link xml. "General Link" like link to item or media item, etc, see SCFieldLinkData for details.
 */
@property(nonatomic,readonly) SCFieldLinkData *linkData;

/**
 The value of the field. [SCGeneralLinkField fieldValue] is SCFieldLinkData object.
 */
@property(nonatomic,readonly) id fieldValue;

@end
