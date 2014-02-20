#import <XCTest/XCTest.h>

@interface ActionsUrlBuilderTest : XCTestCase

@end

@implementation ActionsUrlBuilderTest
{
    SCActionsUrlBuilder* _mobileDevBuilder;
    SCActionsUrlBuilder* _noHttpBuilder;
    
    SCWebApiConfig* _restGrammar;
}

-(void)setUp
{
    [ super setUp ];

    self->_restGrammar      = [ SCWebApiConfig webApiV1Config ];
    self->_mobileDevBuilder =
    [ [ SCActionsUrlBuilder alloc ] initWithHost: @"https://mobiledev1ua1.dk.sitecore.net:89"
                                   webApiVersion: @"v1"
                                   restApiConfig: self->_restGrammar ];
    
    self->_noHttpBuilder =
    [ [ SCActionsUrlBuilder alloc ] initWithHost: @"mobiledev1ua1.dk.sitecore.net:89"
                                   webApiVersion: @"v1"
                                   restApiConfig: self->_restGrammar ];
}

-(void)tearDown
{
    self->_restGrammar      = nil;
    self->_mobileDevBuilder = nil;
    
    [ super tearDown ];
}

-(void)testActionBuilderRejectsInit
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    XCTAssertThrows
    (
       [ [SCActionsUrlBuilder alloc ] init ],
       @"assert expected"
    );
#pragma clang diagnostic pop    
    
    XCTAssertNotNil( self->_mobileDevBuilder, @"init failed" );
    XCTAssertNotNil( self->_mobileDevBuilder, @"grammar init failed" );
}

-(void)testActionBuilderRejectsNil
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    XCTAssertThrows
    (
     [ [ SCActionsUrlBuilder alloc ] initWithHost: nil
                                    webApiVersion: @"v1"
                                    restApiConfig: self->_restGrammar ],
     @"assert expected"
     );
    
    XCTAssertThrows
    (
     [ [ SCActionsUrlBuilder alloc ] initWithHost: @"ololo.net"
                                    webApiVersion: nil
                                    restApiConfig: self->_restGrammar ],
     @"assert expected"
     );
    
    
    XCTAssertThrows
    (
     [ [ SCActionsUrlBuilder alloc ] initWithHost: @"0_o"
                                    webApiVersion: @"v1"
                                    restApiConfig: nil ],
     @"assert expected"
     );
#pragma clang diagnostic pop        
}

-(void)testInitArgsAreSavedCorrectly
{
    XCTAssertEqualObjects( self->_mobileDevBuilder.host, @"https://mobiledev1ua1.dk.sitecore.net:89", @"host mismatch" );
    XCTAssertEqualObjects( self->_mobileDevBuilder.webApiVersion, @"v1", @"version mismatch" );
    
    XCTAssertTrue( self->_mobileDevBuilder.restApiConfig == self->_restGrammar, @"rest config mismatch" );
}

-(void)testPublicKey
{
    NSString* result = [ self->_mobileDevBuilder urlToGetPublicKey ];
    NSString* expected = @"https://mobiledev1ua1.dk.sitecore.net:89/-/item/v1/-/actions/GetPublicKey";
    
    XCTAssertEqualObjects(result, expected, @"public key url mismatch" );
}

-(void)testPublicKey_Autocomplete
{
    NSString* result = [ self->_noHttpBuilder urlToGetPublicKey ];
    NSString* expected = @"http://mobiledev1ua1.dk.sitecore.net:89/-/item/v1/-/actions/GetPublicKey";
    
    XCTAssertEqualObjects(result, expected, @"public key url mismatch" );
}

-(void)testAuthForWebsite
{
    NSString* result = [ self->_mobileDevBuilder urlToCheckCredentialsForSite: nil ];
    NSString* expected = @"https://mobiledev1ua1.dk.sitecore.net:89/-/item/v1/-/actions/authenticate";
    
    XCTAssertEqualObjects(result, expected, @"auth url mismatch" );
}

-(void)testAuthForWebsite_Autocomplete
{
    NSString* result = [ self->_noHttpBuilder urlToCheckCredentialsForSite: nil ];
    NSString* expected = @"http://mobiledev1ua1.dk.sitecore.net:89/-/item/v1/-/actions/authenticate";
    
    XCTAssertEqualObjects(result, expected, @"auth url mismatch" );
}


-(void)testAuthForShellSite
{
    NSString* result = [ self->_mobileDevBuilder urlToCheckCredentialsForSite: @"/sitecore/shell" ];
    NSString* expected = @"https://mobiledev1ua1.dk.sitecore.net:89/-/item/v1/sitecore/shell/-/actions/authenticate";
    
    XCTAssertEqualObjects(result, expected, @"auth url mismatch" );
}

-(void)testAuthForShellSite_Autocomplet
{
    NSString* result = [ self->_noHttpBuilder urlToCheckCredentialsForSite: @"/sitecore/shell" ];
    NSString* expected = @"http://mobiledev1ua1.dk.sitecore.net:89/-/item/v1/sitecore/shell/-/actions/authenticate";
    
    XCTAssertEqualObjects(result, expected, @"auth url mismatch" );
}

@end
