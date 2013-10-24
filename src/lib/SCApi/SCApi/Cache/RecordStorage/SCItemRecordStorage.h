#import <Foundation/Foundation.h>
#import "SCItemPropertyGetterBlock.h"

@class SCItemRecord;
@class SCFieldRecord;
@protocol SCItemSource;


@protocol SCItemRecordStorage <NSObject>

-(SCItemRecord*)itemRecordForItemKey:( NSString* )itemKey;
-(id<SCItemSource>)itemSource;

-(SCFieldRecord*)fieldWithName:( NSString* )fieldName
                       itemKey:( NSString* )itemKey;

// NSDictionary<SCField>
-(NSDictionary*)cachedFieldsByNameForItemKey:( NSString* )itemKey;
-(NSDictionary*)allFieldsByNameForItemKey:( NSString* )itemKey;

-(NSArray*)allChildrenForItemKey:( NSString* )itemKey
                  searchProperty:( SCItemPropertyGetter )searchProperty;

-(NSArray*)cachedChildrenForItemKey:( NSString* )itemKey
                     searchProperty:( SCItemPropertyGetter )searchProperty;

-(NSArray*)allStoredRecords;

-(NSArray*)changedFieldsForItemId:( NSString* )itemId;

@end
