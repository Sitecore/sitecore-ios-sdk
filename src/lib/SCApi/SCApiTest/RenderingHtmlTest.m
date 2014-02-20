#import "SCHTMLRenderingRequestUrlBuilder.h"
#import "SCApiSession.h"
#import "SCApiSession+Init.h"
#import "SCGetRenderingHtmlRequest.h"

@interface RenderingHtmlTest : XCTestCase
@end


@implementation RenderingHtmlTest
{
    SCApiSession * _context;
    SCHTMLRenderingRequestUrlBuilder* _builder;
}

-(void)setUp
{
    [ super setUp ];
    self->_builder = nil;
    self->_context = [ [SCApiSession alloc] initWithHost: @"stub.host" ];
}


-(void)testRenderingIdIsRequiredForHtmlRendering
{
    SCGetRenderingHtmlRequest *request = [[SCGetRenderingHtmlRequest alloc] init];
    request.sourceId = @"someid";
    request.language = @"lll";
    request.database = @"ddd";
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @"stub.host"
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];

//    NSString *tst = [ self->_builder getRequestUrl ];
//    NSLog(@"%@", tst);
    XCTAssertThrows
    (
       [ self->_builder getRequestUrl ],
        @"assert expected"
    );
    
}

-(void)testSourceIdIsRequiredForHtmlRendering
{
    SCGetRenderingHtmlRequest *request = [[SCGetRenderingHtmlRequest alloc] init];
    request.renderingId = @"someid";
    request.language = @"lll";
    request.database = @"ddd";
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @"stub.host"
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];
    
    XCTAssertThrows
    (
     [ self->_builder getRequestUrl ],
     @"assert expected"
     );
}

-(void)testHostIsRequiredForHtmlRendering
{
    SCGetRenderingHtmlRequest *request = [[SCGetRenderingHtmlRequest alloc] init];
    request.renderingId = @"someid";
    request.sourceId = @"someid";
    request.language = @"lll";
    request.database = @"ddd";
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @""
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];
    
    XCTAssertThrows
    (
     [ self->_builder getRequestUrl ],
     @"assert expected"
     );

}

-(void)testLanguageIsRequiredForHtmlRendering
{
    SCGetRenderingHtmlRequest *request = [[SCGetRenderingHtmlRequest alloc] init];
    request.renderingId = @"someid";
    request.sourceId = @"someid";
    request.language = nil;
    request.database = @"ddd";
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @"stub.host"
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];
    
    XCTAssertThrows
    (
     [ self->_builder getRequestUrl ],
     @"assert expected"
     );
    
}

-(void)testDatabaseIsRequiredForHtmlRendering
{
    SCGetRenderingHtmlRequest *request = [[SCGetRenderingHtmlRequest alloc] init];
    request.renderingId = @"someid";
    request.sourceId = @"someid";
    request.language = @"lll";
    request.database = nil;
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @"stub.host"
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];
    
    XCTAssertThrows
    (
     [ self->_builder getRequestUrl ],
     @"assert expected"
     );
    
}

-(void)testHtmlRenderingAutocomplete
{
    SCGetRenderingHtmlRequest *request = [[SCGetRenderingHtmlRequest alloc] init];
    request.renderingId = @"aaa";
    request.sourceId = @"bbb";
    request.language = @"lll";
    request.database = @"ddd";
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @"stub.host"
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];
    
    NSString *result = [ self->_builder getRequestUrl ];
    NSString *expected = @"stub.host/-/item/v1/-/actions/GetRenderingHtml?database=ddd&language=lll&renderingId=aaa&itemId=bbb";
    
    
    XCTAssertEqualObjects( result, expected, @"rendering HTML mismatch" );
}

@end
