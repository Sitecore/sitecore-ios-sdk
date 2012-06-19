#import "SqlitePersistentDateFormatter.h"
#include "SqliteFunctions.h"
#include <sqlite3.h>

#import <SenTestingKit/SenTestingKit.h>

@interface WeekCalendarQueryTest_V2 : SenTestCase

@end

@implementation WeekCalendarQueryTest_V2
{
    @private
    sqlite3* _db;
    char* _sqliteError;
}

-(void)setUp
{
    NSString* dbPath_ = [ [ NSBundle bundleForClass: [ self class ] ] pathForResource: @"2" 
                                                                               ofType: @"sqlite" ];
    
    sqlite3_open( [ dbPath_ cStringUsingEncoding: NSUTF8StringEncoding ] , &self->_db );
    
    sqlite3_create_function( self->_db, "ObjcFormatAnsiDateUsingLocale", 3, 
                            SQLITE_UTF8, NULL, 
                            &ObjcFormatAnsiDateUsingLocale_v2,
                            NULL, NULL );
}

-(void)tearDown
{
    sqlite3_close( self->_db );
    sqlite3_free( self->_sqliteError );

    [ [ NSFileManager defaultManager ] removeItemAtPath: @"2.sqlite" 
                                                  error: NULL ];
}

-(void)test2011_01_02US
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'YYYY-ww', '2011-01-02', 'en_US' )";
    
    sqlite3_stmt* statement_ = NULL;
    
    [ SqlitePersistentDateFormatter freeInstance ];
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "2011-02" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}

-(void)test2011_01_02RUS
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'YYYY-ww', '2011-01-02', 'ru_RU' );";
    
    sqlite3_stmt* statement_ = NULL;
    [ SqlitePersistentDateFormatter freeInstance ];
    
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "2011-01" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}

-(void)test2010_12_26BelongsTo2010_RUS
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'YYYY-ww', '2010-12-26', 'ru_RU' )";
    
    sqlite3_stmt* statement_ = NULL;
    [ SqlitePersistentDateFormatter freeInstance ];
    
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "2010-52" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}

-(void)testNullArgsResultInError
{
    {
        int qResult_ = 0;
        sqlite3_stmt* statement_ = NULL;
        [ SqlitePersistentDateFormatter freeInstance ];
        
        const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( null, '2011-01-02', 'en_US' );";
        
        
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( qResult_ == SQLITE_ERROR, @"sqlite error expected - %d", qResult_ );
        
        sqlite3_finalize( statement_ );
    }
    
    
    {
        int qResult_ = 0;
        sqlite3_stmt* statement_ = NULL;
        [ SqlitePersistentDateFormatter freeInstance ];
        
        const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'YYYY-ww', null, 'en_US' );";
        
        
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( qResult_ == SQLITE_ERROR, @"sqlite error expected - %d", qResult_ );
        
        sqlite3_finalize( statement_ );
    }
    
    {
        int qResult_ = 0;
        sqlite3_stmt* statement_ = NULL;
        [ SqlitePersistentDateFormatter freeInstance ];
        
        const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'YYYY-ww', '2011-01-02', null );";
        
        
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( qResult_ == SQLITE_ERROR, @"sqlite error expected - %d", qResult_ );
        
        sqlite3_finalize( statement_ );
    }
}

-(void)testArgsCountMismatchIsCheckedBySqlite
{
    {
        int qResult_ = 0;
        sqlite3_stmt* statement_ = NULL;
        
        
        const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'YYYY-WW', '2011-01-02' );";
        [ SqlitePersistentDateFormatter freeInstance ];
        
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_ERROR, @"unexpected sqlite3_prepare failure" );    
        
        sqlite3_finalize( statement_ );
    }
    
    
    
    {
        int qResult_ = 0;
        sqlite3_stmt* statement_ = NULL;
        [ SqlitePersistentDateFormatter freeInstance ];
        
        const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'YYYY-WW', '2011-01-02', 'en_US', '1', '2', '3' );";
        
        
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_ERROR, @"unexpected sqlite3_prepare failure" );    
        
        sqlite3_finalize( statement_ );
    }
}

-(void)testInvalidDataResultsInNull
{   
    {
        int qResult_ = 0;
        sqlite3_stmt* statement_ = NULL;
        const unsigned char* result_ = NULL;
        
        
        const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'blablabla', '2011-01-02', 'en_US' );";
        [ SqlitePersistentDateFormatter freeInstance ];
        
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
        STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
        
        result_ = sqlite3_column_text( statement_, 0 );
        STAssertTrue( NULL == result_ , @"raw answer mismatch" );
        
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
        sqlite3_finalize( statement_ );
    }
    
    
    {
        int qResult_ = 0;
        sqlite3_stmt* statement_ = NULL;
        const unsigned char* result_ = NULL;
        [ SqlitePersistentDateFormatter freeInstance ];
        
        const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'YYYY-ww', 'date should have been here', 'en_US' );";
        
        
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
        STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
        
        result_ = sqlite3_column_text( statement_, 0 );
        STAssertTrue( NULL == result_ , @"raw answer mismatch" );
        
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
        sqlite3_finalize( statement_ );
    }    
    
    
    {
        int qResult_ = 0;
        sqlite3_stmt* statement_ = NULL;
        const unsigned char* result_ = NULL;
        
        
        const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'YYYY-ww', '2011-01-02', 'locale should have been here' );";
        
        [ SqlitePersistentDateFormatter freeInstance ];
        [ SqlitePersistentDateFormatter instance ].validateLocale = YES;
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
        STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
        
        result_ = sqlite3_column_text( statement_, 0 );
        STAssertTrue( NULL == result_ , @"raw answer mismatch" );
        
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
        sqlite3_finalize( statement_ );
    }     
}


-(void)testInvalidFormatLeadsToUndefinedBehaviour
{
    int qResult_ = 0;
    sqlite3_stmt* statement_ = NULL;
    const unsigned char* result_ = NULL;
    
    
    const char* query_ = "SELECT ObjcFormatAnsiDateUsingLocale( 'abrakadabra', '2011-01-02', 'en_US' );";
    [ SqlitePersistentDateFormatter freeInstance ];
    
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "AM" ) , @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    sqlite3_finalize( statement_ );
}

@end
