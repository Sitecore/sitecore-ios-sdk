@interface RichTextFieldTest : XCTestCase
{
    NSBundle* _testBundle;
    NSDictionary* _fieldJson;
    
    SCApiSession * _context;
    SCExtendedApiSession* _contextEx;

    SCFieldRecord* _richTextRecord;
    SCField* _richTextField;
    
    SCFieldRecord* _singleQuoteRecord;
    SCField* _singleQuoteField;
}

@end


@implementation RichTextFieldTest

-(void)setUp
{
    [ super setUp ];
    self->_testBundle = [ NSBundle bundleForClass: [ self class ] ];
    self->_context = [ [SCApiSession alloc] initWithHost: @"mobiledev1ua1.dk.sitecore.net:89" ];
    self->_contextEx = self->_context.extendedApiSession;
}

-(void)testRichTextLinksAreConvertedToFullUrls_SingleQuotes
{
    {
        NSString* jsonPath = [ self->_testBundle pathForResource: @"2-RichText-OnlyField-SingleQuotes"
                                                          ofType: @"json" ];
        NSData* jsonData = [ NSData dataWithContentsOfFile: jsonPath ];
        
        self->_fieldJson = [ NSJSONSerialization JSONObjectWithData: jsonData
                                                            options: 0
                                                              error: NULL ];
        
        self->_singleQuoteRecord = [ SCFieldRecord fieldRecordWithJson: self->_fieldJson
                                                               fieldId: @"{A60ACD61-A6DB-4182-8329-C957982CEC74}"
                                                            apiSession: self->_contextEx ];
        
        self->_singleQuoteField = self->_singleQuoteRecord.field;
    }
    
    XCTAssertNotNil( self->_fieldJson, @"test data not loaded" );
    XCTAssertNotNil( self->_singleQuoteRecord, @"test data not loaded" );
    XCTAssertNotNil( self->_singleQuoteField, @"test data not loaded" );
    
    XCTAssertTrue( [ self->_singleQuoteField isMemberOfClass: [ SCRichTextField class] ], @"field class mismatch" );
    NSString* fieldValue = self->_singleQuoteField.fieldValue;
    NSString* expected =
    @"<p>Welcome to Sitecore</p>\n"
    @"<p><br />\n"
    @"</p>\n"
    @"<p><img alt='' height='100' width='100' src='http://mobiledev1ua1.dk.sitecore.net:89/~/media/4F20B519D5654472B01891CB6103C667.ashx' /></p>";
    
    NSLog( @"%@", fieldValue );
    NSLog( @"%@", expected );
    
    XCTAssertEqualObjects( fieldValue, expected, @"images are not compatible with WebView" );
}

-(void)testRichTextLinksAreConvertedToFullUrls
{
    {
        NSString* jsonPath = [ self->_testBundle pathForResource: @"2-RichText-OnlyField"
                                                          ofType: @"json" ];
        NSData* jsonData = [ NSData dataWithContentsOfFile: jsonPath ];
        
        self->_fieldJson = [ NSJSONSerialization JSONObjectWithData: jsonData
                                                            options: 0
                                                              error: NULL ];
        
        self->_richTextRecord = [ SCFieldRecord fieldRecordWithJson: self->_fieldJson
                                                            fieldId: @"{A60ACD61-A6DB-4182-8329-C957982CEC74}"
                                                         apiSession: self->_contextEx ];
        
        self->_richTextField = self->_richTextRecord.field;
    }
    
    
    XCTAssertNotNil( self->_fieldJson, @"test data not loaded" );
    XCTAssertNotNil( self->_richTextRecord, @"test data not loaded" );
    XCTAssertNotNil( self->_richTextField, @"test data not loaded" );
    
    XCTAssertTrue( [ self->_richTextField isMemberOfClass: [ SCRichTextField class] ], @"field class mismatch" );
    NSString* fieldValue = self->_richTextField.fieldValue;
    NSString* expected =
    @"<p>Welcome to Sitecore</p>\n"
    @"<p><br />\n"
    @"</p>\n"
    @"<p><img alt=\"\" height=\"100\" width=\"100\" src=\"http://mobiledev1ua1.dk.sitecore.net:89/~/media/4F20B519D5654472B01891CB6103C667.ashx\" /></p>";
    
    NSLog( @"%@", fieldValue );
    NSLog( @"%@", expected );
    
    XCTAssertEqualObjects( fieldValue, expected, @"images are not compatible with WebView" );
}

-(void)testFullUrlsAreNotChanged_SingleQuotes
{
    {
        NSString* jsonPath = [ self->_testBundle pathForResource: @"3-RichText-FullUrl-SingleQuotes"
                                                          ofType: @"json" ];
        NSData* jsonData = [ NSData dataWithContentsOfFile: jsonPath ];
        
        self->_fieldJson = [ NSJSONSerialization JSONObjectWithData: jsonData
                                                            options: 0
                                                              error: NULL ];
        
        self->_singleQuoteRecord = [ SCFieldRecord fieldRecordWithJson: self->_fieldJson
                                                               fieldId: @"{A60ACD61-A6DB-4182-8329-C957982CEC74}"
                                                            apiSession: self->_contextEx ];
        
        self->_singleQuoteField = self->_singleQuoteRecord.field;
    }

    
    XCTAssertNotNil( self->_fieldJson, @"test data not loaded" );
    XCTAssertNotNil( self->_singleQuoteRecord, @"test data not loaded" );
    XCTAssertNotNil( self->_singleQuoteField, @"test data not loaded" );
    
    XCTAssertTrue( [ self->_singleQuoteField isMemberOfClass: [ SCRichTextField class] ], @"field class mismatch" );
    NSString* fieldValue = self->_singleQuoteField.fieldValue;
    NSString* expected =
    @"<p>Welcome to Sitecore</p>\n"
    @"<p><br />\n"
    @"</p>\n"
    @"<p><img alt='' height='100' width='100' src='http://mobiledev1ua1.dk.sitecore.net:89/~/media/4F20B519D5654472B01891CB6103C667.ashx' /></p>";
    
    NSLog( @"%@", fieldValue );
    NSLog( @"%@", expected );
    
    XCTAssertEqualObjects( fieldValue, expected, @"images are not compatible with WebView" );
}

-(void)testFullUrlsAreNotChanged
{
    {
        NSString* jsonPath = [ self->_testBundle pathForResource: @"3-RichText-FullUrl"
                                                          ofType: @"json" ];
        NSData* jsonData = [ NSData dataWithContentsOfFile: jsonPath ];
        
        self->_fieldJson = [ NSJSONSerialization JSONObjectWithData: jsonData
                                                            options: 0
                                                              error: NULL ];
        
        self->_richTextRecord = [ SCFieldRecord fieldRecordWithJson: self->_fieldJson
                                                            fieldId: @"{A60ACD61-A6DB-4182-8329-C957982CEC74}"
                                                         apiSession: self->_contextEx ];
        
        self->_richTextField = self->_richTextRecord.field;
    }
    
    
    
    XCTAssertNotNil( self->_fieldJson, @"test data not loaded" );
    XCTAssertNotNil( self->_richTextRecord, @"test data not loaded" );
    XCTAssertNotNil( self->_richTextField, @"test data not loaded" );
    
    XCTAssertTrue( [ self->_richTextField isMemberOfClass: [ SCRichTextField class] ], @"field class mismatch" );
    NSString* fieldValue = self->_richTextField.fieldValue;
    NSString* expected =
    @"<p>Welcome to Sitecore</p>\n"
    @"<p><br />\n"
    @"</p>\n"
    @"<p><img alt=\"\" height=\"100\" width=\"100\" src=\"http://mobiledev1ua1.dk.sitecore.net:89/~/media/4F20B519D5654472B01891CB6103C667.ashx\" /></p>";
    
    NSLog( @"%@", fieldValue );
    NSLog( @"%@", expected );
    
    XCTAssertEqualObjects( fieldValue, expected, @"images are not compatible with WebView" );
}

-(void)testNonLinkUrlsAreNotChanged_SingleQuotes
{
    {
        NSString* jsonPath = [ self->_testBundle pathForResource: @"4-RichText-MediaUrlOutsideLinkTag-SingleQuotes"
                                                          ofType: @"json" ];
        NSData* jsonData = [ NSData dataWithContentsOfFile: jsonPath ];
        
        self->_fieldJson = [ NSJSONSerialization JSONObjectWithData: jsonData
                                                            options: 0
                                                              error: NULL ];
        
        self->_singleQuoteRecord = [ SCFieldRecord fieldRecordWithJson: self->_fieldJson
                                                               fieldId: @"{A60ACD61-A6DB-4182-8329-C957982CEC74}"
                                                            apiSession: self->_contextEx ];
        
        self->_singleQuoteField = self->_singleQuoteRecord.field;
    }

    XCTAssertNotNil( self->_fieldJson, @"test data not loaded" );
    XCTAssertNotNil( self->_singleQuoteRecord, @"test data not loaded" );
    XCTAssertNotNil( self->_singleQuoteField, @"test data not loaded" );
    
    XCTAssertTrue( [ self->_singleQuoteField isMemberOfClass: [ SCRichTextField class] ], @"field class mismatch" );
    NSString* fieldValue = self->_singleQuoteField.fieldValue;
    NSString* expected =
    @"<p>Welcome to Sitecore</p>\r\n"
    @"<p> This is an image with media path '~/media/4F20B519D5654472B01891CB6103C667.ashx' <br />\r\n"
    @"</p>\r\n"
    @"<p><img alt='' height='100' width='100' src='   http://mobiledev1ua1.dk.sitecore.net:89/~/media/4F20B519D5654472B01891CB6103C667.ashx    ' /></p>";
    
    
    NSLog( @"%@", fieldValue );
    NSLog( @"%@", expected );
    
    XCTAssertEqualObjects( fieldValue, expected, @"images are not compatible with WebView" );
}

-(void)testNonLinkUrlsAreNotChanged
{
    {
        NSString* jsonPath = [ self->_testBundle pathForResource: @"4-RichText-MediaUrlOutsideLinkTag"
                                                          ofType: @"json" ];
        NSData* jsonData = [ NSData dataWithContentsOfFile: jsonPath ];
        
        self->_fieldJson = [ NSJSONSerialization JSONObjectWithData: jsonData
                                                            options: 0
                                                              error: NULL ];
        
        self->_richTextRecord = [ SCFieldRecord fieldRecordWithJson: self->_fieldJson
                                                            fieldId: @"{A60ACD61-A6DB-4182-8329-C957982CEC74}"
                                                         apiSession: self->_contextEx ];
        
        self->_richTextField = self->_richTextRecord.field;
    }
        
    
    XCTAssertNotNil( self->_fieldJson, @"test data not loaded" );
    XCTAssertNotNil( self->_richTextRecord, @"test data not loaded" );
    XCTAssertNotNil( self->_richTextField, @"test data not loaded" );
    
    XCTAssertTrue( [ self->_richTextField isMemberOfClass: [ SCRichTextField class] ], @"field class mismatch" );
    NSString* fieldValue = self->_richTextField.fieldValue;
    NSString* expected =
    @"<p>Welcome to Sitecore</p>\r\n"
    @"<p> This is an image with media path \"~/media/4F20B519D5654472B01891CB6103C667.ashx\" <br />\r\n"
    @"</p>\r\n"
    @"<p><img alt=\"\" height=\"100\" width=\"100\" src=\"   http://mobiledev1ua1.dk.sitecore.net:89/~/media/4F20B519D5654472B01891CB6103C667.ashx    \" /></p>";
    
    
    NSLog( @"%@", fieldValue );
    NSLog( @"%@", expected );
    
    XCTAssertEqualObjects( fieldValue, expected, @"images are not compatible with WebView" );
}

@end
