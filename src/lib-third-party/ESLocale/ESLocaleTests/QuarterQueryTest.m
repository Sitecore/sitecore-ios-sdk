#import "SqlitePersistentDateFormatter.h"
#include "SqliteFunctions.h"
#include <sqlite3.h>

#import <SenTestingKit/SenTestingKit.h>

@interface QuarterQueryTest : SenTestCase
@end

@implementation QuarterQueryTest
{
@private
    sqlite3* _db;
    char* _sqliteError;
}

-(void)setUp
{
    NSString* dbPath_ = [ [ NSBundle bundleForClass: [ self class ] ] pathForResource: @"hYear" 
                                                                               ofType: @"sqlite" ];
    
    sqlite3_open( [ dbPath_ cStringUsingEncoding: NSUTF8StringEncoding ] , &self->_db );
    
    sqlite3_create_function( self->_db, "ObjcGetYearAndQuarterUsingLocale", 2, 
                            SQLITE_UTF8, NULL, 
                            &ObjcGetYearAndQuarterUsingLocale,
                            NULL, NULL );
}

-(void)tearDown
{
    sqlite3_close( self->_db );
    sqlite3_free( self->_sqliteError );
    
    [ [ NSFileManager defaultManager ] removeItemAtPath: @"quarter.sqlite"
                                                  error: NULL ];
}


-(void)testJan1
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-01-01', 'en_US' );";
    
    sqlite3_stmt* statement_ = NULL;
    
    [ SqlitePersistentDateFormatter freeInstance ];
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "Q1 '11" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}

-(void)testMar31
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-03-31', 'en_US' )";
    
    sqlite3_stmt* statement_ = NULL;
    
    [ SqlitePersistentDateFormatter freeInstance ];
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "Q1 '11" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}


-(void)testApr1
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-04-01', 'en_US' );";
    
    sqlite3_stmt* statement_ = NULL;
    
    [ SqlitePersistentDateFormatter freeInstance ];
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "Q2 '11" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}

-(void)testJun30
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-06-30', 'en_US' )";
    
    sqlite3_stmt* statement_ = NULL;
    
    [ SqlitePersistentDateFormatter freeInstance ];
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "Q2 '11" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}


-(void)testJuly1
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-07-01', 'en_US' );";
    
    sqlite3_stmt* statement_ = NULL;
    
    [ SqlitePersistentDateFormatter freeInstance ];
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "Q3 '11" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}

-(void)testSep30
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-09-30', 'en_US' )";
    
    sqlite3_stmt* statement_ = NULL;
    
    [ SqlitePersistentDateFormatter freeInstance ];
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "Q3 '11" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}

-(void)testOct1
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-10-01', 'en_US' )";
    
    sqlite3_stmt* statement_ = NULL;
    
    [ SqlitePersistentDateFormatter freeInstance ];
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "Q4 '11" ), @"raw answer mismatch" );
    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( SQLITE_DONE == qResult_, @"query must have only one record" );
    
    sqlite3_finalize( statement_ );
}

-(void)testDec31
{
    int qResult_ = 0;
    const unsigned char* result_ = NULL;
    
    const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-12-31', 'en_US' )";
    
    sqlite3_stmt* statement_ = NULL;
    
    [ SqlitePersistentDateFormatter freeInstance ];
    qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
    STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
    
    qResult_ = sqlite3_step( statement_ );
    STAssertTrue( qResult_ == SQLITE_ROW, @"query must have only one record - %d", qResult_ );    
    STAssertTrue( 1 == sqlite3_column_count( statement_ ), @"column count mismatch" );
    
    result_ = sqlite3_column_text( statement_, 0 );
    STAssertTrue( 0 == strcmp( (const char*)result_, "Q4 '11" ), @"raw answer mismatch" );
    
    
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
        
        const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( null, 'en_US' );";
        
        
        
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
        
        const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-01-02', null );";
        
        
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( qResult_ == SQLITE_ERROR, @"sqlite error expected - %d", qResult_ );
        
        sqlite3_finalize( statement_ );
    }
}


-(void)testInvalidDataResultsInNull
{   
    {
        int qResult_ = 0;
        sqlite3_stmt* statement_ = NULL;
        const unsigned char* result_ = NULL;
        [ SqlitePersistentDateFormatter freeInstance ];
        
        const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( 'date should have been here', 'en_US' );";
        
        
        
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
        
        const char* query_ = "SELECT ObjcGetYearAndQuarterUsingLocale( '2011-01-02', 'locale should have been here' );";
        
        [ SqlitePersistentDateFormatter freeInstance ];
        [ SqlitePersistentDateFormatter instance ].validateLocale = YES;
        
        qResult_ = sqlite3_prepare( self->_db, query_, (int)strlen( (char*)query_ ), &statement_, NULL );
        STAssertTrue( qResult_ == SQLITE_OK, @"unexpected sqlite3_prepare failure" );    
        
        qResult_ = sqlite3_step( statement_ );
        STAssertTrue( qResult_ == SQLITE_ERROR, @"error expected - %d", qResult_ );    
        
        sqlite3_finalize( statement_ );
    }     
}

@end
