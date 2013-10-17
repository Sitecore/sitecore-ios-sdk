@interface WriteToPersistentStorageTest : SenTestCase
@end

@implementation WriteToPersistentStorageTest
{
@private
    SCCacheSettings* _cacheSettings;
    SCPersistentStorageBuilder* _builder;
    SCItemSourcePOD* _defaultSource;
    SCItemStorageKinds* _storageNode;
    
    NSString* _databasePath;
    NSString* _databaseDir;
    
    SCPersistentRecordStorage* _storeById  ;
    SCPersistentRecordStorage* _storeByPath;

    
@private
    SCPersistentRecordStorage* _storage;
    SCItemSourcePOD* _itemSource;
}

-(void)cleanupFS
{
    self->_databaseDir = [ NSString stringWithFormat: @"/tmp/%@", NSStringFromClass( [ self class ] ) ];
    self->_databasePath = [ self->_databaseDir stringByAppendingPathComponent: @"SqliteCache" ];
    
    NSFileManager* fm = [ NSFileManager defaultManager ];
    
    NSError* fileManagerError = nil;
    BOOL fileManagerResult = [ fm removeItemAtPath: self->_databaseDir
                                             error: &fileManagerError ];
    if ( !fileManagerResult )
    {
        NSLog( @"%@", fileManagerError );
    }
    
    [ fm createDirectoryAtPath: self->_databaseDir
   withIntermediateDirectories: YES
                    attributes: nil
                         error: &fileManagerError ];
}

-(void)setUp
{
    [ super setUp ];
    
    [ self cleanupFS ];
    
    self->_cacheSettings = [ SCCacheSettings new ];
    {
        self->_cacheSettings.cacheDbVersion = @"db-v1";
        self->_cacheSettings.host = @"http://mock-host:12345";
        self->_cacheSettings.userName = @"mock_domain/SomeUser";
    }
    
    self->_defaultSource = [ SCItemSourcePOD new ];
    {
        self->_defaultSource.database    = @"web";
        self->_defaultSource.language    = @"en" ;
        self->_defaultSource.site        = nil   ;
        self->_defaultSource.itemVersion = nil   ;
    }
    self->_itemSource = self->_defaultSource;
    
    self->_builder = [ [ SCPersistentStorageBuilder alloc ] initWithDatabasePathBase: self->_databasePath
                                                                            settings: self->_cacheSettings ];
    self->_storageNode = [ self->_builder newRecordStorageNodeForItemSource: self->_defaultSource ];
    {
        self->_storeById   = (SCPersistentRecordStorage*)self->_storageNode.itemRecordById  ;
        self->_storeByPath = (SCPersistentRecordStorage*)self->_storageNode.itemRecordByPath;
        
        self->_storage = self->_storeById;
    }
}

-(void)tearDown
{
    SEL CLOSE_DATABASES = @selector(closeDatabases);
    objc_msgSend( self->_storageNode.itemRecordById  , CLOSE_DATABASES );
    objc_msgSend( self->_storageNode.itemRecordByPath, CLOSE_DATABASES );
    
    self->_storageNode.itemRecordById   = nil;
    self->_storageNode.itemRecordByPath = nil;
    self->_storageNode = nil;
    
    [ self cleanupFS ];
    [super tearDown];
}

-(void)testWriteItemWithNoFields
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_itemSource copy ];
    record.displayName = @"home sweet home";
    record.itemTemplate = @"/sitecore/templates/system/folder with custom attributes";
    record.hasChildren = YES;
    
    
    NSString* key = [ record.itemId copy ];
    
    [ self->_storage registerItem: record
             withAllFieldsInCache: NO
           withAllChildrenInCache: NO
                           forKey: key ];
    
    NSInteger itemsCount = [ self->_storage.readDb selectIntScalar: @"SELECT COUNT(*) FROM [Items]" ];
    STAssertTrue( 1 == itemsCount, @"items count mismatch" );
    
    NSInteger fieldsCount = [ self->_storage.readDb selectIntScalar: @"SELECT COUNT(*) FROM [Fields]" ];
    STAssertTrue( 0 == fieldsCount, @"fields count mismatch" );
    
    
    NSUInteger actualItemsCount = 0;
    id<ESQueriedSet> itemRS = [ self->_storage.readDb select: @"SELECT * FROM [Items]" ];
    while ( [ itemRS next ] )
    {
        NSString* Timestamp = [ itemRS stringForColumn: @"Timestamp" ];
        NSString* ItemId = [ itemRS stringForColumn: @"ItemId" ];
        NSString* LongId = [ itemRS stringForColumn: @"LongId" ];
        NSString* Path = [ itemRS stringForColumn: @"Path" ];
        NSString* DisplayName = [ itemRS stringForColumn: @"DisplayName" ];
        NSString* template = [ itemRS stringForColumn: @"SitecoreTemplate" ];
        
        BOOL hasChildren = [ itemRS boolForColumn: @"HasChildren" ];
        BOOL IsAllChildrenCached = [ itemRS boolForColumn: @"IsAllChildrenCached" ];
        BOOL IsAllFieldsCached   = [ itemRS boolForColumn: @"IsAllFieldsCached" ];
        
        STAssertNotNil( Timestamp, @"timestamp mismatch" );
        
        STAssertEqualObjects( ItemId, record.itemId, @"itemId mismatch");
        STAssertEqualObjects( LongId, record.longID, @"longID mismatch");
        STAssertEqualObjects( Path  , record.path, @"Path mismatch");
        STAssertEqualObjects( template, record.itemTemplate, @"template mismatch" );
        
        STAssertEqualObjects( DisplayName, record.displayName, @"itemId mismatch");
        
        STAssertFalse( IsAllChildrenCached, @"IsAllChildrenCached mismatch");
        STAssertFalse( IsAllFieldsCached  , @"IsAllFieldsCached mismatch");
        STAssertTrue( hasChildren, @"has children flag mismatch" );
        
        ++actualItemsCount;
    }
    [ itemRS close ];

    STAssertTrue( 1 == actualItemsCount, @"items count mismatch" );
}

-(void)testWriteItemWithAllFields
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_itemSource copy ];
    record.displayName = @"home sweet home";
    
    SCFieldRecord* checklistField = [ SCFieldRecord new ];
    {
        checklistField.fieldId = @"{987-654-321-0}";
        checklistField.name = @"text text text";
        
        checklistField.type = @"Checklist";
        checklistField.rawValue = @"{FFFF-FFFF-FFFF}";
    }
    record.fieldsByName = @{ checklistField.name : checklistField };


    NSString* key = [ record.itemId copy ];
    
    [ self->_storage registerItem: record
             withAllFieldsInCache: YES
           withAllChildrenInCache: NO
                           forKey: key ];
    
    NSInteger itemsCount = [ self->_storage.readDb selectIntScalar: @"SELECT COUNT(*) FROM [Items]" ];
    STAssertTrue( 1 == itemsCount, @"items count mismatch" );
    
    NSInteger fieldsCount = [ self->_storage.readDb selectIntScalar: @"SELECT COUNT(*) FROM [Fields]" ];
    STAssertTrue( 1 == fieldsCount, @"fields count mismatch" );
    
    
    NSUInteger actualFieldsCount = 0;
    id<ESQueriedSet> fieldRS = [ self->_storage.readDb select: @"SELECT * FROM [Fields]" ];
    while ( [ fieldRS next ] )
    {
        NSString* ItemId = [ fieldRS stringForColumn: @"ItemId" ];
        NSString* FieldId = [ fieldRS stringForColumn: @"FieldId" ];
        NSString* Name = [ fieldRS stringForColumn: @"Name" ];
        NSString* Type = [ fieldRS stringForColumn: @"Type" ];
        NSString* RawValue = [ fieldRS stringForColumn: @"RawValue" ];
        
        STAssertEqualObjects( ItemId  , record.itemId           , @"itemId mismatch"  );
        STAssertEqualObjects( FieldId , checklistField.fieldId  , @"FieldId mismatch" );
        STAssertEqualObjects( Name    , checklistField.name     , @"Name mismatch"    );
        STAssertEqualObjects( Type    , checklistField.type     , @"Type mismatch"    );
        STAssertEqualObjects( RawValue, checklistField.rawValue , @"RawValue mismatch");
        
        ++actualFieldsCount;
    }
    [ fieldRS close ];
    
    STAssertTrue( 1 == actualFieldsCount, @"items count mismatch" );
}

@end
