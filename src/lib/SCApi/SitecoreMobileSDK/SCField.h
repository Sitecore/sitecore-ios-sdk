//
//  SCField.h
//  SCField
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#include <SitecoreMobileSDK/SCAsyncOpDefinitions.h>
#include <SitecoreMobileSDK/SCExtendedOperations.h>
#import <Foundation/Foundation.h>

@class SCItem;
@class SCExtendedApiSession;
@class SCParams;
@protocol SCItemSource;


/**
 The SCField object identifies a Sitecore system item's field.

 It provides getters for the field's properties and asynchronous loader for the field's value.

 Now you can load fields using SCApiSession or SCItem object.
 */
@interface SCField : NSObject

/**
 The SCApiSession object this field was created/loaded from.
 Can be used to load the necessary data.
 */
@property(nonatomic,readonly) SCExtendedApiSession *apiSession;
/**
 The system field's id.
 */
@property(nonatomic,readonly) NSString *fieldId;
/**
 The system field's name.
 */
@property(nonatomic,readonly) NSString *name;
/**
 The system field's type. Possible values: "Image", "Datetime", "Checklist" etc.
 */
@property(nonatomic,readonly) NSString *type;
/**
 The system field's raw value.
 */
@property(nonatomic) NSString *rawValue;

/**
 The SCItem object for this field is belong to.
 */
@property(nonatomic,weak,readonly) SCItem *item;

/**
 The value of the field, depends on the field type ( see [SCField type] ).

 This value is equal to [SCField rawValue] if class of the field's object is SCField and can be different for other fields types.

 See SCField inheritor class: [SCImageField fieldValue] for details.
 */
@property(nonatomic,readonly) id fieldValue;

@property(nonatomic, readonly) id<SCItemSource> itemSource;

/**
 Used for the loading field value.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is [SCField rawValue] by default but can be different for other fields types.

 See SCField inheritor class: [SCImageField readFieldValueOperation] for details.
 */
- (SCAsyncOp)readFieldValueOperation;
- (SCExtendedAsyncOp)readFieldValueExtendedOperation;

@end
