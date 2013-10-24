@interface ItemSourceCopyingTest : SenTestCase
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
    
    STAssertTrue( 4 == propsCount, @"properties count mismatch" );
}

-(void)testAllFieldsAreCopied
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    STAssertFalse( other == self->_testSource, @"objects must be different" );
    
    STAssertEqualObjects( other, self->_testSource, @"copy must be equal to the original" );
    STAssertEqualObjects( other.site, self->_testSource.site, @"site mismatch" );
    STAssertTrue( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testSiteFieldIsCompared
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    STAssertFalse( other == self->_testSource, @"objects must be different" );
    
    other.site = @"shell";
    STAssertFalse( [ other isEqual: self->_testSource ], @"copy must be equal to the original" );
    STAssertFalse( [ other.site isEqualToString: self->_testSource.site ], @"site mismatch" );
    STAssertFalse( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testDatabaseFieldIsComared
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    STAssertFalse( other == self->_testSource, @"objects must be different" );
    
    other.database = @"core";
    STAssertFalse( [ other isEqual: self->_testSource ], @"changed copy must NOT be equal to the original" );
    STAssertFalse( [ other.database isEqualToString: self->_testSource.database ], @"database mismatch" );
    STAssertFalse( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testLanguageFieldIsComared
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    STAssertFalse( other == self->_testSource, @"objects must be different" );
    
    other.language = @"deutsch";
    STAssertFalse( [ other isEqual: self->_testSource ], @"changed copy must NOT be equal to the original" );
    STAssertFalse( [ other.language isEqualToString: self->_testSource.language ], @"language mismatch" );
    STAssertFalse( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testVersionFieldIsNotComared
{
    SCItemSourcePOD* other = [ self->_testSource copy ];
    STAssertFalse( other == self->_testSource, @"objects must be different" );
    
    other.itemVersion = @"222";
    STAssertTrue( [ other isEqual: self->_testSource ], @"changed copy must NOT be equal to the original" );
    STAssertFalse( [ other.itemVersion isEqualToString: self->_testSource.itemVersion ], @"version mismatch" );
    STAssertTrue( self->_testSource.hash == other.hash, @"hash mismatch" );
}

-(void)testSettersConvertToLowerCase
{
    SCItemSourcePOD* itemSrc = [ SCItemSourcePOD new ];

    itemSrc.database    = @"Long";
    itemSrc.site        = @"LIVE";
    itemSrc.language    = @"tHE" ;
    itemSrc.itemVersion = @"kinG";

    STAssertEqualObjects( itemSrc.database    , @"long", @"case mismatch" );
    STAssertEqualObjects( itemSrc.site        , @"live", @"case mismatch" );
    STAssertEqualObjects( itemSrc.language    , @"the" , @"case mismatch" );
    STAssertEqualObjects( itemSrc.itemVersion , @"king", @"case mismatch" );
}

@end
