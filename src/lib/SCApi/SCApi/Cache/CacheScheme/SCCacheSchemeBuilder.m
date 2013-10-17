#import "SCCacheSchemeBuilder.h"

#import "SCCacheSettings.h"

@implementation SCCacheSchemeBuilder
{
    id<ESReadOnlyDbWrapper, ESWritableDbWrapper> _db;
    SCCacheSettings* _settings;
    SCItemSourcePOD* _itemSource;
}

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithDatabase:( id<ESReadOnlyDbWrapper, ESWritableDbWrapper> )db
                       settings:( SCCacheSettings* )settings
                     itemSource:( SCItemSourcePOD* )itemSource
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }

    self->_db = db;
    self->_settings = settings;
    self->_itemSource = itemSource;

    return self;
}

-(void)setupScheme
{
    [ self createItemsTable  ];
    [ self createFieldsTable ];
    
    [ self createSettingsTable ];
    [ self setupSettings       ];
}


-(void)createItemsTable
{
    NSString* const query =
    @"CREATE TABLE \n"
    @"IF NOT EXISTS \n"
    @"[Items] \n"
    @"(\n"
    @"   [Timestamp]   DATETIME, \n"
    @"   [ItemId]      VARCHAR PRIMARY KEY COLLATE NOCASE, \n"
    @"   [LongId]      VARCHAR COLLATE NOCASE, \n"
    @"   [Path]        VARCHAR COLLATE NOCASE, \n"
    @"   [DisplayName] VARCHAR, \n"
    @"   [SitecoreTemplate] VARCHAR, \n"
    @"   [HasChildren] BOOL, \n"
    @"   [IsAllChildrenCached] BOOL, \n"
    @"   [IsAllFieldsCached] BOOL \n"
    @");\n";

    NSString* const pathIndex =
    @"CREATE INDEX \n"
    @"IF NOT EXISTS \n"
    @"[idx_item_path] \n"
    @"ON [Items] (Path ASC);";


    NSError* error = nil;
    [ self->_db createTable: query
                      error: &error ];
    [ error writeErrorToNSLog ];
    
    
    [ self->_db update: pathIndex
                 error: &error ];
    [ error writeErrorToNSLog ];
}

-(void)createFieldsTable
{
    NSString* const query =
    @"CREATE TABLE \n"
    @"IF NOT EXISTS \n"
    @"[Fields] \n"
    @"(\n"
    @"   ItemId VARCHAR  COLLATE NOCASE, \n"
    @"   FieldId VARCHAR COLLATE NOCASE, \n"
    @"   Name VARCHAR, \n"
    @"   Type VARCHAR, \n"
    @"   RawValue VARCHAR, \n"
    @"   HasLocalModifications BOOL, \n"
    @"   UNIQUE (ItemId, FieldId) \n"
    @");\n";

    NSString* const itemIdIndex =
    @"CREATE INDEX \n"
    @"IF NOT EXISTS \n"
    @"[idx_fld_itemId] \n"
    @"ON [Fields] (ItemId ASC);";
    
    NSString* const fieldIdIndex =
    @"CREATE INDEX \n"
    @"IF NOT EXISTS \n"
    @"[idx_fld_fieldId] \n"
    @"ON [Fields] (FieldId ASC);";
    
    NSError* error = nil;
    [ self->_db createTable: query
                      error: &error ];
    [ error writeErrorToNSLog ];
    
    [ self->_db update: itemIdIndex
                 error: &error ];
    [ error writeErrorToNSLog ];
    
    [ self->_db update: fieldIdIndex
                 error: &error ];
    [ error writeErrorToNSLog ];
}

-(void)createSettingsTable
{
    NSString* const query =
    @"CREATE TABLE \n"
    @"IF NOT EXISTS \n"
    @"[Settings] \n"
    @"(\n"
    @"   CacheDbVersion VARCHAR UNIQUE, \n"
    @"   Host VARCHAR UNIQUE, \n"
    @"   User VARCHAR UNIQUE, \n"
    @"   SitecoreSite VARCHAR UNIQUE, \n"
    @"   SitecoreLanguage VARCHAR UNIQUE, \n"
    @"   SitecoreDatabase VARCHAR UNIQUE \n"
    @");\n";
    
    
    NSError* error = nil;
    [ self->_db createTable: query
                      error: &error ];
    [ error writeErrorToNSLog ];
}

-(void)setupSettings
{
    NSString* const queryFormat =
    @"INSERT OR REPLACE \n"
    @"INTO [Settings] \n"
    @"(\n"
    @"   CacheDbVersion, "
    @"   Host, "
    @"   User, "
    @"   SitecoreSite, "
    @"   SitecoreLanguage, "
    @"   SitecoreDatabase  "
    @")\n"
    @"VALUES \n"
    @"(\n"
    @"%@"
    @")\n";
    
    NSArray* settingsArray =
    @[
      [ NSString sqlite3QuotedStringOrNull: self->_settings.cacheDbVersion ],
      [ NSString sqlite3QuotedStringOrNull: self->_settings.host           ],
      [ NSString sqlite3QuotedStringOrNull: self->_settings.userName       ],
      [ NSString sqlite3QuotedStringOrNull: self->_itemSource.site         ],
      [ NSString sqlite3QuotedStringOrNull: self->_itemSource.language     ],
      [ NSString sqlite3QuotedStringOrNull: self->_itemSource.database     ]
    ];
    NSString* settings = [ settingsArray componentsJoinedByString: @",\n   " ];
    NSString* query = [ NSString stringWithFormat: queryFormat, settings ];

    
    NSError* error = nil;
    [ self->_db insert: query
                 error: &error ];
    [ error writeErrorToNSLog ];
}

@end
