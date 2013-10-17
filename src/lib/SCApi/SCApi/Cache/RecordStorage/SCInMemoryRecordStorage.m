#import "SCInMemoryRecordStorage.h"

#import "SCRecordStorageBase+OOP_Protected.h"

#import "FieldByNameIterationBlock.h"

#import "SCItemRecord.h"
#import "SCItemRecord+SCItemSource.h"

#import "SCItem+ItemRecord.h"

#import "SCFieldRecord.h"
#import "SCItemAndFields.h"
#import "SCItemSourcePOD.h"

@interface SCInMemoryRecordStorage()

// NSMutableDictionary<itemKey, SCItemAndFields>
@property ( nonatomic ) NSMutableDictionary* storage;
@property ( nonatomic ) BOOL shouldCheckRecordTypes;

@end


@implementation SCInMemoryRecordStorage

-(instancetype)initWithItemSource:( SCItemSourcePOD* )itemSource
{
    self = [ super initWithItemSource: itemSource ];
    if ( nil == self )
    {
        return nil;
    }

    self->_storage    = [ NSMutableDictionary new ];
    self->_shouldCheckRecordTypes = YES;
    
    return self;
}

-(void)cleanup
{
    self->_storage = [ NSMutableDictionary new ];
}

-(SCItemAndFields*)getStoredEntityForItemKey:( NSString* )itemKey
{
    NSParameterAssert( nil != itemKey );
    
    itemKey = [ self normalizeItemKey: itemKey ];
    return self->_storage[itemKey];
}

-(NSArray*)getCachedChildEntitiesForItemKey:( NSString* )itemKey
                             searchProperty:( SCItemPropertyGetter )searchProperty
{
    NSArray* allEntities = [ self->_storage allValues ];
    NSArray* childEntities = [ allEntities select: ^BOOL( SCItemAndFields* singleEntity )
    {
        NSParameterAssert( [ singleEntity isMemberOfClass: [ SCItemAndFields class ] ] );
      
        NSString* propertyForSearch = searchProperty( singleEntity.cachedItemRecord );
        return [ propertyForSearch isEqualToString: itemKey ];
    } ];
    
    return childEntities;
}

#pragma mark -
#pragma mark Utils
-(void)storeEntiry:( SCItemAndFields* )entity
           withKey:( NSString* )itemKey
{
    self->_storage[itemKey] = entity;
}

-(void)validateFieldsByNameForItemRecord:( SCItemRecord* )item
{
    if ( self->_shouldCheckRecordTypes )
    {
        [ item.fieldsByName enumerateKeysAndObjectsUsingBlock:^( NSString* fieldName, SCFieldRecord* fieldRecord, BOOL *stop)
         {
             NSParameterAssert( [ fieldName   isKindOfClass  : [ NSString      class ] ] );
             NSParameterAssert( [ fieldRecord isMemberOfClass: [ SCFieldRecord class ] ] );
         } ];
    }
}

-(FieldByNameIterationBlock)validateFieldsByNameTypesBlock
{
    BOOL shouldCheckRecordTypes = self->_shouldCheckRecordTypes;

    FieldByNameIterationBlock result =
    ^void( NSString* fieldName, SCFieldRecord* fieldRecord, BOOL* stop )
    {
        if ( shouldCheckRecordTypes )
        {
            NSParameterAssert( [ fieldName   isKindOfClass  : [ NSString      class ] ] );
            NSParameterAssert( [ fieldRecord isMemberOfClass: [ SCFieldRecord class ] ] );
        }
    };

    return [ result copy ];
}

//setItemRecordToAllFieldsBlock
-(FieldByNameIterationBlock)blockToPopulateFieldsWithItemRecord:( SCItemRecord* )item
{
    FieldByNameIterationBlock result =
    ^void( NSString* fieldName, SCFieldRecord* fieldRecord, BOOL* stop )
    {
        if ( ![ fieldRecord isMemberOfClass: [ SCFieldRecord class ] ] )
        {
            if ( self->_shouldCheckRecordTypes )
            {
                NSAssert( NO, @"SCFieldRecord expected" );
            }
            
            NSParameterAssert( NULL != stop );
            *stop = YES;
            
            return;
        }
        
        fieldRecord.itemRecord = item;
    };
    
    return [ result copy ];

}

-(void)unregisterItemForKey:( NSString* )itemKey
{
    SCItemAndFields* entity = [ self getStoredEntityForItemKey: itemKey ];
    NSParameterAssert( nil != entity );

    itemKey = [ self normalizeItemKey: itemKey ];

    [ self->_storage removeObjectForKey: itemKey ];
    entity.cachedItemRecord.itemId = nil;
}

-(NSArray*)allStoredEntities
{
    return [ self->_storage allValues ];
}

#pragma mark -
#pragma mark Field Flags
-(NSArray*)changedFieldsForItemId:( NSString* )itemId
{
    NSParameterAssert( nil != itemId );
    
    NSAssert( NO, @"not implemented" );
    return nil;
}

-(void)setRawValue:( NSString* )newRawValue
        forFieldId:( NSString* )fieldId
            itemId:( NSString* )itemId
{
    NSParameterAssert( nil != itemId );
    NSParameterAssert( nil != fieldId );
    newRawValue = newRawValue ?: @"";
    
    
    NSAssert( NO, @"not implemented" );
}

@end
