@interface ItemSourceCopyingTest : XCTestCase
@end


@implementation ItemSourceCopyingTest
{
    SCItemSourcePOD* _testSource;
}

-(void)setUp
{
    [ super setUp ];
    self->_testSource = [ SCItemSourcePOD new ];
    {
        self->_testSource.database    = @"x"     ;
        self->_testSource.site        = @"y"     ;
        self->_testSource.language    = @"en"    ;
        self->_testSource.itemVersion = @"100500";
    }
}

-(void)testSourceHasFourProperties
{
    unsigned int propsCount = 0;
    objc_property_t* props = class_copyPropertyList( [ SCItemSourcePOD class ], &propsCount );
    free(props);
    
    XCTAssertTrue( 4 == propsCount, @"properties count mismatch" );
}

-(void)testAllFieldsAreCopied
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    XCTAssertFalse( other == self->_testSource, @"objects must be different" );
    
    XCTAssertEqualObjects( other, self->_testSource, @"copy must be equal to the original" );
    XCTAssertEqualObjects( other.site, self->_testSource.site, @"site mismatch" );
    XCTAssertTrue( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testSiteFieldIsCompared
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    XCTAssertFalse( other == self->_testSource, @"objects must be different" );
    
    other.site = @"shell";
    XCTAssertFalse( [ other isEqual: self->_testSource ], @"copy must be equal to the original" );
    XCTAssertFalse( [ other.site isEqualToString: self->_testSource.site ], @"site mismatch" );
    XCTAssertFalse( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testDatabaseFieldIsComared
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    XCTAssertFalse( other == self->_testSource, @"objects must be different" );
    
    other.database = @"core";
    XCTAssertFalse( [ other isEqual: self->_testSource ], @"changed copy must NOT be equal to the original" );
    XCTAssertFalse( [ other.database isEqualToString: self->_testSource.database ], @"database mismatch" );
    XCTAssertFalse( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testLanguageFieldIsComared
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    XCTAssertFalse( other == self->_testSource, @"objects must be different" );
    
    other.language = @"deutsch";
    XCTAssertFalse( [ other isEqual: self->_testSource ], @"changed copy must NOT be equal to the original" );
    XCTAssertFalse( [ other.language isEqualToString: self->_testSource.language ], @"language mismatch" );
    XCTAssertFalse( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testVersionFieldIsNotComared
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    XCTAssertFalse( other == self->_testSource, @"objects must be different" );
    
    other.itemVersion = @"222";
    XCTAssertTrue( [ other isEqual: self->_testSource ], @"changed copy must NOT be equal to the original" );
    XCTAssertFalse( [ other.itemVersion isEqualToString: self->_testSource.itemVersion ], @"version mismatch" );
    XCTAssertTrue( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testSettersConvertToLowerCase
{
    SCItemSourcePOD* itemSrc = [ SCItemSourcePOD new ];

    itemSrc.database    = @"Long";
    itemSrc.site        = @"LIVE";
    itemSrc.language    = @"tHE" ;
    itemSrc.itemVersion = @"kinG";

    XCTAssertEqualObjects( itemSrc.database    , @"long", @"case mismatch" );
    XCTAssertEqualObjects( itemSrc.site        , @"live", @"case mismatch" );
    XCTAssertEqualObjects( itemSrc.language    , @"the" , @"case mismatch" );
    XCTAssertEqualObjects( itemSrc.itemVersion , @"king", @"case mismatch" );
}

@end
