#import "SCPersistentStorageBuilder.h"

#import "SCItemSourcePOD.h"
#import "SCItemStorageKinds.h"
#import "SCPersistentRecordStorage.h"
#import "SCCacheSchemeBuilder.h"
#import "SCCacheSettings.h"

@implementation SCPersistentStorageBuilder
{
@private
    NSString* _databasePathBase;
    SCCacheSettings* _settings;
}

@synthesize apiSession = _context;

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithDatabasePathBase:( NSString* )databasePathBase
                               settings:( SCCacheSettings* )settings
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_databasePathBase = databasePathBase;
    self->_settings = settings;
    
    return self;
}

-(SCItemStorageKinds*)newRecordStorageNodeForItemSource:( SCItemSourcePOD* )itemSource
{
    NSString* dbName = [ self cacheNameForItemSource: itemSource ];
    FMDatabase<ESReadOnlyDbWrapper, ESWritableDbWrapper, ESTransactionsWrapper>* db =
    (FMDatabase<ESReadOnlyDbWrapper, ESWritableDbWrapper, ESTransactionsWrapper>*)[ [ FMDatabase alloc ] initWithPath: dbName ];
    BOOL isDbOpen = [ db open ];
    if ( !isDbOpen )
    {
        return nil;
    }
    [ dbName addSkipBackupAttribute ];
    
    SCCacheSchemeBuilder* scheme =
    [ [ SCCacheSchemeBuilder alloc ] initWithDatabase: db
                                             settings: self->_settings
                                           itemSource: itemSource ];
    [ scheme setupScheme ];


    SCItemStorageKinds* result = [ SCItemStorageKinds new ];
    {
        SCPersistentRecordStorage* pStorage = nil;
        NSString* keyColumn = nil;

        
        keyColumn = [ SCPersistentRecordStorage itemIdColumn ];
        pStorage =
        [ [ SCPersistentRecordStorage alloc ] initWithApiSession: self->_context
                                                      itemSource: itemSource
                                                    readDatabase: db
                                                   writeDatabase: db
                                               itemKeyColumnName: keyColumn ];
        pStorage.shouldCloseReadDb  = YES;
        pStorage.shouldCloseWriteDb = YES;
        result.itemRecordById = pStorage;
        

        keyColumn = [ SCPersistentRecordStorage itemPathColumn ];
        pStorage =
        [ [ SCPersistentRecordStorage alloc ] initWithApiSession: self->_context
                                                      itemSource: itemSource
                                                    readDatabase: db
                                                   writeDatabase: nil
                                               itemKeyColumnName: keyColumn ];
        pStorage.shouldCloseReadDb  = YES;
        pStorage.shouldCloseWriteDb = YES;
        result.itemRecordByPath = pStorage;
    }
    
    return result;
}

-(NSString*)cacheNameForItemSource:( SCItemSourcePOD* )itemSource
{
    NSString* site = [ itemSource.site stringByReplacingOccurrencesOfString: @"/"
                                                                 withString: @"_" ];
    if ( nil == site )
    {
        site = @"default";
    }

    
    NSString* lang = itemSource.language;
    if ( nil == lang )
    {
        lang = @"default";
    }
    
    
    NSString* db   = itemSource.database;
    if ( nil == db )
    {
        db = @"default";
    }
    
    
    NSString* serialized = [ NSString stringWithFormat: @"-%@-%@-%@", db, lang, site  ];

    NSString* result = [ self->_databasePathBase stringByAppendingString: serialized ];
    return result;
}

@end
