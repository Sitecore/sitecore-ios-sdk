#import <Foundation/Foundation.h>


@class SCItemRecord;
@class SCFieldRecord;
@protocol SCItemSource;


@protocol SCItemRecordCache <NSObject>

-(SCItemRecord*)itemRecordForItemWithId:( NSString* )itemId
                             itemSource:( id<SCItemSource> )itemSource;

-(SCItemRecord*)itemRecordForItemWithPath:( NSString* )itemPath
                               itemSource:( id<SCItemSource> )itemSource;

-(SCFieldRecord*)fieldWithName:( NSString* )fieldName
                        itemId:( NSString* )itemId
                    itemSource:( id<SCItemSource> )itemSource;

-(NSArray*)allCachedItemsForItemSource:( id<SCItemSource> )itemSource;

// of SCField*
-(NSDictionary*)cachedFieldsByNameForItemId:( NSString* )itemId
                                 itemSource:( id<SCItemSource> )itemSource;

// of SCField*
-(NSDictionary*)allFieldsByNameForItemId:( NSString* )itemId
                              itemSource:( id<SCItemSource> )itemSource;

// of SCItemRecord*
-(NSArray*)cachedChildrenForItemWithId:( NSString* )itemId
                            itemSource:( id<SCItemSource> )itemSource;


// of SCItemRecord*
-(NSArray*)allChildrenForItemWithItemWithId:( NSString* )itemId
                                 itemSource:( id<SCItemSource> )itemSource;

// of SCItemRecord*
-(NSArray*)allChildrenForItemWithItemWithPath:( NSString* )itemPath
                                   itemSource:( id<SCItemSource> )itemSource;

-(NSArray*)changedFieldsForItemId:( NSString* )itemId
                       itemSource:( id<SCItemSource> )itemSource;

@end
