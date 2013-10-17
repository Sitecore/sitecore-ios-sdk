//
//  SCImageField.h
//  SCImageField
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SitecoreMobileSDK/SCField.h"

@class SCFieldImageParams;

/**
 The SCImageField object identifies a Sitecore system item's image field.
 The field with [SCField type] is equal to "Image" has the SCImageField type.
 
 It provides a getter for the image path and an asynchronous loader for the image with this path.
 */
@interface SCImageField : SCField

/**
 The path to the Sitecore media item's image. Can be used to read an image, see [SCApiContext imageLoaderForSCMediaPath:] or [SCImageField fieldValueReader]
 */
@property(nonatomic) NSString *imagePath;

/**
 Used for loading the field value which is a UIImage object.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is UIImage object or nil if error happens.
 */
- (SCAsyncOp)fieldValueReader;

/**
Used for loading the field value which is a UIImage object with additional parameters.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is UIImage object or nil if error happens.
 */
-(SCAsyncOp)fieldValueReaderWithImageParams:( SCFieldImageParams* )params;

/**
 The value of the field. [SCImageField fieldValue] is UIImage object. It is nil by default, so use [SCImageField fieldValueReader] to load UIImage of this field.
 */
@property(nonatomic,readonly) id fieldValue;

@end
