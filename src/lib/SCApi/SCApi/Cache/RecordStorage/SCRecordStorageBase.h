#import "SCItemPropertyGetterBlock.h"
#import <Foundation/Foundation.h>

@class SCItemRecord;
@class SCFieldRecord;
@class SCItemSourcePOD;
@protocol SCItemSource;
@class SCItemAndFields;

@interface SCRecordStorageBase : NSObject

-(instancetype)initWithItemSource:( SCItemSourcePOD* )itemSource;

-(SCItemSourcePOD*)itemSourcePOD;
-(id<SCItemSource>)itemSource;


-(SCItemRecord*)itemRecordForItemKey:( NSString* )itemKey;
-(SCFieldRecord*)fieldWithName:( NSString* )fieldName
                       itemKey:( NSString* )itemKey;

// NSDictionary<SCField>
-(NSDictionary*)cachedFieldsByNameForItemKey:( NSString* )itemKey;
-(NSDictionary*)allFieldsByNameForItemKey:( NSString* )itemKey;

-(NSArray*)cachedChildrenForItemKey:( NSString* )itemKey
                     searchProperty:( SCItemPropertyGetter )searchProperty;

-(NSArray*)allChildrenForItemKey:( NSString* )itemKey
                  searchProperty:( SCItemPropertyGetter )searchProperty;

-(NSArray*)allStoredRecords;

@end
