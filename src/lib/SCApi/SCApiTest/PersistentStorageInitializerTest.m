
@interface PersistentStorageInitializerTest : XCTestCase
@end

@implementation PersistentStorageInitializerTest
{
    SCCacheSettings* _cacheSettings;
    SCPersistentStorageBuilder* _builder;
    SCItemSourcePOD* _defaultSource;
    SCItemStorageKinds* _storageNode;
    
    NSString* _databasePath;
    NSString* _databaseDir;
    
    
    SCItemSourcePOD* _srcNoDb;
    SCItemSourcePOD* _srcNoLang;
    SCItemSourcePOD* _srcAllInclusive;
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
    
    self->_srcNoDb = [ self->_defaultSource copy ];
    self->_srcNoDb.database = nil;
    
    self->_srcNoLang = [ self->_defaultSource copy ];
    self->_srcNoLang.language = nil;
    
    self->_srcAllInclusive = [ self->_defaultSource copy ];
    self->_srcAllInclusive.site = @"/sitecore/shell";
    self->_srcAllInclusive.itemVersion = @"4";
    
    
    self->_builder =
    [ [ SCPersistentStorageBuilder alloc ] initWithDatabasePathBase: self->_databasePath
                                                           settings: self->_cacheSettings ];
    self->_storageNode = [ self->_builder newRecordStorageNodeForItemSource: self->_defaultSource ];
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


-(void)testStorageNodeShouldCloseAllDatabases
{
    SCPersistentRecordStorage* storeById   = nil;
    SCPersistentRecordStorage* storeByPath = nil;
    {
        XCTAssertTrue( [ self->_storageNode.itemRecordById isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        XCTAssertTrue( [ self->_storageNode.itemRecordByPath isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
    
        storeById   = (SCPersistentRecordStorage*)self->_storageNode.itemRecordById  ;
        storeByPath = (SCPersistentRecordStorage*)self->_storageNode.itemRecordByPath;
    }
    
    {
        XCTAssertTrue( storeById.shouldCloseReadDb , @"close read db flag mismatch" );
        XCTAssertTrue( storeById.shouldCloseWriteDb, @"close write db flag mismatch" );
        
        XCTAssertTrue( storeByPath.shouldCloseReadDb , @"close read db flag mismatch" );
        XCTAssertTrue( storeByPath.shouldCloseWriteDb, @"close write db flag mismatch" );
    }
}

-(void)testStorageNodeUsesTheSameDatabase
{
    SCPersistentRecordStorage* storeById   = nil;
    SCPersistentRecordStorage* storeByPath = nil;
    {
        XCTAssertTrue( [ self->_storageNode.itemRecordById isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        XCTAssertTrue( [ self->_storageNode.itemRecordByPath isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        
        storeById   = (SCPersistentRecordStorage*)self->_storageNode.itemRecordById  ;
        storeByPath = (SCPersistentRecordStorage*)self->_storageNode.itemRecordByPath;
    }

    

    XCTAssertNotNil( storeById.readDb , @"read  db is nil" );
    XCTAssertNotNil( storeById.writeDb, @"write db is nil" );
    
    XCTAssertNotNil( storeByPath.readDb, @"read  db is nil" );
    XCTAssertNil( storeByPath.writeDb  , @"nil write db expected" );
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcompare-distinct-pointer-types"
    XCTAssertTrue( storeById.readDb == storeByPath.readDb, @"read db mismatch" );
    XCTAssertTrue( storeById.readDb == storeById.writeDb , @"write db mismatch" );
#pragma clang diagnostic pop
    
}

-(void)testCacheDatabaseBuilderAppendsSourceToPath
{
    SCPersistentRecordStorage* storeById   = nil;
    SCPersistentRecordStorage* storeByPath = nil;
    {
        XCTAssertTrue( [ self->_storageNode.itemRecordById isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        XCTAssertTrue( [ self->_storageNode.itemRecordByPath isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        
        storeById   = (SCPersistentRecordStorage*)self->_storageNode.itemRecordById  ;
        storeByPath = (SCPersistentRecordStorage*)self->_storageNode.itemRecordByPath;
    }
    
    NSString* expectedDbPath = @"/tmp/PersistentStorageInitializerTest/SqliteCache-web-en-default";

    XCTAssertEqualObjects( [ storeById.readDb databasePath ], expectedDbPath, @"db path mismatch" );
}

-(void)testCacheDatabaseBuilderAppendsNoLanguageSourceToPath
{
    SCItemStorageKinds* node = [ self->_builder newRecordStorageNodeForItemSource: self->_srcNoLang ];
    
    SCPersistentRecordStorage* storeById   = nil;
    SCPersistentRecordStorage* storeByPath = nil;
    {
        XCTAssertTrue( [ node.itemRecordById isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        XCTAssertTrue( [ node.itemRecordByPath isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        
        storeById   = (SCPersistentRecordStorage*)node.itemRecordById  ;
        storeByPath = (SCPersistentRecordStorage*)node.itemRecordByPath;
    }
    
    NSString* expectedDbPath = @"/tmp/PersistentStorageInitializerTest/SqliteCache-web-default-default";
    
    XCTAssertEqualObjects( [ storeById.readDb databasePath ], expectedDbPath, @"db path mismatch" );
}

-(void)testCacheDatabaseBuilderAppendsNoDatabaseSourceToPath
{
    SCItemStorageKinds* node = [ self->_builder newRecordStorageNodeForItemSource: self->_srcNoDb ];
    
    SCPersistentRecordStorage* storeById   = nil;
    SCPersistentRecordStorage* storeByPath = nil;
    {
        XCTAssertTrue( [ node.itemRecordById isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        XCTAssertTrue( [ node.itemRecordByPath isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        
        storeById   = (SCPersistentRecordStorage*)node.itemRecordById  ;
        storeByPath = (SCPersistentRecordStorage*)node.itemRecordByPath;
    }
    
    NSString* expectedDbPath = @"/tmp/PersistentStorageInitializerTest/SqliteCache-default-en-default";
    
    XCTAssertEqualObjects( [ storeById.readDb databasePath ], expectedDbPath, @"db path mismatch" );
}

-(void)testCacheDatabaseBuilderAppendsAllInclusiveSourceToPath
{
    SCItemStorageKinds* node = [ self->_builder newRecordStorageNodeForItemSource: self->_srcAllInclusive ];
    
    SCPersistentRecordStorage* storeById   = nil;
    SCPersistentRecordStorage* storeByPath = nil;
    {
        XCTAssertTrue( [ node.itemRecordById isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        XCTAssertTrue( [ node.itemRecordByPath isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        
        storeById   = (SCPersistentRecordStorage*)node.itemRecordById  ;
        storeByPath = (SCPersistentRecordStorage*)node.itemRecordByPath;
    }
    
    NSString* expectedDbPath = @"/tmp/PersistentStorageInitializerTest/SqliteCache-web-en-_sitecore_shell";
    
    XCTAssertEqualObjects( [ storeById.readDb databasePath ], expectedDbPath, @"db path mismatch" );
}

-(void)testCacheDatabaseBuilderOpensDB
{
    SCPersistentRecordStorage* storeById   = nil;
    SCPersistentRecordStorage* storeByPath = nil;
    {
        XCTAssertTrue( [ self->_storageNode.itemRecordById isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        XCTAssertTrue( [ self->_storageNode.itemRecordByPath isMemberOfClass: [ SCPersistentRecordStorage class ] ], @"storage class mismatch" );
        
        storeById   = (SCPersistentRecordStorage*)self->_storageNode.itemRecordById  ;
        storeByPath = (SCPersistentRecordStorage*)self->_storageNode.itemRecordByPath;
    }
    
    XCTAssertTrue( [ storeById.readDb isOpen ], @"db should have been opened" );
}


@end
