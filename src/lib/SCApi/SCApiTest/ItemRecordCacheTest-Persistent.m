#import <SenTestingKit/SenTestingKit.h>

#import "SCInMemoryRecordStorage+UnitTesting.h"

@interface PersistentItemRecordCacheTest : SenTestCase
{
@private
    SCGenericRecordCache* _cache;
    SCPersistentStorageBuilder* _storageBuilder;
    
    SCItemSourcePOD* _srcMaster;
    SCItemSourcePOD* _srcMasterV2;
    SCItemSourcePOD* _srcWeb;

    
    SCItemRecord* _record;
    SCItemRecord* _homeRecord;
    SCItemRecord* _sitecoreContent;
    SCItemRecord* _otherRecord;
    
    SCExtendedApiContext* _context;
    SCItemsReaderRequest* _homeRequest;
    
    NSMutableDictionary* _homeFields;
    
@private
    NSString* _databasePath;
    NSString* _databaseDir;
    
    SCCacheSettings* _cacheSettings;
}

@end

@implementation PersistentItemRecordCacheTest

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

-(void)createSources
{
    self->_srcMaster = [ SCItemSourcePOD new ];
    {
        self->_srcMaster.database = @"master";
        self->_srcMaster.language = @"en";
        self->_srcMaster.itemVersion = @"123";
        self->_srcMaster.site = @"/sitecore/shell";
    }
    self->_srcMasterV2 = [ self->_srcMaster copy ];
    self->_srcMasterV2.itemVersion = @"777";
    
    
    self->_srcWeb = [ self->_srcMaster copy ];
    self->_srcWeb.database = @"web";
    self->_srcWeb.itemVersion = @"1";

}

-(void)createRecords
{
    SCItemRecord* record = nil;
    
    record = [ SCItemRecord new ];
    {
        record.displayName = @"grandpa";
        record.longID = @"/{1111}/{232}/{314}";
        record.itemId = @"{314}";
        record.path = @"/sitecore/content";
        record.itemTemplate = @"Folder";
    }
    self->_sitecoreContent = record;
    
    record = [ SCItemRecord new ];
    {
        record.displayName = @"pater";
        record.longID = @"/{1111}/{232}/{314}/{1111-222-333}";
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.itemTemplate = @"Folder";        
    }
    self->_homeRecord = record;
    
    record = [ SCItemRecord new ];
    {
        record.displayName = @"sunny";
        record.longID = @"/{1111}/{232}/{314}/{1111-222-333}/{3.1415926}";
        record.itemId = @"{3.1415926}";
        record.path = @"/sitecore/content/home/XXX";
        record.itemTemplate = @"Folder";        
    }
    self->_record = record;
    
    
    
    record = [ SCItemRecord new ];
    {
        record.displayName = @"EEE";
        record.longID = @"/{1111}/{232}/{314}/{1111-222-333}/{2.71828}";
        record.itemId = @"{2.71828}";
        record.path = @"/sitecore/content/home/E";
        record.itemTemplate = @"Folder";
    }
    self->_otherRecord = record;
}

-(void)createHomeFields
{
    NSBundle* testBundle = [ NSBundle bundleForClass: [ self class ] ];
    NSString* jsonPath = [ testBundle pathForResource: @"1-HomeWithFields"
                                               ofType: @"json" ];
    NSData* jsonData = [ NSData dataWithContentsOfFile: jsonPath ];
    
    NSError* parsingError = nil;
    NSDictionary* json = [ NSJSONSerialization JSONObjectWithData: jsonData
                                                          options: 0
                                                            error: &parsingError ];
    if ( nil != parsingError )
    {
        return;
    }
    
    self->_homeFields = [ NSMutableDictionary new ];
    NSDictionary* fields = json[@"result"][@"items"][0][@"Fields"];
    [ fields enumerateKeysAndObjectsUsingBlock:^(NSString* fieldId, NSDictionary* fieldDataJson, BOOL *stop)
     {
         SCFieldRecord* parsedField = [ SCFieldRecord fieldRecordWithJson: fieldDataJson
                                                                  fieldId: fieldId
                                                               apiContext: nil ];
         
         self->_homeFields[ parsedField.name ] = parsedField;
     }];
}

-(void)setupStorage
{
    self->_cacheSettings = [ SCCacheSettings new ];
    {
        self->_cacheSettings.cacheDbVersion = @"1";
        self->_cacheSettings.host = @"http://mock-cache-host:8888";
        self->_cacheSettings.userName = @"mock_domain/SomeUser";
    }
    
    self->_storageBuilder =
    [ [ SCPersistentStorageBuilder alloc ] initWithDatabasePathBase: self->_databasePath
                                                           settings: self->_cacheSettings ];
    self->_storageBuilder.apiContext = self->_context;
    
    self->_cache = [ [ SCGenericRecordCache alloc ] initWithStorageBuilder: self->_storageBuilder ];
}

-(void)setupApiContext
{
    SCWebApiUrlBuilder* urlBuilder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    SCRemoteApi* api_ =
    [ [ SCRemoteApi alloc ] initWithHost: @"http://mobiledev1ua1.dk.sitecore.net:88"
                                   login: nil
                                password: nil
                              urlBuilder: urlBuilder ];
    
    
    self->_context = [ [ SCExtendedApiContext alloc ] initWithRemoteApi: api_
                                                             itemsCache: self->_cache
                                                     notificationCenter: [ NSNotificationCenter defaultCenter ] ];
}

-(void)setUp
{
    [ super setUp ];

    [ self cleanupFS ];
    
    [ self createSources ];
    [ self createRecords ];
    [ self createHomeFields ];
    
    // @adk - order matters
    [ self setupApiContext ];
    [ self setupStorage ];

    self->_homeRequest = [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/content/home" ];
}

-(void)tearDown
{
    self->_cache = nil;
    self->_storageBuilder = nil;

    [ self cleanupFS ];
    
    [super tearDown];
}

#pragma mark -
#pragma mark Constructor
-(void)testRecordsCacheRejectsInit
{
    STAssertThrows
    (
        [ SCGenericRecordCache new ],
        @"assert expected"
    );
}

-(void)testCacheRejectsNilStorageBuilder
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    STAssertThrows
    (
     [ [ SCGenericRecordCache alloc ] initWithStorageBuilder: nil ],
     @"assert expected"
     );
#pragma clang diagnostic pop    
}


#pragma mark -
#pragma mark Store Items Assert
-(void)testCacheSilenltlyIgnoresEmptyItemsArray
{
    [ self->_cache cacheResponseItems: @[]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    STAssertTrue( 0 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
}

-(void)testCacheRequiresAllArguments
{
    STAssertThrows
    (
        [ self->_cache cacheResponseItems: nil
                               forRequest: self->_homeRequest
                               apiContext: self->_context ],
        @"assert expected"
     );


    STAssertThrows
    (
     [ self->_cache cacheResponseItems: @[]
                            forRequest: nil
                            apiContext: self->_context ],
     @"assert expected"
     );
    
    
    STAssertThrows
    (
     [ self->_cache cacheResponseItems: @[]
                            forRequest: self->_homeRequest
                            apiContext: nil ],
     @"assert expected"
     );
}

#pragma mark -
#pragma mark Store Items
-(void)testCacheCreatesStorageForEachNewSource
{
    self->_homeRecord.itemSource = self->_srcMaster;
    [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];

    STAssertTrue( 1 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    SCItemSourcePOD* storageKey = [ [ self->_cache.storageBySource allKeys ] lastObject ];
    STAssertEqualObjects( self->_srcMaster, storageKey, @"storage key mismatch" );


    self->_record.itemSource = self->_srcWeb;
    [ self->_cache cacheResponseItems: @[ self->_record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    STAssertTrue( 2 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    

    
    SCItemRecord* cachedHome = nil;
    {
        cachedHome = [ self->_cache itemRecordForItemWithId: self->_homeRecord.itemId
                                                 itemSource: self->_srcMaster ];
        STAssertEqualObjects( cachedHome.displayName, @"pater", @"cached record mismatch" );
        STAssertTrue( cachedHome.apiContext == self->_context, @"context mismatch" );
    }

    {
        cachedHome = [ self->_cache itemRecordForItemWithPath: self->_homeRecord.path
                                                   itemSource: self->_srcMaster ];
        STAssertEqualObjects( cachedHome.displayName, @"pater", @"cached record mismatch" );
        STAssertTrue( cachedHome.apiContext == self->_context, @"context mismatch" );        
    }

    {
        cachedHome = [ self->_cache itemRecordForItemWithPath: self->_homeRecord.path
                                                   itemSource: self->_srcWeb ];
        STAssertNil( cachedHome, @"fonud record for invalid key" );
    }

    {
        cachedHome = [ self->_cache itemRecordForItemWithId: @"abrakadabra"
                                                 itemSource: self->_srcMaster ];
        STAssertNil( cachedHome, @"fonud record for invalid key" );
    }
}

-(void)testItemsFromSameSourceGoToSameStorage
{
    self->_homeRecord.itemSource = self->_srcMaster;
    [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    STAssertTrue( 1 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    SCItemSourcePOD* storageKey = [ [ self->_cache.storageBySource allKeys ] lastObject ];
    STAssertEqualObjects( self->_srcMaster, storageKey, @"storage key mismatch" );
    STAssertTrue( self->_homeRecord.apiContext == self->_context, @"context mismatch" );
    
    self->_record.itemSource = self->_srcMaster;
    [ self->_cache cacheResponseItems: @[ self->_record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    STAssertTrue( 1 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    STAssertTrue( self->_record.apiContext == self->_context, @"context mismatch" );    
}

-(void)testCacheRejectsMultipleSourcesInOneBatch
{
    self->_homeRecord.itemSource = self->_srcMaster;
    self->_record.itemSource = self->_srcWeb;

    NSArray* itemsFromDifferentSources = @[ self->_homeRecord, self->_record ];
    STAssertThrows
    (
        [ self->_cache cacheResponseItems: itemsFromDifferentSources
                               forRequest: self->_homeRequest
                               apiContext: self->_context ],
        @"Assert expected"
    );
}

-(void)testItemIsCachedByIdAndPath
{
    self->_homeRecord.itemSource = self->_srcMaster;
    [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    STAssertTrue( 1 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    SCItemStorageKinds* storageNode = [ [ self->_cache.storageBySource allValues ] lastObject ];
    
    STAssertTrue( [ storageNode isMemberOfClass: [ SCItemStorageKinds class ] ], @"storage node class mismatch" );
    
    STAssertNotNil( storageNode.itemRecordById, @"id store is nil" );
    STAssertNotNil( storageNode.itemRecordByPath, @"id store is nil" );
    
    SCItemRecord* cachedIdItem = [ self->_cache itemRecordForItemWithId: self->_homeRecord.itemId
                                                             itemSource: self->_homeRecord.itemSource ];

    SCItemRecord* cachedPathItem = [ self->_cache itemRecordForItemWithPath: self->_homeRecord.path
                                                             itemSource: self->_homeRecord.itemSource ];
    
    STAssertNotNil( cachedIdItem, @"id item is nil" );
    STAssertNotNil( cachedPathItem, @"path item is nil" );
}

-(void)testAllChildFlagIs_NOT_SetForSelfScope
{
    self->_homeRequest.scope = SCItemReaderSelfScope ;    
    self->_homeRequest.requestType = SCItemReaderRequestItemPath;
    self->_homeRequest.fieldNames = [ NSSet setWithArray: @[ @"Display Name" ] ];
    
    self->_homeRecord.itemSource = self->_srcMaster;
    self->_record.itemSource = self->_srcMaster;
    
    [ self->_cache cacheResponseItems: @[ self->_homeRecord, self->_record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    SCItemStorageKinds* storageNode = [ [ self->_cache.storageBySource allValues ] lastObject ];
    NSArray* storedItems = objc_msgSend( storageNode.itemRecordById, @selector(allStoredEntities));
                            
    STAssertTrue( 2 == [ storedItems count ], @"items count mismatch" );
    SCItemAndFields* entity = nil;
    
    entity = storedItems[0];
    {
        STAssertFalse( entity.isAllChildItemsCached, @"child cache flag mismatch" );
        STAssertFalse( entity.isAllFieldItemsCached, @"field cache flag mismatch" );
    }

    entity = storedItems[1];
    {
        STAssertFalse( entity.isAllChildItemsCached, @"child cache flag mismatch" );
        STAssertFalse( entity.isAllFieldItemsCached, @"field cache flag mismatch" );
    }
}

-(void)testAllChildFlagIs_NOT_SetForQuery_IgnoringScope
{
    self->_homeRequest.scope =
    SCItemReaderParentScope   |
    SCItemReaderSelfScope     |
    SCItemReaderChildrenScope ;

    
    self->_homeRequest.requestType = SCItemReaderRequestQuery;
    self->_homeRequest.fieldNames = [ NSSet setWithArray: @[ @"Display Name" ] ];
    
    self->_homeRecord.itemSource = self->_srcMaster;
    self->_record.itemSource = self->_srcMaster;
    
    [ self->_cache cacheResponseItems: @[ self->_homeRecord, self->_record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    SCItemStorageKinds* storageNode = [ [ self->_cache.storageBySource allValues ] lastObject ];
    NSArray* storedItems = objc_msgSend( storageNode.itemRecordById, @selector(allStoredEntities));
    
    STAssertTrue( 2 == [ storedItems count ], @"items count mismatch" );
    SCItemAndFields* entity = nil;
    
    entity = storedItems[0];
    {
        STAssertFalse( entity.isAllChildItemsCached, @"child cache flag mismatch" );
        STAssertFalse( entity.isAllFieldItemsCached, @"field cache flag mismatch" );
    }
    
    entity = storedItems[1];
    {
        STAssertFalse( entity.isAllChildItemsCached, @"child cache flag mismatch" );
        STAssertFalse( entity.isAllFieldItemsCached, @"field cache flag mismatch" );
    }
}

-(void)testAllFieldsFlagIsSetForNilFieldNamesRequest
{
    self->_homeRequest.scope = SCItemReaderSelfScope;
    self->_homeRequest.requestType = SCItemReaderRequestItemId;
    self->_homeRequest.fieldNames = nil;
    
    self->_homeRecord.itemSource = self->_srcMaster;
    self->_record.itemSource = self->_srcMaster;
    
    [ self->_cache cacheResponseItems: @[ self->_homeRecord, self->_record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    SCItemStorageKinds* storageNode = [ [ self->_cache.storageBySource allValues ] lastObject ];
    NSArray* storedItems = objc_msgSend( storageNode.itemRecordById, @selector(allStoredEntities));
    
    STAssertTrue( 2 == [ storedItems count ], @"items count mismatch" );
    SCItemAndFields* entity = nil;
    
    entity = storedItems[0];
    {
        STAssertFalse( entity.isAllChildItemsCached, @"child cache flag mismatch" );
        STAssertTrue ( entity.isAllFieldItemsCached, @"field cache flag mismatch" );
    }
    
    entity = storedItems[1];
    {
        STAssertFalse( entity.isAllChildItemsCached, @"child cache flag mismatch" );
        STAssertTrue ( entity.isAllFieldItemsCached, @"field cache flag mismatch" );
    }
}

-(void)testAllChildFlagIs_NOT_SetForParentScope
{
    self->_homeRequest.scope = SCItemReaderParentScope ;
    self->_homeRequest.requestType = SCItemReaderRequestItemPath;
    self->_homeRequest.fieldNames = [ NSSet setWithArray: @[ @"Display Name" ] ];

    self->_homeRecord.itemSource = self->_srcMaster;
    self->_record.itemSource = self->_srcMaster;
    
    [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    SCItemStorageKinds* storageNode = [ [ self->_cache.storageBySource allValues ] lastObject ];
    NSArray* storedItems = objc_msgSend( storageNode.itemRecordById, @selector(allStoredEntities));
    
    STAssertTrue( 1 == [ storedItems count ], @"items count mismatch" );
    SCItemAndFields* entity = nil;
    
    entity = storedItems[0];
    {
        STAssertFalse( entity.isAllChildItemsCached, @"child cache flag mismatch" );
        STAssertFalse( entity.isAllFieldItemsCached, @"field cache flag mismatch" );
    }
}

-(void)testFakeParentItemIsCreatedForChildScopeOnly
{
    self->_homeRequest.scope = SCItemReaderChildrenScope;
    self->_homeRequest.requestType = SCItemReaderRequestItemPath;
    self->_homeRequest.fieldNames = [ NSSet setWithArray: @[ @"Display Name" ] ];
    
    self->_homeRecord.itemSource = self->_srcMaster;
    self->_record.itemSource = self->_srcMaster;
    
    [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    SCItemStorageKinds* storageNode = [ [ self->_cache.storageBySource allValues ] lastObject ];
    
    {
        id<SCItemRecordStorageRW> idStorage = storageNode.itemRecordById;
        NSArray* storedItems = [ idStorage allStoredRecords ];
        STAssertTrue( 2 == [ storedItems count ], @"items count mismatch" );
        
        SCItemAndFields* homeEntity = objc_msgSend( idStorage, @selector(getStoredEntityForItemKey:), self->_homeRecord.itemId );
        {
            STAssertFalse( homeEntity.isAllChildItemsCached, @"child cache flag mismatch" );
            STAssertFalse( homeEntity.isAllFieldItemsCached, @"field cache flag mismatch" );
        }
        
        SCItemAndFields* parentEntity = objc_msgSend( idStorage, @selector(getStoredEntityForItemKey:), @"{314}" );
        {
            STAssertTrue ( parentEntity.isAllChildItemsCached, @"child cache flag mismatch" );
            STAssertFalse( parentEntity.isAllFieldItemsCached, @"field cache flag mismatch" );
        }
    }


    {
        id<SCItemRecordStorageRW> pathStorage = storageNode.itemRecordByPath;
        NSArray* storedItems = [ pathStorage allStoredRecords ];
        STAssertTrue( 2 == [ storedItems count ], @"items count mismatch" );
        
        SCItemAndFields* homeEntity = objc_msgSend( pathStorage, @selector(getStoredEntityForItemKey:), self->_homeRecord.path );
        {
            STAssertFalse( homeEntity.isAllChildItemsCached, @"child cache flag mismatch" );
            STAssertFalse( homeEntity.isAllFieldItemsCached, @"field cache flag mismatch" );
        }
        
        SCItemAndFields* parentEntity = objc_msgSend( pathStorage, @selector(getStoredEntityForItemKey:), @"/sitecore/content" );
        {
            STAssertTrue ( parentEntity.isAllChildItemsCached, @"child cache flag mismatch" );
            STAssertFalse( parentEntity.isAllFieldItemsCached, @"field cache flag mismatch" );
        }
    }
}

-(void)testFakeParentItemIsCreatedForChildParentScope
{
    self->_homeRequest.scope = SCItemReaderChildrenScope | SCItemReaderParentScope;
    self->_homeRequest.requestType = SCItemReaderRequestItemPath;
    self->_homeRequest.fieldNames = [ NSSet setWithArray: @[ @"Display Name" ] ];
    
    self->_sitecoreContent.itemSource = self->_srcMaster;
    self->_homeRecord.itemSource = self->_srcMaster;
    self->_record.itemSource = self->_srcMaster;
    
    [ self->_cache cacheResponseItems: @[ self->_sitecoreContent, self->_record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    SCItemStorageKinds* storageNode = [ [ self->_cache.storageBySource allValues ] lastObject ];
    
    {
        id<SCItemRecordStorageRW> idStorage = storageNode.itemRecordById;
        NSArray* storedItems = [ idStorage allStoredRecords ];
        STAssertTrue( 3 == [ storedItems count ], @"items count mismatch" );
        
        SCItemAndFields* homeEntity = objc_msgSend( idStorage, @selector(getStoredEntityForItemKey:), self->_homeRecord.itemId );
        {
            STAssertTrue( homeEntity.isAllChildItemsCached, @"child cache flag mismatch" );
            STAssertFalse( homeEntity.isAllFieldItemsCached, @"field cache flag mismatch" );
        }
    }
    
    
    {
        id<SCItemRecordStorageRW> pathStorage = storageNode.itemRecordByPath;
        NSArray* storedItems = [ pathStorage allStoredRecords ];
        STAssertTrue( 3 == [ storedItems count ], @"items count mismatch" );
        
        
        SCItemAndFields* homeEntity = objc_msgSend( pathStorage, @selector(getStoredEntityForItemKey:), self->_homeRecord.path );
        {
            STAssertTrue ( homeEntity.isAllChildItemsCached, @"child cache flag mismatch" );
            STAssertFalse( homeEntity.isAllFieldItemsCached, @"field cache flag mismatch" );
        }
    }
}


#pragma mark -
#pragma mark Read Items
-(void)testReadItemRequiresAllArgunents
{
    SCItemRecord* result = nil;
    
    self->_homeRecord.itemSource = self->_srcMaster;
    [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];

    
    result = [ self->_cache itemRecordForItemWithId: nil
                                         itemSource: self->_srcMaster ];

    
    STAssertThrows
    (
         [ self->_cache itemRecordForItemWithId: @"{1111-222-333}"
                                     itemSource: nil ],
         @"assert expected"
     );
    
    
    STAssertThrows
    (
         [ self->_cache itemRecordForItemWithPath: @"/sitecore/content/home"
                                     itemSource: nil ],
         @"assert expected"
     );

    STAssertThrows
    (
         [ self->_cache itemRecordForItemWithPath: nil
                                       itemSource: self->_srcMaster ],
         @"assert expected"
     );
}

-(void)testCleanupAllCreatesNewDictionary
{
    self->_homeRecord.itemSource = self->_srcMaster;
    [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    STAssertTrue( 1 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    SCItemSourcePOD* storageKey = [ [ self->_cache.storageBySource allKeys ] lastObject ];
    STAssertEqualObjects( self->_srcMaster, storageKey, @"storage key mismatch" );
    
    
    self->_record.itemSource = self->_srcWeb;
    [ self->_cache cacheResponseItems: @[ self->_record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    STAssertTrue( 2 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    
    
    [ self->_cache cleanupAll ];
    STAssertNotNil( self->_cache.storageBySource, @"storage count musmatch" );
    STAssertTrue( 0 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
}

-(void)testCleanupSourceForwardsCallToStorage
{
    self->_homeRecord.itemSource = self->_srcMaster;
    [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    STAssertTrue( 1 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    SCItemSourcePOD* storageKey = [ [ self->_cache.storageBySource allKeys ] lastObject ];
    STAssertEqualObjects( self->_srcMaster, storageKey, @"storage key mismatch" );
    
    
    self->_record.itemSource = self->_srcWeb;
    [ self->_cache cacheResponseItems: @[ self->_record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    STAssertTrue( 2 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    SCItemStorageKinds* webStorage = self->_cache.storageBySource[ self->_srcWeb ];
    
    id<SCItemRecordStorageRW> idStorage = webStorage.itemRecordById;
    id<SCItemRecordStorageRW> pathStorage = webStorage.itemRecordByPath;
    
    
    STAssertTrue( 1 == [ [idStorage allStoredRecords] count ], @"web storage count mismatch" );
    STAssertTrue( 1 == [ [pathStorage allStoredRecords] count ], @"web storage count mismatch" );
    
    [ self->_cache cleanupSource: self->_srcWeb ];
    STAssertTrue( 0 == [ [idStorage allStoredRecords] count ], @"web storage count mismatch" );
    STAssertTrue( 0 == [ [pathStorage allStoredRecords] count ], @"web storage count mismatch" );
}

-(void)testRemoveRecordForwardsCallToProperStorage
{
    self->_homeRecord.itemSource = self->_srcMaster;
    [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    STAssertTrue( 1 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    SCItemSourcePOD* storageKey = [ [ self->_cache.storageBySource allKeys ] lastObject ];
    STAssertEqualObjects( self->_srcMaster, storageKey, @"storage key mismatch" );
    
    
    self->_record.itemSource = self->_srcWeb;
    [ self->_cache cacheResponseItems: @[ self->_record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    STAssertTrue( 2 == [ self->_cache.storageBySource count ], @"storage count musmatch" );
    SCItemStorageKinds* webStorage = self->_cache.storageBySource[ self->_srcWeb ];
    
    id<SCItemRecordStorageRW> idStorage = webStorage.itemRecordById;
    id<SCItemRecordStorageRW> pathStorage = webStorage.itemRecordByPath;
    
    STAssertTrue( 1 == [ [idStorage allStoredRecords ] count ], @"web storage count mismatch" );
    STAssertTrue( 1 == [ [pathStorage allStoredRecords] count ], @"web storage count mismatch" );
    
    [ self->_cache didRemovedItemRecord: self->_record ];
    STAssertTrue( 0 == [ [idStorage allStoredRecords] count ], @"web storage count mismatch" );
    STAssertTrue( 0 == [ [pathStorage allStoredRecords] count ], @"web storage count mismatch" );
}

-(void)testSearchChildrenById
{    
    // setup
    {
        self->_sitecoreContent.itemSource = self->_srcWeb;
        self->_homeRecord.itemSource = self->_srcWeb;
        self->_record.itemSource = self->_srcWeb;
        self->_otherRecord.itemSource = self->_srcWeb;
    
        self->_homeRequest.fieldNames = [ NSSet setWithArray: @[ @"stub" ] ];
        self->_homeRequest.scope = SCItemReaderSelfScope;
        [ self->_cache cacheResponseItems: @[ self->_sitecoreContent ]
                               forRequest: self->_homeRequest
                               apiContext: self->_context ];

        
        self->_homeRequest.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        [ self->_cache cacheResponseItems: @[ self->_homeRecord, self->_otherRecord ]
                               forRequest: self->_homeRequest
                               apiContext: self->_context ];

    
        self->_homeRequest.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        [ self->_cache cacheResponseItems: @[ self->_record ]
                               forRequest: self->_homeRequest
                               apiContext: self->_context ];
    }
    
    
    NSArray* result = nil;
    {
        {
            result = [ self->_cache allChildrenForItemWithItemWithId: self->_sitecoreContent.itemId
                                                          itemSource: self->_srcWeb ];
            STAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_cache cachedChildrenForItemWithId: self->_sitecoreContent.itemId
                                                     itemSource: self->_srcWeb ];
            STAssertTrue( 1 == [ result count ], @"cached children items mismatch" );
        }
        
        
        {
            result = [ self->_cache allChildrenForItemWithItemWithPath: self->_sitecoreContent.path
                                                            itemSource: self->_srcWeb ];
            STAssertNil( result, @"no ALL children expected" );
        }
    }
    
    
    {
        {
            result = [ self->_cache allChildrenForItemWithItemWithId: self->_homeRecord.itemId
                                                          itemSource: self->_srcWeb ];
            STAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_cache cachedChildrenForItemWithId: self->_homeRecord.itemId
                                                     itemSource: self->_srcWeb ];
            STAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
        
        
        {
            result = [ self->_cache allChildrenForItemWithItemWithPath: self->_homeRecord.path
                                                            itemSource: self->_srcWeb ];
            STAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_cache allChildrenForItemWithItemWithId: self->_record.itemId
                                                          itemSource: self->_srcWeb ];
            STAssertNil( result, @"no ALL children expected" );
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_cache cachedChildrenForItemWithId: self->_record.itemId
                                                     itemSource: self->_srcWeb ];
            STAssertNotNil( result, @"no ALL children expected" );
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_cache allChildrenForItemWithItemWithPath: self->_record.path
                                                            itemSource: self->_srcWeb ];
            STAssertNil( result, @"no ALL children expected" );
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_cache allChildrenForItemWithItemWithId: self->_otherRecord.itemId
                                                          itemSource: self->_srcWeb ];
            STAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_cache cachedChildrenForItemWithId: self->_otherRecord.itemId
                                                     itemSource: self->_srcWeb ];
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
        
        
        {
            result = [ self->_cache allChildrenForItemWithItemWithPath: self->_otherRecord.path
                                                            itemSource: self->_srcWeb ];
            STAssertNil( result, @"no ALL children expected" );
        }        
    }
    
    {
        {
            result = [ self->_cache allChildrenForItemWithItemWithId: @"ahahaha"
                                                          itemSource: self->_srcWeb ];
            STAssertNil( result, @"no ALL children expected" );
        }

        {
            result = [ self->_cache cachedChildrenForItemWithId: @"ho-ho-ho"
                                                     itemSource: self->_srcWeb ];
            STAssertNil( result, @"no ALL children expected" );
        }

        {
            result = [ self->_cache allChildrenForItemWithItemWithPath: @"happy new year"
                                                            itemSource: self->_srcWeb ];
            STAssertNil( result, @"no ALL children expected" );
        }
    }
}

-(void)testFakeParentDoesNotOverwriteExistingOne
{
    // setup
    {
        self->_sitecoreContent.itemSource = self->_srcMaster;
        self->_homeRecord.itemSource = self->_srcMaster;
        self->_record.itemSource = self->_srcMaster;
        self->_otherRecord.itemSource = self->_srcMaster;
        
        self->_homeRequest.fieldNames = [ NSSet setWithArray: @[ @"stub" ] ];

        self->_homeRequest.scope = SCItemReaderSelfScope;
        [ self->_cache cacheResponseItems: @[ self->_homeRecord ]
                               forRequest: self->_homeRequest
                               apiContext: self->_context ];
        
        
        self->_homeRequest.scope = SCItemReaderChildrenScope;
        [ self->_cache cacheResponseItems: @[ self->_record ]
                               forRequest: self->_homeRequest
                               apiContext: self->_context ];
    }
    
    SCItemRecord* homeFromCache = [ self->_cache itemRecordForItemWithId: self->_homeRecord.itemId
                                                              itemSource: self->_srcMaster ];
    STAssertEqualObjects( homeFromCache.displayName, @"pater", @"home record overwritten by fake" );
}

-(void)testAllFieldsCaching
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_srcMaster copy ];
    record.fieldsByName = [ NSDictionary dictionaryWithDictionary: self->_homeFields ];
    record.apiContext = self->_context;
    
    self->_homeRequest.fieldNames = nil; // all fields
    [ self->_cache cacheResponseItems: @[ record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    
    SCFieldRecord* textField = [ self->_cache fieldWithName: @"Title"
                                                     itemId: record.itemId
                                                 itemSource: self->_srcMaster ];
    STAssertNotNil( textField, @"Title field expected" );
    
    NSDictionary* cachedFields = [ self->_cache cachedFieldsByNameForItemId: record.itemId
                                                                 itemSource: self->_srcMaster ];
    
    STAssertTrue( 2 == [ cachedFields count ], @"cachedFields count mismatch" );
    
    SCField* fieldForUser = cachedFields[ @"Title" ];
    STAssertTrue( [ fieldForUser isKindOfClass: [ SCField class ] ], @"field class mismatch" );
    STAssertEqualObjects( fieldForUser.fieldValue, @"Welcome to Sitecore", @"field name mismatch" );
    
    SCFieldRecord* fieldRec = objc_msgSend( fieldForUser, @selector(fieldRecord) );
    
    STAssertTrue( [ SCItemRecordComparator metadataOfItemRecord: fieldRec.itemRecord isEqualTo: record ], @"item record mismatch" );
    STAssertTrue( [ SCItemRecordComparator sourceOfItemRecord: fieldRec.itemRecord isEqualTo: record ], @"item record mismatch" );
}

-(void)testSomeFieldsCaching
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_srcMaster copy ];
    record.fieldsByName = @{ @"Text" : self->_homeFields[@"Text"] };
        
    self->_homeRequest.fieldNames = [ NSSet setWithArray: @[ @"Text" ] ];
    [ self->_cache cacheResponseItems: @[ record ]
                           forRequest: self->_homeRequest
                           apiContext: self->_context ];
    
    
    SCFieldRecord* titleField = [ self->_cache fieldWithName: @"Title"
                                                     itemId: record.itemId
                                                 itemSource: self->_srcMaster ];
    STAssertNil( titleField, @"Title field expected" );

    SCFieldRecord* textField = [ self->_cache fieldWithName: @"Text"
                                                     itemId: record.itemId
                                                 itemSource: self->_srcMaster ];
    STAssertNotNil( textField, @"Title field expected" );
    
    
    NSDictionary* cachedFields = [ self->_cache cachedFieldsByNameForItemId: record.itemId
                                                                 itemSource: self->_srcMaster ];
    
    STAssertTrue( 1 == [ cachedFields count ], @"cachedFields count mismatch" );
    
    SCField* fieldForUser = cachedFields[ @"Text" ];
    STAssertTrue( [ fieldForUser isKindOfClass: [ SCField class ] ], @"field class mismatch" );
    STAssertNotNil( fieldForUser.fieldValue, @"field name mismatch" );
}

@end
