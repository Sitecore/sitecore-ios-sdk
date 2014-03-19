//
//  SCItem.h
//  SCItem
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#include <SitecoreMobileSDK/SCAsyncOpDefinitions.h>

#import <Foundation/Foundation.h>

@class SCField;
@class SCApiSession;
@class SCExtendedApiSession;
@class SCDownloadMediaOptions;

/**
 The SCItem object identifies a Sitecore system item.

 It provides getters for the parent and children items. And getters for the item's fields.

 Also it provides methods for asynchronous loading of children items and their fields.

 Now you can load items using the only SCApiSession object, and all loaded items has a reference to his API session, which can be used to read a necessary data.

 SCItem object will be automatically updated with a new data when you read the same item from the backend.
 */
@interface SCItem : NSObject

/**
 The SCApiSession object this item was created/loaded from.
 Can be used to load the necessary data.
 */
@property(nonatomic,readonly) SCExtendedApiSession* apiSession;

/**
 The system item's id.
 */
@property(nonatomic,readonly) NSString *itemId;

/**
 The system item's path.
 */
@property(nonatomic,readonly) NSString *path;

/**
 The system item's display name.
 */
@property(nonatomic,readonly) NSString *displayName;

/**
 If the item has a children items.
 */
@property(nonatomic,readonly) BOOL hasChildren;

/**
 The system item's full template name, example: "Nicam/Item Types/Site Section".
 */
@property(nonatomic,readonly) NSString *itemTemplate;

/**
 The system item's long id, example: "/{11111111-1111-1111-1111-111111111111}/{0DE95AE4-41AB-4D01-9EB0-67441B7C2450}"
 */
@property(nonatomic,readonly) NSString *longID;

/**
 The system item's language
 */
@property(nonatomic,readonly) NSString *language;

/**
 The system item's parent
 */
@property(nonatomic,weak,readonly) SCItem *parent;

/**
 The system item's children, it is nil if not all children was loaded for the item. If you want to get available children items - use readChildren property instead.

 All item's children can be loaded using -[SCItem readChildrenOperation] method
 */
@property(nonatomic,readonly) NSArray *allChildren;

/**
 Only loaded item's children.
 */
@property(nonatomic,readonly) NSArray *readChildren;

/**
 Only loaded item's fields.
 */
@property(nonatomic,readonly) NSArray *readFields;

/**
 All item's fields.
 */
@property(nonatomic,readonly) NSArray *allFields;

/**
 Returns SCField object for the given field's name if such field was loaded and the item has a field with such name
 @param fieldName the name of the item's field name, see [ SCField name ]
 @return SCField object or nil if such field does not exists.
 */
- (SCField*)fieldWithName:(NSString *)fieldName;

/**
 Returns SCField object's value( [SCField fieldValue] ) for the given field's name if such field was loaded and the item has a field with such name
 @param fieldName the name of the item's field name, see [SCField name]
 @return SCField object's value or nil if such field does not exists. See [SCField fieldValue]
 */
- (id)fieldValueWithName:(NSString *)fieldName;

/**
 Used to load the field's value, see [SCField fieldValue] and [SCField readFieldValueOperation]
 @param fieldName the name of the item's field name, see [SCField name]
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result depends on type of SCField, see [SCField readFieldValueOperation] for details.
 */
- (SCAsyncOp)readFieldValueOperationForFieldName:(NSString *)fieldName;
- (SCExtendedAsyncOp)readFieldValueExtendedOperationForFieldName:( NSString* )fieldName;

/**
 Used to load the fields and the field's values of the item, see [SCField fieldValue] and [SCField readFieldValueOperation] for details.
 @param fieldNames the set of the field's names which will be read with the field's values. Each field's name of the set should be a string.
 To read all fields choose nil or the empty set if you don't need to read any field
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSDictionary of field's values by field's names or SCApiError if error happens.
 */
- (SCAsyncOp)readFieldsValuesOperationForFieldsNames:(NSSet *)fieldNames;
- (SCExtendedAsyncOp)readFieldsValuesExtendedOperationForFieldsNames:( NSSet* )fieldsNames_;

/**
 Used to load item's fields, see [SCItem readFieldsByName]
 @param fieldNames the set of the field's names which will be read for the item. Each field's name in the set should be a string.
 To read all fields choose nil or the empty set if you don't need to read any field
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSDictionary of SCField objects by field's names or SCApiError if error happens.
 */
- (SCAsyncOp)fieldsReaderForFieldsNames:(NSSet *)fieldNames;
- (SCExtendedAsyncOp)extendedFieldsReaderForFieldsNames:( NSSet* )fieldNames;

/**
 Used to load all item's children, see -[SCItem allChildren]
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSArray of SCItem objects or SCApiError if error happens.
 */
- (SCAsyncOp)readChildrenOperation;
- (SCExtendedAsyncOp)readChildrenExtendedOperation;

/**
 Used to save all item's changed fields
 @return SCAsyncOp block. Call it to save item. The SCAsyncOpResult handler's result is SCItem object or SCApiError if error happens.
 */
- (SCAsyncOp)saveItem;
- (SCExtendedAsyncOp)extendedSaveItem;

/**
 Used to remove given item
 @return SCAsyncOp block. Call it to remove item. The SCAsyncOpResult handler's result is NSNumber object( always equal to "1" ) or SCApiError if error happens.
 */
- (SCAsyncOp)removeItem;
- (SCExtendedAsyncOp)extendedRemoveItem;


#pragma mark -
#pragma mark Media Extensions
/**
 Checks whether the item is in the media folder.
 
 @return YES if the item's path is within the media folder. By default, it is "/sitecore/Media Library".
 */
-(BOOL)isMediaItem;

/**
 Checks whether the item is a media image. Such items have image template and is stored in the media folder. See isMediaItem and isImage methods for details.
 
 @return YES if the item is a media image.
 */
-(BOOL)isMediaImage;

/**
 Checks whether the item has an image template.
 
 * "SYSTEM/MEDIA/UNVERSIONED/IMAGE"
 * "SYSTEM/MEDIA/UNVERSIONED/JPEG"
 * "SYSTEM/MEDIA/VERSIONED/JPEG"
 
 @return YES if item's template is among those listed above.
 
 */
-(BOOL)isImage;


/**
 Checks whether the item has a folder template.
 * "SYSTEM/MEDIA/MEDIA FOLDER"
 * "COMMON/FOLDER"
 
 @return YES if item's template is among those listed above.
 */
-(BOOL)isFolder;

/**
 Returns a media path of items that have it.
 
 @return Item's Media path or nil
 
 |self.isMediaItem | return value|
 |-------------------------------|
 |       YES       | media path  |
 |        NO       | nil         |
 -------------------------------
 */
-(NSString*)mediaPath;


/**
 Returns a media path of items that have it.
 
 @param options Resizing options for media files processing on the back end.
 
 @return Loader or nil
 
 |self.isMediaItem | return value|
 |-------------------------------|
 |       YES       | loader      |
 |        NO       | nil         |
 -------------------------------
 */
-(SCExtendedAsyncOp)mediaLoaderWithOptions:( SCDownloadMediaOptions* )options;


/**
 @return Item source if available. Default settings of the corresponding session otherwise.
 */
-(SCItemSourcePOD*)recordItemSource;

@end
