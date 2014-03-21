#import "SCPersistentRecordStorage.h"

#import "SCExtendedApiSession.h"
#import "SCItemAndFields.h"

#import "SCItemRecord+SCItemSource.h"
#import "SCFieldRecord+SCItemSource.h"

#import "SCCachedFieldRecord.h"

using namespace ::Utils;

static NSString* const SQL_INSERT_VALUE_SEPARATOR = @",\n   ";

@interface SCPersistentRecordStorage()

@property ( nonatomic, weak ) SCExtendedApiSession* apiSession;

@end

@implementation SCPersistentRecordStorage

-(void)dealloc
{
    if ( self->_shouldCloseReadDb )
    {
        [ self->_readDb close ];
    }
    
    if ( self->_shouldCloseWriteDb )
    {
        [ self->_writeDb close ];
    }
}

-(instancetype)initWithItemSource:( SCItemSourcePOD* )itemSource
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithApiSession:( SCExtendedApiSession* )apiSession
                       itemSource:( SCItemSourcePOD* )itemSource
                     readDatabase:( id<ESReadOnlyDbWrapper> )readDb
                    writeDatabase:( id<ESWritableDbWrapper, ESTransactionsWrapper> )writeDb
                itemKeyColumnName:( NSString* )itemKeyColumnName
{
    self = [ super initWithItemSource: itemSource ];
    if ( nil == self )
    {
        return nil;
    }
    
    self.apiSession = apiSession;
    self->_itemKeyColumnName = itemKeyColumnName;
    self->_readDb  = readDb;
    self->_writeDb = writeDb;
    
    return self;
}

#pragma mark -
#pragma mark Constants
+(NSString*)itemIdColumn
{
    return @"ItemId";
}

+(NSString*)itemPathColumn
{
    return @"Path";
}

#pragma mark -
#pragma mark SCRecordStorageBase
-(SCItemAndFields*)getStoredEntityForItemKey:( NSString* )itemKey
{
    SCItemAndFields* result = nil;
    
    SCItemAndFields* resultWithoutFields = [ self sqlItemRecordForItemKey: itemKey ];
    if ( nil != resultWithoutFields )
    {
        result = [ self fillStoredEntityWithFields: resultWithoutFields ];
    }

    return result;
}

-(SCItemAndFields*)fillStoredEntityWithFields:( SCItemAndFields* )resultWithoutFields
{
    NSArray* fields = nil;
    NSArray* fieldNames = nil;
    BOOL isAllFieldsReceived = NO;
    BOOL isAllChildrenReceived = NO;
    NSDictionary* fieldsByName = nil;
    
    SCItemRecord* item = nil;
    {
        item = resultWithoutFields.cachedItemRecord;
        isAllFieldsReceived   = resultWithoutFields.isAllFieldItemsCached;
        isAllChildrenReceived = resultWithoutFields.isAllChildItemsCached;
    }
    NSParameterAssert( nil != item.itemId );
    
    // @adk : do not use "itemKey" since it may be any other column
    fields = [ self sqlFieldRecordsForItemKey: item.itemId ];
    if ( [ fields hasElements ] )
    {
        fieldNames = [ fields map: ^NSString*( SCFieldRecord* fieldRecord )
        {
           NSParameterAssert( [ fieldRecord isMemberOfClass: [ SCCachedFieldRecord class ] ] );
           NSParameterAssert( nil != fieldRecord.name );

           return fieldRecord.name;
        } ];
        
        fieldsByName = [ NSDictionary dictionaryWithObjects: fields
                                                    forKeys: fieldNames ];
    }
    
    SCItemAndFields* result =
    [ [ SCItemAndFields alloc ] initWithItemRecord: item
                                            fields: fieldsByName
                               isAllFieldsReceived: isAllFieldsReceived
                             isAllChildrenReceived: isAllChildrenReceived ];
    [ self restoreRelationsForRestoredEntity: result ];
    
    return result;
}

-(SCItemAndFields*)sqlItemRecordForDataSource:( id<ESQueriedSet> )itemRS
{
    if ( nil == itemRS )
    {
        return nil;
    }
    
    SCItemRecord* item = nil;
    NSString* itemId           = nil;
    NSString* longId           = nil;
    NSString* path             = nil;
    NSString* displayName      = nil;
    NSString* sitecoreTemplate = nil;
    
    BOOL hasChildren         = NO;
    BOOL isAllChildrenCached = NO ;
    BOOL isAllFieldsCached   = NO ;
    
    
    {
        itemId         = [ itemRS stringForColumn: @"ItemId"             ];
        longId         = [ itemRS stringForColumn: @"LongId"             ];
        path           = [ itemRS stringForColumn: @"Path"               ];
        displayName    = [ itemRS stringForColumn: @"DisplayName"        ];
        sitecoreTemplate = [ itemRS stringForColumn: @"SitecoreTemplate" ];
        
        hasChildren         = [ itemRS boolForColumn: @"HasChildren"         ];
        isAllChildrenCached = [ itemRS boolForColumn: @"IsAllChildrenCached" ];
        isAllFieldsCached   = [ itemRS boolForColumn: @"IsAllFieldsCached"   ];
    }
    
    item = [ SCItemRecord new ];
    {
        item.itemId      = itemId     ;
        item.longID      = longId     ;
        item.path        = path       ;
        item.displayName = displayName;
        item.itemTemplate = sitecoreTemplate;
        item.hasChildren = hasChildren;
    }
    
    SCItemAndFields* result =
    [ [ SCItemAndFields alloc ] initWithItemRecord: item
                                            fields: nil
                               isAllFieldsReceived: isAllFieldsCached
                             isAllChildrenReceived: isAllChildrenCached ];
    
    return result;
}

-(SCItemAndFields*)sqlItemRecordForItemKey:( NSString* )itemKey
{
    NSParameterAssert( nil != itemKey );
    
    static NSString* const queryFormat =
    @"SELECT * \n"
    @"FROM [Items] \n"
    @"WHERE [%@] = %@ \n"
    @"LIMIT 1;";

    NSString* sqlFriendlyItemKey = [ NSString sqlite3QuotedStringOrNull: itemKey ];
    NSString* query = [ NSString stringWithFormat: queryFormat,
                         self->_itemKeyColumnName,
                         sqlFriendlyItemKey ];
    id<ESQueriedSet> itemRS = [ self->_readDb select: query ];
    
    SCItemAndFields* result = nil;
    if ( [ itemRS next ] )
    {
         result = [ self sqlItemRecordForDataSource: itemRS ];
    }
    [ itemRS close ];
    
    return result;
}

-(NSArray*)sqlFieldRecordsForItemKey:( NSString* )itemId
{
    NSParameterAssert( nil != itemId );
    
    static NSString* const queryFormat =
    @"SELECT * \n"
    @"FROM [Fields] \n"
    @"WHERE [ItemId] = %@ \n";
    
    NSString* sqlFriendlyItemId = [ NSString sqlite3QuotedStringOrNull: itemId ];
    NSString* query = [ NSString stringWithFormat: queryFormat,
                       sqlFriendlyItemId ];
    id<ESQueriedSet> fieldRS = [ self->_readDb select: query ];
    if ( nil == fieldRS )
    {
        return nil;
    }
    
    SCFieldRecord* field = nil;
    int fieldIdIndex   = [ fieldRS columnIndexForName: @"FieldId"  ];
    int fieldNameIndex = [ fieldRS columnIndexForName: @"Name"     ];
    int fieldTypeIndex = [ fieldRS columnIndexForName: @"Type"     ];
    int rawValueIndex  = [ fieldRS columnIndexForName: @"RawValue" ];


    NSMutableArray* result = [ NSMutableArray new ];
    while ( [ fieldRS next ] )
    {
        field = [ SCCachedFieldRecord new ];
        {
            field.fieldId  = [ fieldRS stringForColumnIndex: fieldIdIndex   ];
            field.name     = [ fieldRS stringForColumnIndex: fieldNameIndex ];
            field.type     = [ fieldRS stringForColumnIndex: fieldTypeIndex ];
            field.rawValue = [ fieldRS stringForColumnIndex: rawValueIndex  ];
        }
        
        [ result addObject: field ];
    }
    [ fieldRS close ];
    
    return [ NSArray arrayWithArray: result ];
}

-(void)restoreRelationsForRestoredEntity:( SCItemAndFields* )entity
{
    // @adk - ensure ARC does not deallocate context while recovering items
    SCExtendedApiSession* context = self->_apiSession;
    
    SCItemRecord* item = entity.cachedItemRecord;
    {
        item.itemSource = self.itemSourcePOD;
        item.apiSession = self.apiSession;
        item.mainApiSession = context.mainSession;
    }
    
    item.fieldsByName = entity.cachedItemFieldsByName;
    
    for ( SCCachedFieldRecord* field in [ entity.cachedItemFieldsByName allValues ] )
    {
        NSParameterAssert( [ field isMemberOfClass: [ SCCachedFieldRecord class ] ]);
        field.itemRecord = item;
        field.apiSession = context;

        // @adk : hotfix for nil "field.itemRecord" case
        {
            field.itemId     = item.itemId;
            field.itemSource = self.itemSourcePOD;
        }
    }
}

-(NSArray*)getCachedChildEntitiesForItemKey:( NSString* )itemKey
                             searchProperty:( SCItemPropertyGetter )searchProperty
{
    NSParameterAssert( nil != itemKey );
    NSParameterAssert( nil != searchProperty );

    SCItemRecord* recordForKey = [ self itemRecordForItemKey: itemKey ];
    if ( nil == recordForKey )
    {
        return nil;
    }
    
    static NSString* const childItemsQueryFormat =
    @"SELECT *\n"
    @"FROM [Items]\n"
    @"WHERE [LongId] LIKE '%@/%%'"
    @"AND NOT [LongId] LIKE '%@/%%/%%'";

    NSParameterAssert( nil != recordForKey.longID );
    NSString* sqliteLongId = [ NSString sqlite3EscapeString: recordForKey.longID ];
    NSString* query = [ NSString stringWithFormat: childItemsQueryFormat, sqliteLongId, sqliteLongId ];
    
    NSArray* result = [ self storedEntitiesForQuery: query ];
    if ( nil == result )
    {
        // @adk : using empty array to fit unit tests.
        return @[];
    }

    return result;
}

#pragma mark -
#pragma mark SCItemRecordStorage
-(NSArray*)allStoredEntities
{
    return [ self storedEntitiesForQuery: @"SELECT * FROM [Items]" ];
}

-(NSArray*)storedEntitiesForQuery:( NSString* )query
{
    id<ESQueriedSet> itemsRS = [ self->_readDb select: query ];
    if ( nil == itemsRS )
    {
        return nil;
    }
    
    NSMutableArray* result = [ NSMutableArray new ];
    
    SCItemAndFields* entityWithoutFields = nil;
    SCItemAndFields* entity = nil;
    while ( [ itemsRS next ] )
    {
        entityWithoutFields = [ self sqlItemRecordForDataSource: itemsRS ];
        entity = [ self fillStoredEntityWithFields: entityWithoutFields ];
        
        [ result addObject: entity ];
    }
    
    if ( ![ result hasElements ] )
    {
        return nil;
    }
    
    return [ NSArray arrayWithArray: result ];
}

#pragma mark -
#pragma mark SCMutableItemRecordStorage
-(void)registerItem:( SCItemRecord* )item
withAllFieldsInCache:( BOOL )isAllFieldsCached
withAllChildrenInCache:( BOOL )isAllChildrenCached
             forKey:( NSString* )key
{
    if ( nil == self->_writeDb )
    {
        return;
    }
    
    NSParameterAssert( nil != item );
    NSParameterAssert( nil != key  );
    
    if ( nil == self->_writeDb )
    {
        return;
    }
    
    NSParameterAssert( [ NSObject object: item.itemSource isEqualTo: self.itemSource ] );
    
    BOOL isWriteSuccessfull = YES;
    id<ESTransactionsWrapper> transactionDb = self->_writeDb;
    GuardCallbackBlock transactionGuardBlock = ^void( void )
    {
        [ transactionDb rollbackTransaction ];
    };

    [ transactionDb beginTransaction ];
    ObjcScopedGuard transactionGuard( transactionGuardBlock );
    {
        isWriteSuccessfull &= [ self storeItemRecord: item
                                withAllFieldsInCache: isAllFieldsCached
                              withAllChildrenInCache: isAllChildrenCached ];
        if ( !isWriteSuccessfull )
        {
            return;
        }
        
        isWriteSuccessfull &= [ self storeFieldsForItemRecord: item ];
        if ( !isWriteSuccessfull )
        {
            return;
        }
    }
    transactionGuard.Release();
    [ transactionDb commitTransaction ];
}

-(void)unregisterItemForKey:( NSString* )key
{
    NSParameterAssert( nil != key );
    
    static NSString* const queryFormat =
    @"DELETE FROM [%@]\n"
    @"WHERE [ItemId] = %@;";

    NSString* sqliteKey = [ NSString sqlite3QuotedStringOrNull: key ];
    NSString* deleteItemQuery  = [ NSString stringWithFormat: queryFormat, @"Items" , sqliteKey ];
    NSString* deleteFieldQuery = [ NSString stringWithFormat: queryFormat, @"Fields", sqliteKey ];

    [ self cleanupItemsTable: deleteItemQuery
                 fieldsTable: deleteFieldQuery ];
}

-(void)cleanup
{
    [ self cleanupItemsTable: @"DELETE FROM [Items]"
                 fieldsTable: @"DELETE FROM [Fields]" ];
}

-(void)cleanupItemsTable:( NSString* )deleteItemQuery
             fieldsTable:( NSString* )deleteFieldQuery
{
    if ( nil == self->_writeDb )
    {
        return;
    }
    
    // @adk - writeDB for path--->item storage is nil
    NSParameterAssert( [ self.itemKeyColumnName isEqualToString: [ [ self class ] itemIdColumn ] ]);
    
    id<ESTransactionsWrapper> transactionDb = self->_writeDb;
    GuardCallbackBlock transactionGuardBlock = ^void( void )
    {
        [ transactionDb rollbackTransaction ];
    };
    
    NSError* sqlDeleteError = nil;
    BOOL sqlDeleteResult = YES;
    
    [ transactionDb beginTransaction ];
    ObjcScopedGuard transactionGuard( transactionGuardBlock );
    {
        sqlDeleteResult &= [ self->_writeDb sqlDelete: deleteItemQuery
                                                error: &sqlDeleteError ];
        [ sqlDeleteError writeErrorToNSLog ];
        if ( !sqlDeleteResult )
        {
            return;
        }
        
        sqlDeleteResult &= [ self->_writeDb sqlDelete: deleteFieldQuery
                                                error: &sqlDeleteError ];
        [ sqlDeleteError writeErrorToNSLog ];
        if ( !sqlDeleteResult )
        {
            return;
        }
    }
    transactionGuard.Release();
    [ transactionDb commitTransaction ];
}

#pragma mark -
#pragma mark WriteHelpers
-(BOOL)storeItemRecord:( SCItemRecord* )item
  withAllFieldsInCache:( BOOL )isAllFieldsCached
withAllChildrenInCache:( BOOL )isAllChildrenCached
{
    NSError* sqlError = nil;
    NSString* queryFormat =
    @"INSERT OR REPLACE \n"
    @"INTO [Items] \n"
    @"(\n"
    @"   [Timestamp]           , \n"
    @"   [ItemId]              , \n"
    @"   [LongId]              , \n"
    @"   [Path]                , \n"
    @"   [DisplayName]         , \n"
    @"   [SitecoreTemplate]    , \n"
    @"   [HasChildren]         , \n"
    @"   [IsAllChildrenCached] , \n"
    @"   [IsAllFieldsCached]     \n"
    @")\n"
    @"VALUES \n"
    @"(\n"
    @"%@, \n"
    @"   %d, \n"
    @"   %d, \n"
    @"   %d \n"
    @");";
    
    NSArray* itemInfo =
    @[
      @"strftime('%s','now')", //timestamp
      [ NSString sqlite3QuotedStringOrNull: item.itemId ],
      [ NSString sqlite3QuotedStringOrNull: item.longID ],
      [ NSString sqlite3QuotedStringOrNull: item.path ],
      [ NSString sqlite3QuotedStringOrNull: item.displayName ],
      [ NSString sqlite3QuotedStringOrNull: item.itemTemplate ]
      ];
    NSString* strItemInfo = [ itemInfo componentsJoinedByString: SQL_INSERT_VALUE_SEPARATOR ];
    
    NSInteger iHasChildren = item.hasChildren ? 1 : 0;
    NSInteger iAllChildrenCached = isAllChildrenCached ? 1 : 0;
    NSInteger iAllFieldsCached   = isAllFieldsCached   ? 1 : 0;
    NSString* query = [ NSString stringWithFormat: queryFormat, strItemInfo,
                       iHasChildren, iAllChildrenCached, iAllFieldsCached ];
    
    BOOL result = [ self->_writeDb insert: query
                                    error: &sqlError ];
    [ sqlError writeErrorToNSLog ];
    
    return result;
}

-(BOOL)storeFieldsForItemRecord:( SCItemRecord* )item
{
    NSArray* fields = [ item.fieldsByName allValues ];
    NSString* itemId = item.itemId;
    BOOL result = YES;
    
    for ( SCFieldRecord* singleField in fields )
    {
        NSParameterAssert( [ singleField isKindOfClass: [ SCFieldRecord class ] ] );
        result &= [ self storeFieldRecord: singleField
                            forItemWithId: itemId ];
    }
    
    return result;
}

-(BOOL)storeFieldRecord:( SCFieldRecord* )field
          forItemWithId:( NSString* )itemId
{
    NSError* sqlError = nil;
    NSString* queryFormat =
    @"INSERT OR REPLACE \n"
    @"INTO [Fields] \n"
    @"(\n"
    @"   [ItemId]   , \n"
    @"   [FieldId]  , \n"
    @"   [Name]     , \n"
    @"   [Type]     , \n"
    @"   [RawValue] , \n"
    @"   [HasLocalModifications] \n"
    @")\n"
    @"VALUES \n"
    @"(\n"
    @"%@ \n"
    @", %d"
    @");";
    
    static const NSInteger NO_LOCAL_MODIFICATIONS = 0;
    
    NSArray* fieldInfo =
    @[
      [ NSString sqlite3QuotedStringOrNull: itemId         ],
      [ NSString sqlite3QuotedStringOrNull: field.fieldId  ],
      [ NSString sqlite3QuotedStringOrNull: field.name     ],
      [ NSString sqlite3QuotedStringOrNull: field.type     ],
      [ NSString sqlite3QuotedStringOrNull: field.rawValue ]
    ];
    NSString* strFieldInfo = [ fieldInfo componentsJoinedByString: SQL_INSERT_VALUE_SEPARATOR ];
    
    
    NSString* query = [ NSString stringWithFormat: queryFormat, strFieldInfo, NO_LOCAL_MODIFICATIONS ];
    
    BOOL result = [ self->_writeDb insert: query
                                    error: &sqlError ];
    [ sqlError writeErrorToNSLog ];
    
    return result;
}

#pragma mark -
#pragma mark Testing
-(void)closeDatabases
{
    [ self->_readDb  close ];
    [ self->_writeDb close ];
}

#pragma mark -
#pragma mark Field Flags
-(NSArray*)changedFieldsForItemId:( NSString* )itemId
{
    NSParameterAssert( nil != itemId );

    static NSString* const queryFormat =
    @"SELECT [Name] \n"
    @"FROM [Fields] \n"
    @"WHERE \n"
    @"   [ItemId]  = %@ AND \n"
    @"   [HasLocalModifications] = 1 \n"
    @"ORDER BY [Name]";
    
    NSString* sqlItemId = [ NSString sqlite3QuotedStringOrNull: itemId ];
    
    NSString* query = [ NSString stringWithFormat: queryFormat, sqlItemId ];
    
    NSError* sqlError = nil;
    NSArray* result = [ self->_readDb selectStringArray: query ];
    [ sqlError writeErrorToNSLog ];

    if ( ![ result hasElements ] )
    {
        return nil;
    }
    
    return result;
}

-(void)setRawValue:( NSString* )newRawValue
        forFieldId:( NSString* )fieldId
            itemId:( NSString* )itemId
{
    NSParameterAssert( nil != itemId );
    NSParameterAssert( nil != fieldId );

    static const NSInteger HAS_LOCAL_MODIFICATIONS = 1;
    
    static NSString* const queryFormat =
    @"UPDATE [Fields] \n"
    @"SET \n"
    @"   [RawValue] = %@, \n"
    @"   [HasLocalModifications] = %ld \n"
    @"WHERE \n"
    @"   [ItemId] = %@ AND \n"
    @"   [FieldId] = %@";
    
    NSString* sqlRawValue = [ NSString sqlite3QuotedStringOrNull: newRawValue ];
    NSString* sqlItemId   = [ NSString sqlite3QuotedStringOrNull: itemId      ];
    NSString* sqlFieldId  = [ NSString sqlite3QuotedStringOrNull: fieldId     ];
    
    NSString* query = [ NSString stringWithFormat: queryFormat,
                       sqlRawValue,
                       static_cast<long>( HAS_LOCAL_MODIFICATIONS ),
                       sqlItemId,
                       sqlFieldId ];
    
    NSError* sqlError = nil;
    [ self->_writeDb update: query
                      error: &sqlError ];
    [ sqlError writeErrorToNSLog ];
}

@end
