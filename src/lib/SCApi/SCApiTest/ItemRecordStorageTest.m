#import <XCTest/XCTest.h>

@interface ItemRecordStorageTest : XCTestCase
@end

@implementation ItemRecordStorageTest
{
    SCInMemoryRecordStorage* _storage;
    SCItemSourcePOD* _itemSource;
    SCItemSourcePOD* _otherSource;
    
    SCItemRecord* _record;
    SCItemRecord* _otherRecord;
    SCItemRecord* _homeRecord;
    SCItemRecord* _sitecoreContent;
    
    SCItemPropertyGetter _idGetterBlock;
    SCItemPropertyGetter _pathGetterBlock;
    
    NSMutableDictionary* _homeFields;
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
        record.itemSource = [ self->_itemSource copy ];
        record.itemTemplate = @"Folder";        
    }
    self->_sitecoreContent = record;
    
    record = [ SCItemRecord new ];
    {
        record.displayName = @"pater";
        record.longID = @"/{1111}/{232}/{314}/{1111-222-333}";
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.itemSource = [ self->_itemSource copy ];
        record.itemTemplate = @"Folder";        
    }
    self->_homeRecord = record;
    
    record = [ SCItemRecord new ];
    {
        record.displayName = @"PiPiPi";
        record.longID = @"/{1111}/{232}/{314}/{1111-222-333}/{3.1415926}";
        record.itemId = @"{3.1415926}";
        record.path = @"/sitecore/content/home/Pi";
        record.itemSource = [ self->_itemSource copy ];
        record.itemTemplate = @"Folder";        
    }
    self->_record = record;


    
    record = [ SCItemRecord new ];
    {
        record.displayName = @"EEE";
        record.longID = @"/{1111}/{232}/{314}/{1111-222-333}/{2.71828}";
        record.itemId = @"{2.71828}";
        record.path = @"/sitecore/content/home/E";
        record.itemSource = [ self->_itemSource copy ];
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
                                                              apiSession: nil ];

        self->_homeFields[ parsedField.name ] = parsedField;
    }];
}

-(void)setUp
{
    [ super setUp ];
    
    self->_idGetterBlock = [ SCItemRecordPropertyFactory parentIdGetter ];
    self->_pathGetterBlock = [ SCItemRecordPropertyFactory parentPathGetter ];
    
    self->_itemSource = [ SCItemSourcePOD new ];
    {
        self->_itemSource.database    = @"master";
        self->_itemSource.site        = @"ololo" ;
        self->_itemSource.language    = @"en"    ;
        self->_itemSource.itemVersion = @"100500";
    }
    
    self->_otherSource = [ self->_itemSource copy ];
    self->_otherSource.database = @"XYZ";
    
    [ self createRecords ];
    [ self createHomeFields ];
    
    self->_storage = [ [ SCInMemoryRecordStorage alloc ] initWithItemSource: self->_itemSource ];
    self->_storage.shouldCheckRecordTypes = NO;
}

-(void)tearDown
{
    self->_itemSource = nil;
    self->_storage    = nil;
    
    [ super tearDown ];
}

#pragma mark -
#pragma mark Constructors
-(void)testInMemoryStorageRejectsInit
{
    XCTAssertThrows( [ SCInMemoryRecordStorage new ], @"assert expected" );
}

-(void)testInMemoryStorageRemembersSource
{
    XCTAssertEqualObjects( self->_storage.itemSource, self->_itemSource, @"item source mismatch" );
    XCTAssertTrue( self->_storage.itemSource == self->_itemSource, @"item source mismatch" );
}

#pragma mark -
#pragma mark Cleanup
-(void)testCleanupDropsStorage
{
    NSMutableDictionary* mockStorage = [ @{ @"1" : @"1", @"2" : @"2" } mutableCopy];
    
    self->_storage.storage = mockStorage;
    [ self->_storage cleanup ];
    
    XCTAssertFalse( [ self->_storage.storage isEqual: mockStorage ], @"storage not dropped" );
    XCTAssertNotNil( self->_storage.storage, @"dropped storage must not be nil" );
    XCTAssertTrue( 0 == [ self->_storage.storage count ], @"dropped storage must be empty" );
}


#pragma mark -
#pragma mark Register
-(void)testRegisterItemRejectsNilInput
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_itemSource copy ];
    
    NSString* key = [ record.itemId copy ];
    
    XCTAssertThrows
    (
     [ self->_storage registerItem: nil
              withAllFieldsInCache: NO
            withAllChildrenInCache: NO
                            forKey: key ],
         @"assert expected"
    );


    XCTAssertThrows
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
    
    NSString* key = [ record.itemId copy ];
    
    [ self->_storage registerItem: record
             withAllFieldsInCache: NO
           withAllChildrenInCache: NO
                           forKey: key ];
    
    SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
    XCTAssertTrue( record == cachedRecord, @"cached record mismatch" );
    
    SCItemAndFields* entity = [ self->_storage getStoredEntityForItemKey: key ];
    XCTAssertTrue( entity.cachedItemRecord == record, @"cached record mismatch" );
    XCTAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
    XCTAssertNil( entity.cachedItemFieldsByName, @"cached fields mismatch" );
    
    SCFieldRecord* mockField = [self->_storage fieldWithName: @"1"
                                                     itemKey: key ];
    XCTAssertNil( mockField, @"no fields expected" );
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
    XCTAssertTrue( record == cachedRecord, @"cached record mismatch" );

    XCTAssertTrue( record.itemSource == self->_itemSource, @"source object address mismatch" );
}

-(void)testRegisterItemRejectsItemsWithDifferentSource
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = self->_otherSource;
    
    NSString* key = [ record.itemId copy ];
    
    XCTAssertThrows
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
        record.fieldsByName = @{ @"1" : @"1" };
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
        
        SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
        XCTAssertTrue( record == cachedRecord, @"cached record mismatch" );
        

        NSDictionary* fields = [ self->_storage allFieldsByNameForItemKey: key ];
        XCTAssertNil( fields, @"all fields must not be available yet" );
        
        
        
        SCFieldRecord* mockField = [self->_storage fieldWithName: @"1"
                                                         itemKey: key ];
        XCTAssertNotNil( mockField, @"no fields expected" );
        XCTAssertTrue( [ @"1" isEqualToString: (NSString*)mockField ], @"mock field mismatch" );
    }

    
    SCItemRecord* freshRecord = [ SCItemRecord new ];
    {
        freshRecord.itemSource = [ self->_itemSource copy ];
        freshRecord.itemId = @"{1111-222-333}";
        freshRecord.path = @"/sitecore/content/home/XYZ";
        
        NSDictionary* mockFields = @{ @"2" : @"2", @"3" : @"3" };
        freshRecord.fieldsByName = mockFields;
        
        [ self->_storage registerItem: freshRecord
                 withAllFieldsInCache: YES
               withAllChildrenInCache: NO
                               forKey: key ];
        
        SCItemAndFields* entity = [ self->_storage getStoredEntityForItemKey: key ];
        XCTAssertTrue( entity.cachedItemRecord == freshRecord, @"cached record mismatch" );
        XCTAssertTrue( entity.isAllFieldItemsCached, @"fields flag mismatch" );
        XCTAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
        
        XCTAssertTrue( mockFields == entity.cachedItemFieldsByName, @"fields mismatch" );
        XCTAssertEqualObjects( mockFields, entity.cachedItemFieldsByName, @"fields mismatch" );
        
        SCFieldRecord* mockField = [ self->_storage fieldWithName: @"2"
                                                          itemKey: key ];
        XCTAssertNotNil( mockField, @"no fields expected" );
        XCTAssertTrue( [ @"2" isEqualToString: (NSString*)mockField ], @"mock field mismatch" );
        
        mockField = [ self->_storage fieldWithName: @"3"
                                           itemKey: key ];
        XCTAssertTrue( [ @"3" isEqualToString: (NSString*)mockField ], @"mock field mismatch" );
    }
}

-(void)testFreshFieldsHaveGreaterPriority
{
    self->_storage.shouldCheckRecordTypes = NO;
    
    SCItemRecord* record = [ SCItemRecord new ];
    NSString* key = nil;
    {
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.fieldsByName = @{ @"1" : @"1", @"2" : @"2", @"3" : @"3" };
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
        
        SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
        XCTAssertTrue( record == cachedRecord, @"cached record mismatch" );
        
        
        NSDictionary* fields = [ self->_storage allFieldsByNameForItemKey: key ];
        XCTAssertNil( fields, @"all fields must not be available yet" );
    }
    
    
    SCItemRecord* freshRecord = [ SCItemRecord new ];
    {
        freshRecord.itemId = @"{1111-222-333}";
        freshRecord.path = @"/sitecore/content/home/XYZ";
        freshRecord.itemSource = [ self->_itemSource copy ];
        
        
        NSDictionary* mockFields = @{ @"2" : @"222", @"3333" : @"3" };
        freshRecord.fieldsByName = mockFields;
        
        [ self->_storage registerItem: freshRecord
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
        
        SCItemAndFields* entity = [ self->_storage getStoredEntityForItemKey: key ];
        XCTAssertTrue( entity.cachedItemRecord == freshRecord, @"cached record mismatch" );
        XCTAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
        
        NSDictionary* expectedMockFields =
        @{
          @"1" : @"1",
          @"2" : @"222",
          @"3" : @"3",
          @"3333" : @"3"
        };
        
        XCTAssertEqualObjects( expectedMockFields, entity.cachedItemFieldsByName, @"fields mismatch" );
        XCTAssertEqualObjects( expectedMockFields, freshRecord.fieldsByName, @"fields mismatch" );
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
    
    [ self->_storage unregisterItemForKey: @"{1111}" ];
    {
        XCTAssertTrue( 1 == [ self->_storage.storage count ], @"cached items mismatch" );
        SCItemAndFields* entity = [ [ self->_storage.storage allValues ] lastObject ];

        XCTAssertTrue( entity.cachedItemRecord == otherRecord, @"remaining record mismatch" );
        XCTAssertEqualObjects( entity.cachedItemRecord.itemId, @"{2222}", @"remaining id mismatch" );
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
    
    XCTAssertThrows
    (
       [ self->_storage unregisterItemForKey: nil ],
       @"assert expected"
    );
    
    XCTAssertThrows
    (
     [ self->_storage itemRecordForItemKey: nil ],
     @"assert expected"
    );
    
    XCTAssertThrows
    (
     [ self->_storage fieldWithName: @"achtung"
                            itemKey: nil ],
     @"assert expected"
     );
    
    
    XCTAssertThrows
    (
     [ self->_storage fieldWithName: nil
                            itemKey: @"hola" ],
     @"assert expected"
     );
    

    XCTAssertThrows
    (
     [ self->_storage cachedFieldsByNameForItemKey: nil ],
     @"assert expected"
     );

    XCTAssertThrows
    (
     [ self->_storage allFieldsByNameForItemKey: nil ],
     @"assert expected"
     );
}

-(void)testStorageKeysAreCaseInsensitive
{
    SCItemRecord* record = [ SCItemRecord new ];
    {
        record.itemId = @"{1111-222-333}";
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
                           forKey: upperCaseRecord.path ];
    
    XCTAssertTrue( [ self->_storage.storage count ] == 1, @"count mismatch" );
    
    SCItemAndFields* entity = [ [self->_storage.storage allValues ] lastObject ];
    XCTAssertEqualObjects( entity.cachedItemRecord.itemId, @"{UPPER case}", @"cached id mismatch" );
    
    NSString* entityKey = [ [ self->_storage.storage allKeys ] lastObject ];
    XCTAssertEqualObjects( @"/sitecore/content/home", entityKey, @"key mismatch" );
    
    
    SCItemRecord* result = [ self->_storage itemRecordForItemKey: @"/sitecore/CONTENT/home" ];
    XCTAssertNotNil( result, @"record from cache is nil" );
    XCTAssertEqualObjects( result.itemId, @"{UPPER case}", @"cached id mismatch" );
}

#pragma mark -
#pragma mark Search
-(void)testSearchChildrenById
{
    NSArray* result = nil;

    // setup
    {
        [ self->_storage registerItem: self->_sitecoreContent
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: self->_sitecoreContent.itemId ];
        
        [ self->_storage registerItem: self->_homeRecord
                 withAllFieldsInCache: NO
               withAllChildrenInCache: YES
                               forKey: self->_homeRecord.itemId ];
        
        [ self->_storage registerItem: self->_record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: YES
                               forKey: self->_record.itemId ];
        
        [ self->_storage registerItem: self->_otherRecord
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: self->_otherRecord.itemId ];
    }

    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_sitecoreContent.itemId
                                             searchProperty: _idGetterBlock ];
            XCTAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_sitecoreContent.itemId
                                                searchProperty: _idGetterBlock ];
            XCTAssertTrue( 1 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_homeRecord.itemId
                                             searchProperty: _idGetterBlock ];
            XCTAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_homeRecord.itemId
                                                searchProperty: _idGetterBlock ];
            XCTAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
    }


    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_record.itemId
                                             searchProperty: _idGetterBlock ];
            XCTAssertNotNil( result, @"no ALL children expected" );
            XCTAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_record.itemId
                                                searchProperty: _idGetterBlock ];
            XCTAssertNotNil( result, @"no ALL children expected" );
            XCTAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_otherRecord.itemId
                                             searchProperty: _idGetterBlock ];
            XCTAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_otherRecord.itemId
                                                searchProperty: _idGetterBlock ];
            XCTAssertNotNil( result, @"no ALL children expected" );
            XCTAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
    }

    {
        {
            result = [ self->_storage allChildrenForItemKey: @"trololo"
                                             searchProperty: _idGetterBlock ];
            XCTAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: @"trololo"
                                                searchProperty: _idGetterBlock ];
            XCTAssertNil( result, @"no ALL children expected" );
        }
    }
}

-(void)testSearchChildrenByPath
{
    NSArray* result = nil;
    
    // setup
    {
        [ self->_storage registerItem: self->_sitecoreContent
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: self->_sitecoreContent.path ];
        
        [ self->_storage registerItem: self->_homeRecord
                 withAllFieldsInCache: NO
               withAllChildrenInCache: YES
                               forKey: self->_homeRecord.path ];
        
        [ self->_storage registerItem: self->_record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: YES
                               forKey: self->_record.path ];
        
        [ self->_storage registerItem: self->_otherRecord
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: self->_otherRecord.path ];
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_sitecoreContent.path
                                             searchProperty: _pathGetterBlock ];
            XCTAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_sitecoreContent.path
                                                searchProperty: _pathGetterBlock ];
            XCTAssertTrue( 1 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_homeRecord.path
                                             searchProperty: _pathGetterBlock ];
            XCTAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_homeRecord.path
                                                searchProperty: _pathGetterBlock ];
            XCTAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_record.path
                                             searchProperty: _pathGetterBlock ];
            XCTAssertNotNil( result, @"no ALL children expected" );
            XCTAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_record.path
                                                searchProperty: _pathGetterBlock ];
            XCTAssertNotNil( result, @"no ALL children expected" );
            XCTAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_otherRecord.path
                                             searchProperty: _pathGetterBlock ];
            XCTAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_otherRecord.path
                                                searchProperty: _pathGetterBlock ];
            XCTAssertNotNil( result, @"no ALL children expected" );
            XCTAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: @"trololo"
                                             searchProperty: _pathGetterBlock ];
            XCTAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: @"trololo"
                                                searchProperty: _pathGetterBlock ];
            XCTAssertNil( result, @"no ALL children expected" );
        }
    }
}

-(void)testAllFieldsCaching
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_itemSource copy ];
    record.fieldsByName = [ NSDictionary dictionaryWithDictionary: self->_homeFields ];
    
    NSString* key = [ record.itemId copy ];
    
    [ self->_storage registerItem: record
             withAllFieldsInCache: YES
           withAllChildrenInCache: NO
                           forKey: key ];
    
    SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
    XCTAssertTrue( record == cachedRecord, @"cached record mismatch" );
    
    SCItemAndFields* entity = [ self->_storage getStoredEntityForItemKey: key ];
    XCTAssertTrue( entity.cachedItemRecord == record, @"cached record mismatch" );
    XCTAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
    XCTAssertNotNil( entity.cachedItemFieldsByName, @"cached fields mismatch" );
    
    XCTAssertTrue( 2 == [ entity.cachedItemFieldsByName count ], @"fields count mismatch" );
    
    SCFieldRecord* textField = [ self->_storage fieldWithName: @"Text"
                                                      itemKey: key ];
    XCTAssertNotNil( textField, @"no fields expected" );
    
    NSDictionary* cachedFields = [ self->_storage cachedFieldsByNameForItemKey: key ];
    NSDictionary* allCachedFields = [ self->_storage allFieldsByNameForItemKey: key ];

    XCTAssertTrue( 2 == [ cachedFields    count ], @"cachedFields count mismatch" );
    XCTAssertTrue( 2 == [ allCachedFields count ], @"allCachedFields count mismatch" );
    
    SCField* fieldForUser = cachedFields[ @"Title" ];
    XCTAssertTrue( [ fieldForUser isKindOfClass: [ SCField class ] ], @"field class mismatch" );
    XCTAssertEqualObjects( fieldForUser.fieldValue, @"Welcome to Sitecore", @"field name mismatch" );
}

-(void)testSomeFieldsCaching
{
    SCItemRecord* record = [ SCItemRecord new ];
    record.itemId = @"{1111-222-333}";
    record.path = @"/sitecore/content/home";
    record.itemSource = [ self->_itemSource copy ];
    record.fieldsByName = [ NSDictionary dictionaryWithDictionary: self->_homeFields ];
    
    NSString* key = [ record.itemId copy ];
    
    [ self->_storage registerItem: record
             withAllFieldsInCache: NO
           withAllChildrenInCache: NO
                           forKey: key ];
    
    SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
    XCTAssertTrue( record == cachedRecord, @"cached record mismatch" );
    
    SCItemAndFields* entity = [ self->_storage getStoredEntityForItemKey: key ];
    XCTAssertTrue( entity.cachedItemRecord == record, @"cached record mismatch" );
    XCTAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
    XCTAssertNotNil( entity.cachedItemFieldsByName, @"cached fields mismatch" );
    
    XCTAssertTrue( 2 == [ entity.cachedItemFieldsByName count ], @"fields count mismatch" );
    
    SCFieldRecord* textField = [ self->_storage fieldWithName: @"Text"
                                                      itemKey: key ];
    XCTAssertNotNil( textField, @"no fields expected" );
    
    NSDictionary* cachedFields = [ self->_storage cachedFieldsByNameForItemKey: key ];
    NSDictionary* allCachedFields = [ self->_storage allFieldsByNameForItemKey: key ];
    
    XCTAssertTrue( 2 == [ cachedFields    count ], @"cachedFields count mismatch" );
    XCTAssertNil( allCachedFields, @"allCachedFields count mismatch" );
    
    
    SCField* fieldForUser = cachedFields[ @"Title" ];
    XCTAssertTrue( [ fieldForUser isKindOfClass: [ SCField class ] ], @"field class mismatch" );
    XCTAssertEqualObjects( fieldForUser.fieldValue, @"Welcome to Sitecore", @"field name mismatch" );
}

-(void)testFieldTypesMustBeAsserted
{
    self->_storage.shouldCheckRecordTypes = YES;
    SCItemRecord* record = [ SCItemRecord new ];
    NSString* key = nil;
    {
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.fieldsByName = @{ @"1" : @"1", @"2" : @"2", @"3" : @"3" };
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
    
        XCTAssertThrows
        (
            [ self->_storage registerItem: record
                     withAllFieldsInCache: NO
                   withAllChildrenInCache: NO
                                   forKey: key ],
            @"assert expected"
        );
    }
    
    
    self->_storage.shouldCheckRecordTypes = NO;
    record = [ SCItemRecord new ];
    key = nil;
    {
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.fieldsByName = @{ @"1" : @"1", @"2" : @"2", @"3" : @"3" };
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
    }

    self->_storage.shouldCheckRecordTypes = YES;
    SCItemRecord* freshRecord = [ SCItemRecord new ];
    {
        freshRecord.itemId = @"{1111-222-333}";
        freshRecord.path = @"/sitecore/content/home/XYZ";
        freshRecord.itemSource = [ self->_itemSource copy ];
        
        
        NSDictionary* mockFields = @{ @"2" : @"222", @"3333" : @"3" };
        freshRecord.fieldsByName = mockFields;
        
        XCTAssertThrows
        (
            [ self->_storage registerItem: freshRecord
                     withAllFieldsInCache: NO
                   withAllChildrenInCache: NO
                                   forKey: key ],
            @"assert expected"
        );
    }
}

@end
