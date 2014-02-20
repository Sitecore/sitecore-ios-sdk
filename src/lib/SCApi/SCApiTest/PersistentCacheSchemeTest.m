@interface PersistentCacheSchemeTest : XCTestCase
@end

@implementation PersistentCacheSchemeTest
{
    SCCacheSettings* _cacheSettings;
    SCPersistentStorageBuilder* _builder;
    SCItemSourcePOD* _defaultSource;
    SCItemStorageKinds* _storageNode;
    
    NSString* _databasePath;
    NSString* _databaseDir;
    
    SCPersistentRecordStorage* _storeById  ;
    SCPersistentRecordStorage* _storeByPath;
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
    
    self->_builder = [ [ SCPersistentStorageBuilder alloc ] initWithDatabasePathBase: self->_databasePath
                      settings: self->_cacheSettings ];
    self->_storageNode = [ self->_builder newRecordStorageNodeForItemSource: self->_defaultSource ];
    {
        self->_storeById   = (SCPersistentRecordStorage*)self->_storageNode.itemRecordById  ;
        self->_storeByPath = (SCPersistentRecordStorage*)self->_storageNode.itemRecordByPath;
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

static NSString* const ITEMS_TABLE = @"Items";
static NSString* const FIELDS_TABLE = @"Fields";
static NSString* const TIMESTAMP_COLUMN = @"Timestamp";
static NSString* const SETTINGS_TABLE = @"Settings";

-(void)testStorageHasItemsTable
{
    XCTAssertTrue( [ self->_storeById.readDb tableExists: ITEMS_TABLE ], @"No 'items' table" );
}

-(void)testStorageHasFieldsTable
{
    XCTAssertTrue( [ self->_storeById.readDb tableExists: FIELDS_TABLE ], @"No 'fields' table" );
}

-(void)testStorageHasSettingsTable
{
    XCTAssertTrue( [ self->_storeById.readDb tableExists: SETTINGS_TABLE ], @"No 'settings' table" );
}

-(void)testItemsTableHasItemInfoAndTimestamp
{
    XCTAssertTrue
    (
        [ self->_storeById.readDb columnExists: TIMESTAMP_COLUMN
                                       inTable: ITEMS_TABLE ],
        @"Timestamp column is missing"
    );


    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"ItemId"
                                    inTable: ITEMS_TABLE ],
     @"Timestamp column is missing"
     );
    
    
    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"Path"
                                    inTable: ITEMS_TABLE ],
     @"Timestamp column is missing"
     );
    
    
    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"LongId"
                                    inTable: ITEMS_TABLE ],
     @"Timestamp column is missing"
     );

    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"DisplayName"
                                    inTable: ITEMS_TABLE ],
     @"Timestamp column is missing"
     );
}

-(void)testItemsTableHasAllFieldsAndAllChildrenFlags
{
    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"IsAllChildrenCached"
                                    inTable: ITEMS_TABLE ],
     @"IsAllChildrenCached column is missing"
     );

    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"IsAllFieldsCached"
                                    inTable: ITEMS_TABLE ],
     @"IsAllFieldsCached column is missing"
     );
}

-(void)testFieldsTableHasFieldDataAndItemId
{
    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"ItemId"
                                    inTable: FIELDS_TABLE ],
     @"Timestamp column is missing"
     );
    
    
    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"fieldId"
                                    inTable: FIELDS_TABLE ],
     @"Timestamp column is missing"
     );
    
    
    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"name"
                                    inTable: FIELDS_TABLE ],
     @"Timestamp column is missing"
     );
    
    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"type"
                                    inTable: FIELDS_TABLE ],
     @"Timestamp column is missing"
     );
    
    XCTAssertTrue
    (
     [ self->_storeById.readDb columnExists: @"rawValue"
                                    inTable: FIELDS_TABLE ],
     @"Timestamp column is missing"
    );
}

-(void)testItemIdAndPathAreIndexedForItemsTable
{
    id<ESReadonlyDbScheme> dbSchemeChecker = (id<ESReadonlyDbScheme>)self->_storeById.readDb;
    NSArray* indexNames = [ dbSchemeChecker indexNamesForTable: @"Items" ];
    
    NSArray* expectedNames = @[ @"idx_item_path", @"sqlite_autoindex_Items_1" ];
    XCTAssertEqualObjects( indexNames, expectedNames, @"index names mismatch" );
}

-(void)testFieldIdAndItemIdAreIndexedForFieldsTable
{
    id<ESReadonlyDbScheme> dbSchemeChecker = (id<ESReadonlyDbScheme>)self->_storeById.readDb;
    NSArray* indexNames = [ dbSchemeChecker indexNamesForTable: @"Fields" ];
    
    NSArray* expectedNames = @[ @"idx_fld_fieldId", @"idx_fld_itemId", @"sqlite_autoindex_Fields_1" ];
    XCTAssertEqualObjects( indexNames, expectedNames, @"index names mismatch" );
}

-(void)testVersionTableContainsCacheVersion
{
    NSString* version = [ self->_storeById.readDb selectStringScalar: @"SELECT [CacheDbVersion] FROM [Settings] LIMIT 1" ];
    XCTAssertEqualObjects( version, self->_cacheSettings.cacheDbVersion, @"cache version mismatch" );
}

-(void)testVersionTableContainsSessionInfo
{
    NSString* host = [ self->_storeById.readDb selectStringScalar: @"SELECT [Host] FROM [Settings] LIMIT 1" ];
    NSString* user = [ self->_storeById.readDb selectStringScalar: @"SELECT [User] FROM [Settings] LIMIT 1" ];
    
    XCTAssertEqualObjects( host, self->_cacheSettings.host    , @"host mismatch" );
    XCTAssertEqualObjects( user, self->_cacheSettings.userName, @"user mismatch" );
}

-(void)testVersionTableContainsSourceInfo
{
    NSString* database = [ self->_storeById.readDb selectStringScalar: @"SELECT [SitecoreDatabase] FROM [Settings] LIMIT 1" ];
    NSString* lang = [ self->_storeById.readDb selectStringScalar: @"SELECT [SitecoreLanguage] FROM [Settings] LIMIT 1" ];
    NSString* site = [ self->_storeById.readDb selectStringScalar: @"SELECT [SitecoreSite] FROM [Settings] LIMIT 1" ];
    
    XCTAssertEqualObjects( database, self->_defaultSource.database, @"database mismatch" );
    XCTAssertEqualObjects( lang    , self->_defaultSource.language, @"lang mismatch"     );
    XCTAssertEqualObjects( site    , self->_defaultSource.site    , @"site mismatch"     );
}


@end
