#import <SitecoreMobileSDK/SCItem.h>

@interface SCItem (Private)

/**
 The system item's fields, it is nil if not all fields was loaded for the item. If you want to get available item's fields - use readFieldsByName property instead.
 
 Item's fields can be loaded using -[SCItem readFieldValueOperationForFieldName:] method
 */
@property(nonatomic,readonly) NSDictionary *allFieldsByName;

/**
 Only loaded item's fields.
 */
@property(nonatomic,readonly) NSDictionary *readFieldsByName;

@end
