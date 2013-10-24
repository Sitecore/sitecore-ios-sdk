#import "SCRecordStorageBase.h"

#import "FieldByNameIterationBlock.h"

#import "SCItemAndFields.h"
#import "SCItemSourcePOD.h"
#import "SCItemRecord.h"
#import "SCItemRecord+SCItemSource.h"

#import "SCItem.h"
#import "SCItem+ItemRecord.h"

@implementation SCRecordStorageBase
{
    NSLocale* _posixLocale;
    SCItemSourcePOD* _itemSource;
}


-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithItemSource:( SCItemSourcePOD* )itemSource
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_itemSource = itemSource;
    
    return self;
}

-(SCItemSourcePOD*)itemSourcePOD
{
    return self->_itemSource;
}

-(id<SCItemSource>)itemSource
{
    return self->_itemSource;
}


-(NSString*)normalizeItemKey:( NSString* )itemKey
{
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^void(void)
    {
        self->_posixLocale = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    });
    
    itemKey = [ itemKey lowercaseStringWithLocale: self->_posixLocale ];
    
    return itemKey;
}

-(SCItemRecord*)itemRecordForItemKey:( NSString* )itemKey
{
    SCItemAndFields* entity = [ self getStoredEntityForItemKey: itemKey ];
    return entity.cachedItemRecord;
}


-(SCFieldRecord*)fieldWithName:( NSString* )fieldName
                       itemKey:( NSString* )itemKey
{
    NSParameterAssert( nil != fieldName );
    NSParameterAssert( nil != itemKey   );
    
    @autoreleasepool
    {
        SCItemAndFields* entity = [ self getStoredEntityForItemKey: itemKey ];
        return entity.cachedItemFieldsByName[ fieldName ];
    }
}

// NSDictionary<SCField>
-(NSDictionary*)cachedFieldsByNameForItemKey:( NSString* )itemKey
{
    SCItemAndFields* entity = [ self getStoredEntityForItemKey: itemKey ];
    return [ entity.cachedItemFieldsByName map: ^( NSString* fieldName, SCFieldRecord* fieldRecord )
    {
        NSParameterAssert( [ fieldName   isKindOfClass  : [ NSString      class ] ] );
        NSParameterAssert( [ fieldRecord isKindOfClass: [ SCFieldRecord class ] ] );
        
        return fieldRecord.field;
    } ];
}

-(NSDictionary*)allFieldsByNameForItemKey:( NSString* )itemKey
{
    SCItemAndFields* entity = [ self getStoredEntityForItemKey: itemKey ];
    if ( !entity.isAllFieldItemsCached )
    {
        return nil;
    }
    
    return [ self cachedFieldsByNameForItemKey: itemKey ];
}

-(NSArray*)cachedChildrenForItemKey:( NSString* )itemKey
                     searchProperty:( SCItemPropertyGetter )searchProperty
{
    NSParameterAssert( nil != itemKey );
    SCItemAndFields* entity = [ self getStoredEntityForItemKey: itemKey ];
    if ( nil == entity )
    {
        return nil;
    }
    
    NSArray* childEntities = [ self getCachedChildEntitiesForItemKey: itemKey
                                                      searchProperty: searchProperty ];
    
    NSArray* childRecords = [ childEntities map: ^SCItemRecord*( SCItemAndFields* childEntity )
    {
        return childEntity.cachedItemRecord;
    } ];
    
    return childRecords;
}


-(void)mergeEntity:( SCItemAndFields* )entity
           forItem:( SCItemRecord* )item
withAllFieldsInCache:( BOOL )isAllFieldsCached
withAllChildrenInCache:( BOOL )isAllChildrenCached
           withKey:( NSString* )itemKey
{
    NSDictionary* mergedFields = nil;
    
    if ( isAllFieldsCached )
    {
        mergedFields = item.fieldsByName;
    }
    else
    {
        NSMutableDictionary* mutableMergedFields = [ NSMutableDictionary dictionaryWithDictionary: entity.cachedItemFieldsByName ];
        
        FieldByNameIterationBlock validateFieldsByNameTypesBlock = [ self validateFieldsByNameTypesBlock ];
        
        [ item.fieldsByName enumerateKeysAndObjectsUsingBlock:^( NSString* fieldName, SCFieldRecord* fieldRecord, BOOL *stop)
         {
             validateFieldsByNameTypesBlock(fieldName, fieldRecord, stop );
             mutableMergedFields[fieldName] = fieldRecord;
         } ];
        
        mergedFields = [ NSDictionary dictionaryWithDictionary: mutableMergedFields ];
    }
    
    
    item.fieldsByName = mergedFields;
    item.itemRef = entity.cachedItemRecord.itemRef;
    [ entity.cachedItemRecord.itemRef setRecord: item ];
    
    SCItemAndFields* newEntity =
    [ [ SCItemAndFields alloc ] initWithItemRecord: item
                                            fields: mergedFields
                               isAllFieldsReceived: isAllFieldsCached
                             isAllChildrenReceived: isAllChildrenCached ];
    
    itemKey = [ self normalizeItemKey: itemKey ];
    
    // @adk : to reduce memory footprint
    newEntity.cachedItemRecord.itemSource = self.itemSourcePOD;
    
    [ self storeEntiry: newEntity
               withKey: itemKey ];
}

-(void)createEntityForItem:( SCItemRecord* )item
      withAllFieldsInCache:( BOOL )isAllFieldsCached
    withAllChildrenInCache:( BOOL )isAllChildrenCached
                   withKey:( NSString* )itemKey
{
    SCItemAndFields* entity = [ [ SCItemAndFields alloc ] initWithItemRecord: item
                                                                      fields: item.fieldsByName
                                                         isAllFieldsReceived: isAllFieldsCached
                                                       isAllChildrenReceived: isAllChildrenCached ];
    itemKey = [ self normalizeItemKey: itemKey ];
    
    // @adk : to reduce memory footprint
    entity.cachedItemRecord.itemSource = self.itemSourcePOD;
    
    [ self storeEntiry: entity
               withKey: itemKey ];
}


-(void)registerItem:( SCItemRecord* )item
withAllFieldsInCache:( BOOL )isAllFieldsCached
withAllChildrenInCache:( BOOL )isAllChildrenCached
             forKey:( NSString* )itemKey
{
    NSParameterAssert( nil != itemKey );
    NSParameterAssert( nil != item );
    NSParameterAssert( [ item.itemSource isEqual: self.itemSource ] );
    
    [ self validateFieldsByNameForItemRecord: item ];
    
    
    SCItemAndFields* entity = [ self getStoredEntityForItemKey: itemKey ];
    if ( nil == entity )
    {
        [ self createEntityForItem: item
              withAllFieldsInCache: isAllFieldsCached
            withAllChildrenInCache: isAllChildrenCached
                           withKey: itemKey ];
    }
    else
    {
        [ self mergeEntity: entity
                   forItem: item
      withAllFieldsInCache: isAllFieldsCached
    withAllChildrenInCache: isAllChildrenCached
                   withKey: itemKey ];
    }
    
    
    FieldByNameIterationBlock setItemToItsFields = [ self blockToPopulateFieldsWithItemRecord: item ];
    [ item.fieldsByName enumerateKeysAndObjectsUsingBlock: setItemToItsFields];
}


-(NSArray*)allChildrenForItemKey:( NSString* )itemKey
                  searchProperty:( SCItemPropertyGetter )searchProperty
{
    NSParameterAssert( nil != itemKey );
    
    SCItemAndFields* entity = [ self getStoredEntityForItemKey: itemKey ];
    if ( !entity.isAllChildItemsCached )
    {
        return nil;
    }
    
    return [ self cachedChildrenForItemKey: itemKey
                            searchProperty: searchProperty ];
}

-(NSArray*)allStoredRecords
{
    JFFMappingBlock getRecordFromEntity = ^SCItemRecord*(SCItemAndFields* entity)
    {
        NSParameterAssert( [ entity isMemberOfClass: [ SCItemAndFields class ] ] );
        return entity.cachedItemRecord;
    };
    
    NSArray* entities = [ self allStoredEntities ];
    return [ [ entities copy ] map: getRecordFromEntity ];
}


#pragma mark -
#pragma mark Abstract methods
-(NSArray*)allStoredEntities
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(FieldByNameIterationBlock)blockToPopulateFieldsWithItemRecord:( SCItemRecord* )item
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(void)validateFieldsByNameForItemRecord:( SCItemRecord* )item
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(FieldByNameIterationBlock)validateFieldsByNameTypesBlock
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(void)storeEntiry:( SCItemAndFields* )entity
           withKey:( NSString* )itemKey
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(SCItemAndFields*)getStoredEntityForItemKey:( NSString* )itemKey
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(NSArray*)getCachedChildEntitiesForItemKey:( NSString* )itemKey
                             searchProperty:( SCItemPropertyGetter )searchProperty
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

@end
