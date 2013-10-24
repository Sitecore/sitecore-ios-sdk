#import <SenTestingKit/SenTestingKit.h>

@interface ItemRecordStorageTest : SenTestCase
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
                                                              apiContext: nil ];

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
    STAssertThrows( [ SCInMemoryRecordStorage new ], @"assert expected" );
}

-(void)testInMemoryStorageRemembersSource
{
    STAssertEqualObjects( self->_storage.itemSource, self->_itemSource, @"item source mismatch" );
    STAssertTrue( self->_storage.itemSource == self->_itemSource, @"item source mismatch" );
}

#pragma mark -
#pragma mark Cleanup
-(void)testCleanupDropsStorage
{
    NSMutableDictionary* mockStorage = [ @{ @"1" : @"1", @"2" : @"2" } mutableCopy];
    
    self->_storage.storage = mockStorage;
    [ self->_storage cleanup ];
    
    STAssertFalse( [ self->_storage.storage isEqual: mockStorage ], @"storage not dropped" );
    STAssertNotNil( self->_storage.storage, @"dropped storage must not be nil" );
    STAssertTrue( 0 == [ self->_storage.storage count ], @"dropped storage must be empty" );
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
    
    NSString* key = [ record.itemId copy ];
    
    [ self->_storage registerItem: record
             withAllFieldsInCache: NO
           withAllChildrenInCache: NO
                           forKey: key ];
    
    SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
    STAssertTrue( record == cachedRecord, @"cached record mismatch" );
    
    SCItemAndFields* entity = [ self->_storage getStoredEntityForItemKey: key ];
    STAssertTrue( entity.cachedItemRecord == record, @"cached record mismatch" );
    STAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
    STAssertNil( entity.cachedItemFieldsByName, @"cached fields mismatch" );
    
    SCFieldRecord* mockField = [self->_storage fieldWithName: @"1"
                                                     itemKey: key ];
    STAssertNil( mockField, @"no fields expected" );
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
    STAssertTrue( record == cachedRecord, @"cached record mismatch" );

    STAssertTrue( record.itemSource == self->_itemSource, @"source object address mismatch" );
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
        record.fieldsByName = @{ @"1" : @"1" };
        record.itemSource = [ self->_itemSource copy ];
        
        key = [ record.itemId copy ];
        
        [ self->_storage registerItem: record
                 withAllFieldsInCache: NO
               withAllChildrenInCache: NO
                               forKey: key ];
        
        SCItemRecord* cachedRecord = [ self->_storage itemRecordForItemKey: key ];
        STAssertTrue( record == cachedRecord, @"cached record mismatch" );
        

        NSDictionary* fields = [ self->_storage allFieldsByNameForItemKey: key ];
        STAssertNil( fields, @"all fields must not be available yet" );
        
        
        
        SCFieldRecord* mockField = [self->_storage fieldWithName: @"1"
                                                         itemKey: key ];
        STAssertNotNil( mockField, @"no fields expected" );
        STAssertTrue( [ @"1" isEqualToString: (NSString*)mockField ], @"mock field mismatch" );
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
        STAssertTrue( entity.cachedItemRecord == freshRecord, @"cached record mismatch" );
        STAssertTrue( entity.isAllFieldItemsCached, @"fields flag mismatch" );
        STAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
        
        STAssertTrue( mockFields == entity.cachedItemFieldsByName, @"fields mismatch" );
        STAssertEqualObjects( mockFields, entity.cachedItemFieldsByName, @"fields mismatch" );
        
        SCFieldRecord* mockField = [ self->_storage fieldWithName: @"2"
                                                          itemKey: key ];
        STAssertNotNil( mockField, @"no fields expected" );
        STAssertTrue( [ @"2" isEqualToString: (NSString*)mockField ], @"mock field mismatch" );
        
        mockField = [ self->_storage fieldWithName: @"3"
                                           itemKey: key ];
        STAssertTrue( [ @"3" isEqualToString: (NSString*)mockField ], @"mock field mismatch" );
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
        STAssertTrue( record == cachedRecord, @"cached record mismatch" );
        
        
        NSDictionary* fields = [ self->_storage allFieldsByNameForItemKey: key ];
        STAssertNil( fields, @"all fields must not be available yet" );
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
        STAssertTrue( entity.cachedItemRecord == freshRecord, @"cached record mismatch" );
        STAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
        
        NSDictionary* expectedMockFields =
        @{
          @"1" : @"1",
          @"2" : @"222",
          @"3" : @"3",
          @"3333" : @"3"
        };
        
        STAssertEqualObjects( expectedMockFields, entity.cachedItemFieldsByName, @"fields mismatch" );
        STAssertEqualObjects( expectedMockFields, freshRecord.fieldsByName, @"fields mismatch" );
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
        STAssertTrue( 1 == [ self->_storage.storage count ], @"cached items mismatch" );
        SCItemAndFields* entity = [ [ self->_storage.storage allValues ] lastObject ];

        STAssertTrue( entity.cachedItemRecord == otherRecord, @"remaining record mismatch" );
        STAssertEqualObjects( entity.cachedItemRecord.itemId, @"{2222}", @"remaining id mismatch" );
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
    
    STAssertTrue( [ self->_storage.storage count ] == 1, @"count mismatch" );
    
    SCItemAndFields* entity = [ [self->_storage.storage allValues ] lastObject ];
    STAssertEqualObjects( entity.cachedItemRecord.itemId, @"{UPPER case}", @"cached id mismatch" );
    
    NSString* entityKey = [ [ self->_storage.storage allKeys ] lastObject ];
    STAssertEqualObjects( @"/sitecore/content/home", entityKey, @"key mismatch" );
    
    
    SCItemRecord* result = [ self->_storage itemRecordForItemKey: @"/sitecore/CONTENT/home" ];
    STAssertNotNil( result, @"record from cache is nil" );
    STAssertEqualObjects( result.itemId, @"{UPPER case}", @"cached id mismatch" );
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
            STAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_sitecoreContent.itemId
                                                searchProperty: _idGetterBlock ];
            STAssertTrue( 1 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_homeRecord.itemId
                                             searchProperty: _idGetterBlock ];
            STAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_homeRecord.itemId
                                                searchProperty: _idGetterBlock ];
            STAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
    }


    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_record.itemId
                                             searchProperty: _idGetterBlock ];
            STAssertNotNil( result, @"no ALL children expected" );
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_record.itemId
                                                searchProperty: _idGetterBlock ];
            STAssertNotNil( result, @"no ALL children expected" );
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_otherRecord.itemId
                                             searchProperty: _idGetterBlock ];
            STAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_otherRecord.itemId
                                                searchProperty: _idGetterBlock ];
            STAssertNotNil( result, @"no ALL children expected" );
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
    }

    {
        {
            result = [ self->_storage allChildrenForItemKey: @"trololo"
                                             searchProperty: _idGetterBlock ];
            STAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: @"trololo"
                                                searchProperty: _idGetterBlock ];
            STAssertNil( result, @"no ALL children expected" );
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
            STAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_sitecoreContent.path
                                                searchProperty: _pathGetterBlock ];
            STAssertTrue( 1 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_homeRecord.path
                                             searchProperty: _pathGetterBlock ];
            STAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_homeRecord.path
                                                searchProperty: _pathGetterBlock ];
            STAssertTrue( 2 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_record.path
                                             searchProperty: _pathGetterBlock ];
            STAssertNotNil( result, @"no ALL children expected" );
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_record.path
                                                searchProperty: _pathGetterBlock ];
            STAssertNotNil( result, @"no ALL children expected" );
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: self->_otherRecord.path
                                             searchProperty: _pathGetterBlock ];
            STAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: self->_otherRecord.path
                                                searchProperty: _pathGetterBlock ];
            STAssertNotNil( result, @"no ALL children expected" );
            STAssertTrue( 0 == [ result count ], @"cached children items mismatch" );
        }
    }
    
    {
        {
            result = [ self->_storage allChildrenForItemKey: @"trololo"
                                             searchProperty: _pathGetterBlock ];
            STAssertNil( result, @"no ALL children expected" );
        }
        
        {
            result = [ self->_storage cachedChildrenForItemKey: @"trololo"
                                                searchProperty: _pathGetterBlock ];
            STAssertNil( result, @"no ALL children expected" );
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
    STAssertTrue( record == cachedRecord, @"cached record mismatch" );
    
    SCItemAndFields* entity = [ self->_storage getStoredEntityForItemKey: key ];
    STAssertTrue( entity.cachedItemRecord == record, @"cached record mismatch" );
    STAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
    STAssertNotNil( entity.cachedItemFieldsByName, @"cached fields mismatch" );
    
    STAssertTrue( 2 == [ entity.cachedItemFieldsByName count ], @"fields count mismatch" );
    
    SCFieldRecord* textField = [ self->_storage fieldWithName: @"Text"
                                                      itemKey: key ];
    STAssertNotNil( textField, @"no fields expected" );
    
    NSDictionary* cachedFields = [ self->_storage cachedFieldsByNameForItemKey: key ];
    NSDictionary* allCachedFields = [ self->_storage allFieldsByNameForItemKey: key ];

    STAssertTrue( 2 == [ cachedFields    count ], @"cachedFields count mismatch" );
    STAssertTrue( 2 == [ allCachedFields count ], @"allCachedFields count mismatch" );
    
    SCField* fieldForUser = cachedFields[ @"Title" ];
    STAssertTrue( [ fieldForUser isKindOfClass: [ SCField class ] ], @"field class mismatch" );
    STAssertEqualObjects( fieldForUser.fieldValue, @"Welcome to Sitecore", @"field name mismatch" );
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
    STAssertTrue( record == cachedRecord, @"cached record mismatch" );
    
    SCItemAndFields* entity = [ self->_storage getStoredEntityForItemKey: key ];
    STAssertTrue( entity.cachedItemRecord == record, @"cached record mismatch" );
    STAssertFalse( entity.isAllChildItemsCached, @"childs flag mismatch" );
    STAssertNotNil( entity.cachedItemFieldsByName, @"cached fields mismatch" );
    
    STAssertTrue( 2 == [ entity.cachedItemFieldsByName count ], @"fields count mismatch" );
    
    SCFieldRecord* textField = [ self->_storage fieldWithName: @"Text"
                                                      itemKey: key ];
    STAssertNotNil( textField, @"no fields expected" );
    
    NSDictionary* cachedFields = [ self->_storage cachedFieldsByNameForItemKey: key ];
    NSDictionary* allCachedFields = [ self->_storage allFieldsByNameForItemKey: key ];
    
    STAssertTrue( 2 == [ cachedFields    count ], @"cachedFields count mismatch" );
    STAssertNil( allCachedFields, @"allCachedFields count mismatch" );
    
    
    SCField* fieldForUser = cachedFields[ @"Title" ];
    STAssertTrue( [ fieldForUser isKindOfClass: [ SCField class ] ], @"field class mismatch" );
    STAssertEqualObjects( fieldForUser.fieldValue, @"Welcome to Sitecore", @"field name mismatch" );
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
    
        STAssertThrows
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
        
        STAssertThrows
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
