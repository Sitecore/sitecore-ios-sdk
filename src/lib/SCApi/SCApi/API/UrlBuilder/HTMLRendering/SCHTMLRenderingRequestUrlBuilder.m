#import "SCHTMLRenderingRequestUrlBuilder.h"
#import "SCAbstractRequestUrlBuilder+Private.h"

#import "SCWebApiConfig.h"

#import "SCHTMLReaderRequest.h"

#import "SCHTMLRenderingRestArgsBuilder.h"
#import "SCItemsReaderRequest+URLWithItemsReaderRequest.h"


@implementation SCHTMLRenderingRequestUrlBuilder
{
@private
    SCHTMLReaderRequest* _request;
}

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCHTMLReaderRequest* )request
{
    self = [ super initWithHost: host
                  webApiVersion: webApiVersion
                  restApiConfig: restApiConfig
                        request: request ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_request = request;
    
    return self;
}

-(void)appendItemPath
{
    [ self appendRequestWithAction ];
}

-(void)appendRequestWithAction
{
    NSMutableString* result = [ self result ];
    
    SCWebApiConfig* gramar = [ SCWebApiConfig webApiV1Config ];
    
    NSString* htmlRenderRequest = [ NSString stringWithFormat:@"/%@/%@", gramar.actionEndpoint, gramar.renderingHtmlAction ];
    
    [ result appendString: htmlRenderRequest ];
}

-(NSArray*)getRestArgumentsList
{
    NSString* databaseParam_ = [ SCHTMLRenderingRestArgsBuilder databaseParamWithDatabase: self->_request.database ];
    NSString* languageParam_ = [ SCHTMLRenderingRestArgsBuilder languageParamWithLanguage: self->_request.language ];
    NSString* renderingIdParam_ = [ SCHTMLRenderingRestArgsBuilder renderingIdParamWithrenderingId: self->_request.renderingId ];
    NSString* itemIdParam_ = [ SCHTMLRenderingRestArgsBuilder itemIdParamWithitemId: self->_request.sourceId ];
    
    return @[ databaseParam_, languageParam_, renderingIdParam_, itemIdParam_ ];
}

-(NSString *)getRequestUrl
{
    NSAssert(self->_request.renderingId != nil, @"renderingId should not bee nil");
    NSAssert(self->_request.sourceId != nil, @"sourceId should not bee nil");
    NSAssert(self->_request.database != nil, @"sourceId should not bee nil");
    NSAssert(self->_request.language != nil, @"sourceId should not bee nil");
    NSAssert([self.host hasSymbols] != NO, @"host should contain some symbols");
    
    return [ super getRequestUrl ];
}

@end
