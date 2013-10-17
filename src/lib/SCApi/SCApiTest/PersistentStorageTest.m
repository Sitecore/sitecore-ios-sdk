@interface PersistentStorageTest : SenTestCase
@end

@implementation PersistentStorageTest
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
    SCItemSourcePOD* _otherSource;
    
    SCApiContext* _context;
    
@private
    SCFieldRecord* _textField;
    SCFieldRecord* _imageField;
    SCFieldRecord* _modifiedImageField;
    SCFieldRecord* _multilistField;
    SCFieldRecord* _renamedMultilistField;
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

-(void)setupFields
{
    SCFieldRecord* newField = nil;
    
    
    newField = [ SCFieldRecord new ];
    {
        newField.fieldId = @"{F1}";
        newField.name = @"fff1";
        newField.type = @"Text";
        newField.rawValue = @"Humpty-Dumpty sat on the wall...";
        newField.apiContext = self->_context.extendedApiContext;
    }
    self->_textField = newField;
    
    newField = [ SCFieldRecord new ];
    {
        newField.fieldId = @"{IMG-GUID}";
        newField.name = @"Avatarko";
        newField.type = @"Image";
        newField.rawValue = @"~/media/Avatarko/1.png";
        newField.apiContext = self->_context.extendedApiContext;
    }
    self->_imageField = newField;

    
    newField = [ SCFieldRecord new ];
    {
        newField.fieldId = @"{IMG-GUID}";
        newField.name = @"Avatarko";
        newField.type = @"Image";
        newField.rawValue = @"~/media/Avatarko/2.png";
        newField.apiContext = self->_context.extendedApiContext;
    }
    self->_modifiedImageField = newField;
    
    
    newField = [ SCFieldRecord new ];
    {
        newField.fieldId = @"{LINK-GUID}";
        newField.name = @"Link to Humpty";
        newField.type = @"Multilist";
        newField.rawValue = @"{F1}";
        newField.apiContext = self->_context.extendedApiContext;
    }
    self->_multilistField = newField;
    
    newField = [ SCFieldRecord new ];
    {
        newField.fieldId = @"{LINK-GUID}";
        newField.name = @"Renamed Link to Humpty";
        newField.type = @"Multilist";
        newField.rawValue = @"{F1}";
        newField.apiContext = self->_context.extendedApiContext;
    }
    self->_renamedMultilistField = newField;
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
    
    self->_otherSource = [ self->_itemSource copy ];
    self->_otherSource.database = @"XYZ";
    
    self->_context = [ [ SCApiContext alloc ] initWithHost: @"http://mock.host/12358" ];
    
    self->_builder =
    [ [ SCPersistentStorageBuilder alloc ] initWithDatabasePathBase: self->_databasePath
                                                           settings: self->_cacheSettings ];
    self->_builder.apiContext = self->_context.extendedApiContext;
    
    self->_storageNode = [ self->_builder newRecordStorageNodeForItemSource: self->_defaultSource ];
    {
        self->_storeById   = (SCPersistentRecordStorage*)self->_storageNode.itemRecordById  ;
        self->_storeByPath = (SCPersistentRecordStorage*)self->_storageNode.itemRecordByPath;
        
        self->_storage = self->_storeById;
    }
    
    [ self setupFields ];
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

-(void)testRegisterItemRejectsNilInput
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_itemSource copy ];
    
    NSString* key = [ record.itemId copy ];
    
    STAssertThrows
    (
     [ self->_storage registerItem: nil
              withAllFieldsInCache: NO
            withAllChildrenInCache: NO
                            forKey: key ],
     @"assert expected"
     );
    
    
    STAssertThrows
    (
     [ self->_storage registerItem: record
              withAllFieldsInCache: NO
            withAllChildrenInCache: NO
                            forKey: nil ],
     @"assert expected"
     );
}

-(void)testRegisterItemWithNoFields
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_itemSource copy ];
    record.longID = @"/{111}/{222}/{1111-222-333}";
    record.hasChildren = YES;
    
    NSString* key = [ record.itemId copy ];
    
    [ self->_storage registerItem: record
             withAllFieldsInCache: YES
           withAllChildrenInCache: YES
                           forKey: key ];
    
    SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
    STAssertTrue( [ SCItemRecordComparator metadataOfItemRecord: cachedRecord isEqualTo: record ],  @"cached data mismatch" );
    STAssertTrue( [ SCItemRecordComparator sourceOfItemRecord: cachedRecord isEqualTo: record ],  @"source mismatch" );
    
    STAssertNotNil( cachedRecord.apiContext    , @"context mismatch" );
    STAssertNotNil( cachedRecord.mainApiContext, @"context mismatch" );
    STAssertNil( cachedRecord.fieldsByName, @"no fields expected" );

    SCFieldRecord* mockField = [ self->_storage fieldWithName: @"1"
                                                      itemKey: key ];
    STAssertNil( mockField, @"no fields expected" );
    
    
    SCItemAndFields* entity = objc_msgSend( self->_storage, @selector(getStoredEntityForItemKey:), key );
    STAssertTrue( entity.cachedItemRecord != cachedRecord, @"enity item mismatch" );
    STAssertTrue( [ SCItemRecordComparator metadataOfItemRecord: cachedRecord isEqualTo: entity.cachedItemRecord ],  @"cached data mismatch" );
    STAssertTrue( [ SCItemRecordComparator sourceOfItemRecord: cachedRecord isEqualTo: entity.cachedItemRecord ],  @"source mismatch" );
    STAssertTrue( entity.isAllChildItemsCached, @"isAllChildItemsCached mismathc" );
    STAssertTrue( entity.isAllFieldItemsCached, @"isAllFieldItemsCached mismathc" );
    STAssertNil( entity.cachedItemFieldsByName, @"cachedItemFieldsByName mismatch" );
}


-(void)testRegisterItemSetsSourceOfTheCache
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_itemSource copy ];
    
    NSString* key = [ record.itemId copy ];
    
    [ self->_storage registerItem: record
             withAllFieldsInCache: NO
           withAllChildrenInCache: NO
                           forKey: key ];
    
    SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
    
    STAssertTrue( cachedRecord.itemSource == self->_storage.itemSource, @"source object address mismatch" );
}


-(void)testRegisterItemRejectsItemsWithDifferentSource
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = self->_otherSource;
    
    NSString* key = [ record.itemId copy ];
    
    STAssertThrows
    (
     [ self->_storage registerItem: record
              withAllFieldsInCache: NO
            withAllChildrenInCache: NO
                            forKey: key ],
     @"assert expected"
     );
}


-(void)testRegisterItemWithAllFieldsInCacheRewritesFields
{
    SCItemRecord* record = [ SCItemRecord new ];
    NSString* key = nil;
    {
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.fieldsByName = @{ self->_textField.name : self->_textField };
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
        
        SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
        
        
        STAssertTrue( [ SCItemRecordComparator metadataOfItemRecord: record isEqualTo: cachedRecord ], @"cached record mismatch" );
        
        
        NSDictionary* fields = [ self->_storage allFieldsByNameForItemKey: key ];
        STAssertNil( fields, @"all fields must not be available yet" );
        
        
        
        SCFieldRecord* cachedField = [ self->_storage fieldWithName: self->_textField.name
                                                            itemKey: key ];
        STAssertNotNil( cachedField, @"valid field expected" );
        STAssertEqualObjects( cachedField, self->_textField, @"cached field mismatch" );

        // TODO : who owns itemRecord ???
        // @adk
        STAssertNil( cachedField.itemRecord, @"nil item record expected" );
    }
    

    SCItemRecord* freshRecord = [ SCItemRecord new ];
    {
        freshRecord.itemSource = [ self->_itemSource copy ];
        freshRecord.itemId = @"{1111-222-333}";
        freshRecord.path = @"/sitecore/content/home/XYZ";
        
        NSDictionary* cachedFields =
        @{
           self->_imageField.name     : self->_imageField    ,
           self->_multilistField.name : self->_multilistField
        };
        freshRecord.fieldsByName = cachedFields;
        
        [ self->_storage registerItem: freshRecord
                 withAllFieldsInCache: YES
               withAllChildrenInCache: NO
                               forKey: key ];
        
        SCItemAndFields* entity = objc_msgSend( self->_storage, @selector(getStoredEntityForItemKey:), key );

        
        STAssertTrue( [ SCItemRecordComparator metadataOfItemRecord: entity.cachedItemRecord  isEqualTo: freshRecord ], @"cached record mismatch" );
        STAssertTrue( entity.isAllFieldItemsCached, @"fields flag mismatch" );
        STAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );

        cachedFields =
        @{
          self->_imageField.name     : self->_imageField    ,
          self->_multilistField.name : self->_multilistField,
          self->_textField.name      : self->_textField
        };

        STAssertEqualObjects( cachedFields, entity.cachedItemFieldsByName, @"fields mismatch" );
        
        SCFieldRecord* cachedField = [ self->_storage fieldWithName: self->_imageField.name
                                                          itemKey: key ];
        STAssertNotNil( cachedField, @"no fields expected" );
        STAssertEqualObjects( cachedField, self->_imageField, @"image field mismatch" );
        STAssertNil( cachedField.itemRecord, @"nil item record expected" );
        
        cachedField = [ self->_storage fieldWithName: self->_multilistField.name
                                           itemKey: key ];
        STAssertEqualObjects( cachedField, self->_multilistField, @"multilist field mismatch" );
        STAssertNil( cachedField.itemRecord, @"nil item record expected" );
    }
}


-(void)testFreshFieldsHaveGreaterPriority
{
    SCItemRecord* record = [ SCItemRecord new ];
    NSString* key = nil;
    {
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.fieldsByName =
        @{
           self->_textField.name      : self->_textField,
           self->_multilistField.name : self->_multilistField,
           self->_imageField.name     : self->_imageField
        };
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
        
        SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
        STAssertTrue
        (
            [ SCItemRecordComparator metadataOfItemRecord: record isEqualTo: cachedRecord ]
            , @"cached record mismatch"
        );
        
        
        NSDictionary* fields = [ self->_storage allFieldsByNameForItemKey: key ];
        STAssertNil( fields, @"all fields must not be available yet" );
    }
    
    
    SCItemRecord* freshRecord = [ SCItemRecord new ];
    {
        freshRecord.itemId = @"{1111-222-333}";
        freshRecord.path = @"/sitecore/content/home/XYZ";
        freshRecord.itemSource = [ self->_itemSource copy ];
        
        
        NSDictionary* mockFields =
        @{
          self->_modifiedImageField.name : self->_modifiedImageField,
          self->_renamedMultilistField.name : self->_renamedMultilistField
        };
        freshRecord.fieldsByName = mockFields;
        
        [ self->_storage registerItem: freshRecord
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
        
        SCItemAndFields* entity = objc_msgSend( self->_storage, @selector(getStoredEntityForItemKey:), key );
        STAssertTrue
        (
         [ SCItemRecordComparator metadataOfItemRecord: entity.cachedItemRecord isEqualTo: freshRecord ]
         , @"cached record mismatch"
        );
        STAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
        
        NSDictionary* expectedMockFields =
        @{
          // @adk - Not like memory cache due to constraints
          //          self->_multilistField.name        : self->_multilistField       ,

          self->_textField.name             : self->_textField            ,
          self->_modifiedImageField.name    : self->_modifiedImageField   ,
          self->_renamedMultilistField.name : self->_renamedMultilistField
        };
        
        STAssertEqualObjects( expectedMockFields, entity.cachedItemFieldsByName, @"fields mismatch" );
        
        // @adk - need confirmation from product owner
        STAssertEqualObjects( mockFields, freshRecord.fieldsByName, @"original fields must not change" );
        //STAssertEqualObjects( expectedMockFields, freshRecord.fieldsByName, @"fields mismatch" );
    }
}


-(void)testUnregisterMethodRemovesOnlyGivenEntity
{
    SCItemRecord* record = [ SCItemRecord new ];
    NSString* key = nil;
    {
        record.itemId = @"{1111}";
        record.path = @"/sitecore/content/home/X";
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
    }
    
    SCItemRecord* otherRecord = [ SCItemRecord new ];
    {
        otherRecord.itemId = @"{2222}";
        otherRecord.path = @"/sitecore/content/home/Y";
        otherRecord.itemSource = [ self->_itemSource copy ];
        
        key = [ otherRecord.itemId copy ];
        
        [ self->_storage registerItem: otherRecord
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
    }
    NSArray* allRecords = [ self->_storage allStoredRecords ];
    STAssertTrue( 2 == [ allRecords count ], @"all records count mismatch" );
    
    
    [ self->_storage unregisterItemForKey: @"{1111}" ];
    {
        SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: record.itemId ];
        SCItemRecord* cachedOther = [ self->_storage itemRecordForItemKey: otherRecord.itemId ];
        
        STAssertNil( cachedRecord, @"deleted record has been returned" );
        STAssertNotNil( cachedOther, @"another record should not be touched" );
        
        
        allRecords = [ self->_storage allStoredRecords ];
        STAssertTrue( 1 == [ allRecords count ], @"all records count mismatch" );
    }
}

-(void)testCleanupRemovesAll
{
    SCItemRecord* record = [ SCItemRecord new ];
    NSString* key = nil;
    {
        record.itemId = @"{1111}";
        record.path = @"/sitecore/content/home/X";
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
    }
    
    SCItemRecord* otherRecord = [ SCItemRecord new ];
    {
        otherRecord.itemId = @"{2222}";
        otherRecord.path = @"/sitecore/content/home/Y";
        otherRecord.itemSource = [ self->_itemSource copy ];
        
        key = [ otherRecord.itemId copy ];
        
        [ self->_storage registerItem: otherRecord
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
    }
    NSArray* allRecords = [ self->_storage allStoredRecords ];
    STAssertTrue( 2 == [ allRecords count ], @"all records count mismatch" );
    
    
    [ self->_storage cleanup ];
    {
        SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: record.itemId ];
        SCItemRecord* cachedOther = [ self->_storage itemRecordForItemKey: otherRecord.itemId ];
        
        STAssertNil( cachedRecord, @"deleted record has been returned" );
        STAssertNil( cachedOther, @"another record should not be touched" );
        
        
        allRecords = [ self->_storage allStoredRecords ];
        STAssertNil( allRecords, @"all records count mismatch" );
    }
}

-(void)testItemKeyCannotBeNil
{
    SCItemRecord* record = [ SCItemRecord new ];
    NSString* key = nil;
    {
        record.itemId = @"{1111}";
        record.path = @"/sitecore/content/home/X";
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
    }
    
    STAssertThrows
    (
     [ self->_storage unregisterItemForKey: nil ],
     @"assert expected"
     );
    
    STAssertThrows
    (
     [ self->_storage itemRecordForItemKey: nil ],
     @"assert expected"
     );
    
    STAssertThrows
    (
     [ self->_storage fieldWithName: @"achtung"
                            itemKey: nil ],
     @"assert expected"
     );
    
    
    STAssertThrows
    (
     [ self->_storage fieldWithName: nil
                            itemKey: @"hola" ],
     @"assert expected"
     );
    
    
    STAssertThrows
    (
     [ self->_storage cachedFieldsByNameForItemKey: nil ],
     @"assert expected"
     );
    
    STAssertThrows
    (
     [ self->_storage allFieldsByNameForItemKey: nil ],
     @"assert expected"
     );
}

-(void)testStorageKeysAreCaseInsensitive
{
    SCItemRecord* record = [ SCItemRecord new ];
    {
        record.itemId = @"{upper CASE}";
        record.path = @"/sitecore/content/home";
        record.itemSource = [ self->_itemSource copy ];
    }
    NSString* key = [ record.path copy ];
    [ self->_storage registerItem: record
             withAllFieldsInCache: NO
           withAllChildrenInCache: NO
                           forKey: key ];
    
    
    SCItemRecord* upperCaseRecord = [ SCItemRecord new ];
    {
        upperCaseRecord.itemId = @"{UPPER case}";
        upperCaseRecord.path = @"/SITECORE/content/Home";
        upperCaseRecord.itemSource = [ self->_itemSource copy ];
    }
    [ self->_storage registerItem: upperCaseRecord
             withAllFieldsInCache: NO
           withAllChildrenInCache: NO
                           forKey: upperCaseRecord.itemId ];
    
    STAssertTrue( [ [ self->_storeByPath allStoredRecords ] count ] == 1, @"count mismatch" );
    
    SCItemRecord* entity = [ [ self->_storeByPath allStoredRecords ] lastObject ];
    STAssertTrue( [ entity isMemberOfClass: [ SCItemRecord class ] ], @"allStoredRecords item type mismatch" );
    STAssertEqualObjects( entity.itemId, @"{UPPER case}", @"cached id mismatch" );
    
    
    SCItemRecord* result = [ self->_storeByPath itemRecordForItemKey: @"/sitecore/CONTENT/home" ];
    STAssertNotNil( result, @"record from cache is nil" );
    STAssertEqualObjects( result.itemId, @"{UPPER case}", @"cached id mismatch" );
}


#pragma mark -
#pragma mark Field Dirty Flag
-(void)testChangeRawValueMarksFieldAsDirty
{
    SCItemRecord* record = [ SCItemRecord new ];
    NSString* key = nil;
    NSArray* itemsToUpdateAtBackEnd = nil;
    NSArray* expectedItemsToUpdateAtBackEnd = nil;
    
    {
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.fieldsByName =
        @{
          self->_textField.name      : self->_textField,
          self->_multilistField.name : self->_multilistField,
          self->_imageField.name     : self->_imageField
          };
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
        
        itemsToUpdateAtBackEnd = [ self->_storage changedFieldsForItemId: record.itemId ];
        STAssertNil( itemsToUpdateAtBackEnd, @"no dirty fields expected" );
    }
    
    
    [ self->_storage setRawValue: @"new raw value"
                      forFieldId: self->_textField.fieldId
                          itemId: record.itemId ];
    
    [ self->_storage setRawValue: @"{DEAD-BEAF-0000-0000}"
                      forFieldId: self->_multilistField.fieldId
                          itemId: record.itemId ];
    
    itemsToUpdateAtBackEnd = [ self->_storage changedFieldsForItemId: record.itemId ];
    expectedItemsToUpdateAtBackEnd = @[ self->_multilistField.name, self->_textField.name ];
    
    STAssertEqualObjects( itemsToUpdateAtBackEnd, expectedItemsToUpdateAtBackEnd, @"wrong dirty fields list" );
}


-(void)testRewriteItemClearsDirtyFlag
{
    SCItemRecord* record = [ SCItemRecord new ];
    NSString* key = nil;
    NSArray* itemsToUpdateAtBackEnd = nil;
    NSArray* expectedItemsToUpdateAtBackEnd = nil;
    
    
    // create item and fields
    {
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.fieldsByName =
        @{
          self->_textField.name      : self->_textField,
          self->_multilistField.name : self->_multilistField,
          self->_imageField.name     : self->_imageField
          };
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
    }

    // set fields as dirty
    {
        [ self->_storage setRawValue: @"new raw value"
                          forFieldId: self->_textField.fieldId
                              itemId: record.itemId ];
        
        [ self->_storage setRawValue: @"{DEAD-BEAF-0000-0000}"
                          forFieldId: self->_multilistField.fieldId
                              itemId: record.itemId ];
        
        itemsToUpdateAtBackEnd = [ self->_storage changedFieldsForItemId: record.itemId ];
        expectedItemsToUpdateAtBackEnd = @[ self->_multilistField.name, self->_textField.name ];
        
        STAssertEqualObjects( itemsToUpdateAtBackEnd, expectedItemsToUpdateAtBackEnd, @"wrong dirty fields list" );
    }
    
    SCItemRecord* freshRecord = [ SCItemRecord new ];
    {
        freshRecord.itemId = @"{1111-222-333}";
        freshRecord.path = @"/sitecore/content/home/XYZ";
        freshRecord.itemSource = [ self->_itemSource copy ];
        
        
        NSDictionary* mockFields =
        @{
          self->_modifiedImageField.name : self->_modifiedImageField,
          self->_renamedMultilistField.name : self->_renamedMultilistField
          };
        freshRecord.fieldsByName = mockFields;
        
        [ self->_storage registerItem: freshRecord
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
    }
    
    itemsToUpdateAtBackEnd = [ self->_storage changedFieldsForItemId: record.itemId ];
    expectedItemsToUpdateAtBackEnd = @[ self->_textField.name ];
    STAssertEqualObjects( itemsToUpdateAtBackEnd, expectedItemsToUpdateAtBackEnd, @"fresh items must have no dirty flag. Others should still be dirty" );
}

@end
