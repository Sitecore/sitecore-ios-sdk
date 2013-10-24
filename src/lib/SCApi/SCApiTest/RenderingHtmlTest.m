#import "SCHTMLRenderingRequestUrlBuilder.h"
#import "SCApiContext.h"
#import "SCApiContext+Init.h"
#import "SCHTMLReaderRequest.h"

@interface RenderingHtmlTest : SenTestCase
@end


@implementation RenderingHtmlTest
{
    SCApiContext      * _context;
    SCHTMLRenderingRequestUrlBuilder* _builder;
}

-(void)setUp
{
    [ super setUp ];
    self->_builder = nil;
    self->_context = [ [ SCApiContext alloc ] initWithHost: @"stub.host" ];
}


-(void)testRenderingIdIsRequiredForHtmlRendering
{
    SCHTMLReaderRequest *request = [[SCHTMLReaderRequest alloc] init];
    request.sourceId = @"someid";
    request.language = @"lll";
    request.database = @"ddd";
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @"stub.host"
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];

//    NSString *tst = [ self->_builder getRequestUrl ];
//    NSLog(@"%@", tst);
    STAssertThrows
    (
       [ self->_builder getRequestUrl ],
        @"assert expected"
    );
    
}

-(void)testSourceIdIsRequiredForHtmlRendering
{
    SCHTMLReaderRequest *request = [[SCHTMLReaderRequest alloc] init];
    request.renderingId = @"someid";
    request.language = @"lll";
    request.database = @"ddd";
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @"stub.host"
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];
    
    STAssertThrows
    (
     [ self->_builder getRequestUrl ],
     @"assert expected"
     );
}

-(void)testHostIsRequiredForHtmlRendering
{
    SCHTMLReaderRequest *request = [[SCHTMLReaderRequest alloc] init];
    request.renderingId = @"someid";
    request.sourceId = @"someid";
    request.language = @"lll";
    request.database = @"ddd";
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @""
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];
    
    STAssertThrows
    (
     [ self->_builder getRequestUrl ],
     @"assert expected"
     );

}

-(void)testLanguageIsRequiredForHtmlRendering
{
    SCHTMLReaderRequest *request = [[SCHTMLReaderRequest alloc] init];
    request.renderingId = @"someid";
    request.sourceId = @"someid";
    request.language = nil;
    request.database = @"ddd";
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @"stub.host"
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];
    
    STAssertThrows
    (
     [ self->_builder getRequestUrl ],
     @"assert expected"
     );
    
}

-(void)testDatabaseIsRequiredForHtmlRendering
{
    SCHTMLReaderRequest *request = [[SCHTMLReaderRequest alloc] init];
    request.renderingId = @"someid";
    request.sourceId = @"someid";
    request.language = @"lll";
    request.database = nil;
    
    self->_builder = [ [ SCHTMLRenderingRequestUrlBuilder alloc ] initWithHost: @"stub.host"
                                                                 webApiVersion: @"v1"
                                                                 restApiConfig:[ SCWebApiConfig webApiV1Config ]
                                                                       request:request ];
    
    STAssertThrows
    (
     [ self->_builder getRequestUrl ],
     @"assert expected"
     );
    
}

-(void)testHtmlRenderingAutocomplete
{
    SCHTMLReaderRequest *request = [[SCHTMLReaderRequest alloc] init];
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
    
    
    STAssertEqualObjects( result, expected, @"rendering HTML mismatch" );
}

@end
