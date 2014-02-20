#import "SCGenericRecordCache.h"
#import "SCItemStorageKinds.h"

#import "SCItemRecord.h"
#import "SCItemRecord+SCItemSource.h"
#import "SCItemRecord+IsCacheStub.h"

#import "SCItemRecordPropertyFactory.h"

#import "SCFieldRecord.h"

#import "SCItemSource.h"
#import "SCItemRecordStorageRW.h"
#import "SCItemSourcePOD.h"
#import "SCReadItemsRequest+SCItemSource.h"
#import "SCReadItemsRequest+AllFields.h"
#import "SCItemRecordStorageBuilder.h"

// @adk - Try setting this to "0" while tuning performance
#define IS_ITEM_SOURCE_INTEGRITY_CHECK_ENABLED 1

static JFFPredicateBlock ITEMS_WITHOUT_CACHE_STUBS = ^BOOL(SCItemRecord* blockItemRecord)
{
    return !blockItemRecord.isCacheStub;
};

@interface SCGenericRecordCache()

@property ( nonatomic ) NSMutableDictionary* storageBySource;

@end

@implementation SCGenericRecordCache
{
    NSLocale* _posixLocale;
}


-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithStorageBuilder:( id<SCItemRecordStorageBuilder> )storageBuilder
{
    NSParameterAssert( nil != storageBuilder );
    
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }

    self->_storageBuilder = storageBuilder;
    self->_storageBySource = [ NSMutableDictionary new ];
    self->_posixLocale = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    
    return self;
}

#pragma mark -
#pragma mark SCItemRecordCache
-(SCItemRecord*)itemRecordForItemWithId:( NSString* )itemId
                             itemSource:( id<SCItemSource> )itemSource
{
    //NSParameterAssert( nil != itemId     );
    NSParameterAssert( nil != itemSource );
    NSParameterAssert( [ itemSource respondsToSelector: @selector(toPlainStructure) ] );
    if ( nil == itemId )
    {
        return nil;
    }
    
    
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    SCItemRecord* result = [ storage.itemRecordById itemRecordForItemKey: itemId ];    
    if ( result.isCacheStub )
    {
        return nil;
    }
    
    return result;
}

-(SCItemRecord*)itemRecordForItemWithPath:( NSString* )itemPath
                               itemSource:( id<SCItemSource> )itemSource
{
    NSParameterAssert( nil != itemPath   );
    NSParameterAssert( nil != itemSource );
    NSParameterAssert( [ itemSource respondsToSelector: @selector(toPlainStructure) ] );
    
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    SCItemRecord* result = [ storage.itemRecordByPath itemRecordForItemKey: itemPath ];
    if ( result.isCacheStub )
    {
        return nil;
    }
    
    return result;
}

-(SCFieldRecord*)fieldWithName:( NSString* )fieldName
                        itemId:( NSString* )itemId
                    itemSource:( id<SCItemSource> )itemSource
{
    //NSParameterAssert( nil != itemId     );
    NSParameterAssert( nil != itemSource );
    NSParameterAssert( nil != fieldName  );
    NSParameterAssert( [ itemSource respondsToSelector: @selector(toPlainStructure) ] );
    if ( nil == itemId )
    {
        return nil;
    }
    
    
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    SCFieldRecord* result = [ storage.itemRecordById fieldWithName: fieldName
                                                           itemKey: itemId ];

    return result;
}


// of SCField*
-(NSDictionary*)cachedFieldsByNameForItemId:( NSString* )itemId
                                 itemSource:( id<SCItemSource> )itemSource
{
    //NSParameterAssert( nil != itemId     );
    NSParameterAssert( nil != itemSource );
    NSParameterAssert( [ itemSource respondsToSelector: @selector(toPlainStructure) ] );
    if ( nil == itemId )
    {
        return nil;
    }
    
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    NSDictionary* result = [ storage.itemRecordById cachedFieldsByNameForItemKey: itemId ];
    
    return result;
}

-(NSDictionary*)allFieldsByNameForItemId:( NSString* )itemId
                              itemSource:( id<SCItemSource> )itemSource
{
    //NSParameterAssert( nil != itemId     );
    NSParameterAssert( nil != itemSource );
    NSParameterAssert( [ itemSource respondsToSelector: @selector(toPlainStructure) ] );
    if ( nil == itemId )
    {
        return nil;
    }
    
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    NSDictionary* result = [ storage.itemRecordById allFieldsByNameForItemKey: itemId ];
    
    return result;
}

// of SCItemRecord*
-(NSArray*)cachedChildrenForItemWithId:( NSString* )itemId
                            itemSource:( id<SCItemSource> )itemSource
{
    //NSParameterAssert( nil != itemId     );
    NSParameterAssert( nil != itemSource );
    NSParameterAssert( [ itemSource respondsToSelector: @selector(toPlainStructure) ] );
    if ( nil == itemId )
    {
        return nil;
    }
    
    SCItemPropertyGetter idGetter = [ SCItemRecordPropertyFactory parentIdGetter ];
    
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    NSArray* result = [ storage.itemRecordById cachedChildrenForItemKey: itemId
                                                         searchProperty: idGetter ];
    
    result = [ result select: ITEMS_WITHOUT_CACHE_STUBS ];
    
    return result;
}


// of SCItemRecord*
-(NSArray*)allChildrenForItemWithItemWithId:( NSString* )itemId
                                 itemSource:( id<SCItemSource> )itemSource
{
    //NSParameterAssert( nil != itemId     );
    NSParameterAssert( nil != itemSource );
    if ( nil == itemId )
    {
        return nil;
    }
    
    SCItemPropertyGetter idGetter = [ SCItemRecordPropertyFactory parentIdGetter ];
    
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    NSArray* result = [ storage.itemRecordById allChildrenForItemKey: itemId
                                                      searchProperty: idGetter ];
    result = [ result select: ITEMS_WITHOUT_CACHE_STUBS ];
    
    return result;
}

// of SCItemRecord*
-(NSArray*)allChildrenForItemWithItemWithPath:( NSString* )itemPath
                                   itemSource:( id<SCItemSource> )itemSource
{
    NSParameterAssert( nil != itemPath   );
    NSParameterAssert( nil != itemSource );
    
    SCItemPropertyGetter pathGetter = [ SCItemRecordPropertyFactory parentPathGetter ];
    
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    NSArray* result = [ storage.itemRecordByPath allChildrenForItemKey: itemPath
                                                        searchProperty: pathGetter ];
    result = [ result select: ITEMS_WITHOUT_CACHE_STUBS ];
    
    return result;
}


#pragma mark -
#pragma mark SCMutableItemRecordCache
-(SCItemRecord*)findParentRecordInResponseItems:( NSArray* )items
                                     forRequest:( SCReadItemsRequest * )request
{
    SCItemRecord* childItemRecord = [ request getAnyChildItemRecordFromItems: items ];
    NSString* parentItemId = [ childItemRecord.parentId lowercaseStringWithLocale: self->_posixLocale ];
    
    JFFPredicateBlock parentSearchPredicate = ^BOOL( SCItemRecord* currentItem )
    {
        NSString* currentItemId = [ currentItem.itemId lowercaseStringWithLocale: self->_posixLocale ];
        
        return [ currentItemId isEqualToString: parentItemId ];
    };
    
    SCItemRecord* parentRecord = [ items firstMatch: parentSearchPredicate ];
    return parentRecord;
}


-(SCItemRecord*)newParentRecordStubForChildItems:( NSArray* )childItems
{
    // @adk : using all items since
    // parent-child relation handling implementaion may change
    SCItemRecord* childRecord = [ childItems lastObject ];
    NSParameterAssert( [ childRecord isMemberOfClass: [ SCItemRecord class ] ] );

    SCItemRecord* result = [ SCItemRecord new ];
    {
        result.hasChildren = YES;
        
        result.path   = childRecord.parentPath  ;
        result.itemId = childRecord.parentId    ;
        result.longID = childRecord.parentLongId;
        result.itemSource = childRecord.itemSource;
        
        // @adk [?]
        // Should API context be retained by fake items ?
        result.apiSession     = childRecord.apiSession;
        result.mainApiSession = childRecord.mainApiSession;
    }

    return result;
}

// NSArray<ItemRecord>
-(void)cacheResponseItems:( NSArray* )items
               forRequest:( SCReadItemsRequest * )request
               apiSession:( SCExtendedApiSession* )apiSession
{
    NSParameterAssert( nil != items      );
    NSParameterAssert( nil != request    );
    NSParameterAssert( nil != apiSession );    
    if ( ![ items hasElements ] )
    {
        return;
    }
    
    SCItemSourcePOD* plainSource = [ [ items lastObject ] getSource ];

    for ( SCItemRecord* itemRecord in items )
    {
        #if IS_ITEM_SOURCE_INTEGRITY_CHECK_ENABLED
        {
            NSParameterAssert( [ [ itemRecord getSource ] isEqualToItemSource: plainSource ] );
        }
        #endif
        
        itemRecord.apiSession = apiSession;
    }

    
    
    SCItemStorageKinds* storage = [ self getStorageForSource: plainSource ];
    if ( nil == storage )
    {
        storage = [ self newStorageForSource: plainSource ];
        self->_storageBySource[ plainSource ] = storage;
    }
    

    BOOL isAllFieldsStored          = request.isAllFieldsRequested;
    BOOL isChildScopeRequested      = ( SCItemReaderChildrenScope & request.scope );
    BOOL isRequestCanHaveParentItem = ( SCItemReaderRequestQuery != request.requestType );
    
    SCItemRecord* parentRecord = nil;
    if ( isChildScopeRequested && isRequestCanHaveParentItem )
    {
        SCItemRecord* childItemRecord = [ request getAnyChildItemRecordFromItems: items ];
        if ( nil != childItemRecord )
        {
            parentRecord = [ self findParentRecordInResponseItems: items
                                                       forRequest: request ];
            
            if ( nil == parentRecord )
            {
                parentRecord = [ self itemRecordForItemWithId: childItemRecord.parentId
                                                   itemSource: plainSource ];
            }
            if ( nil == parentRecord )
            {
                parentRecord = [ self newParentRecordStubForChildItems: items ];
            }
            
            
            [ self registerItem: parentRecord
           withAllFieldsInCache: isAllFieldsStored
         withAllChildrenInCache: YES
                      inStorage: storage ];
        }
   }
    
    
    for ( SCItemRecord* item in items )
    {
        if ( parentRecord == item )
        {
            continue;
        }
        
        [ self registerItem: item
       withAllFieldsInCache: isAllFieldsStored
     withAllChildrenInCache: NO
                  inStorage: storage ];
    }
}


-(void)didRemovedItemRecord:( SCItemRecord* )record
{
    NSParameterAssert( nil != record );
    
    SCItemSourcePOD* itemSource = [ record getSource ];
    SCItemStorageKinds* storage = [ self getStorageForSource: itemSource ];
    
    [ self unregisterItemForKey: record
                      inStorage: storage ];
}

-(void)cleanupSource:( id<SCItemSource> )itemSource
{
    NSParameterAssert( nil != itemSource );
    NSParameterAssert( [ itemSource respondsToSelector: @selector(toPlainStructure) ] );
    
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    [ storage.itemRecordById   cleanup ];
    [ storage.itemRecordByPath cleanup ];
}

-(void)cleanupAll
{
    self->_storageBySource = [ NSMutableDictionary new ];
}


#pragma mark -
#pragma mark Utils
-(SCItemStorageKinds*)getStorageForSource:( SCItemSourcePOD* )itemSource
{
    NSParameterAssert( nil != itemSource );
    
    SCItemStorageKinds* result = self->_storageBySource[ itemSource ];
    return result;
}

-(SCItemStorageKinds*)newStorageForSource:( SCItemSourcePOD* )itemSource
{
    SCItemStorageKinds* result = [ self->_storageBuilder newRecordStorageNodeForItemSource: itemSource ];

    return result;
}


#pragma mark -
#pragma mark SCMutableItemRecordStorage
-(void)registerItem:( SCItemRecord* )item
withAllFieldsInCache:( BOOL )isAllFieldsCached
withAllChildrenInCache:( BOOL )isAllChildrenCached
          inStorage:( SCItemStorageKinds* )storage
{
    [ storage.itemRecordById registerItem: item
                     withAllFieldsInCache: isAllFieldsCached
                   withAllChildrenInCache: isAllChildrenCached
                                   forKey: item.itemId ];

    [ storage.itemRecordByPath registerItem: item
                       withAllFieldsInCache: isAllFieldsCached
                     withAllChildrenInCache: isAllChildrenCached
                                     forKey: item.path ];
}

-(void)unregisterItemForKey:( SCItemRecord* )item
                  inStorage:( SCItemStorageKinds* )storage
{    
    [ storage.itemRecordById   unregisterItemForKey: item.itemId ];
    [ storage.itemRecordByPath unregisterItemForKey: item.path   ];
}


-(NSArray*)allCachedItemsForItemSource:( id<SCItemSource> )itemSource
{
    SCItemStorageKinds* storage = [ self getStorageForSource: [ itemSource toPlainStructure ] ];
    
    return [ storage.itemRecordById allStoredRecords ];
}


#pragma mark -
#pragma mark Field Flags
-(void)setRawValue:( NSString* )newRawValue
        forFieldId:( NSString* )fieldId
            itemId:( NSString* )itemId
        itemSource:( id<SCItemSource> )itemSource
{
    NSParameterAssert( nil != itemId );
    NSParameterAssert( nil != fieldId );
    NSParameterAssert( nil != itemSource );

    SCItemSourcePOD* plainSource = [ itemSource toPlainStructure ];
    SCItemStorageKinds* storageNode = [ self getStorageForSource: plainSource ];
    
    id<SCItemRecordStorageRW> idStorage = storageNode.itemRecordById;
    [ idStorage setRawValue: newRawValue
                 forFieldId: fieldId
                     itemId: itemId ];
}

-(NSArray*)changedFieldsForItemId:( NSString* )itemId
                       itemSource:( id<SCItemSource> )itemSource
{
    NSParameterAssert( nil != itemId );
    NSParameterAssert( nil != itemSource );
    
    SCItemSourcePOD* plainSource = [ itemSource toPlainStructure ];
    SCItemStorageKinds* storageNode = [ self getStorageForSource: plainSource ];
    
    id<SCItemRecordStorageRW> idStorage = storageNode.itemRecordById;
    return [ idStorage changedFieldsForItemId: itemId ];
}

@end
