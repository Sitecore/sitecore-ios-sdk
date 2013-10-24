#import "SCCreateMediaRequestUrlBuilder.h"
#import "SCAbstractRequestUrlBuilder+Private.h"

#import "SCWebApiConfig.h"

#import "SCCreateMediaItemRequest.h"
#import "SCCreateMediaItemRequest+ToItemsReadRequest.h"


#import "SCRestArgsBuilder.h"
#import "SCItemsReaderRequest+URLWithItemsReaderRequest.h"


@implementation SCCreateMediaRequestUrlBuilder
{
@private
    SCCreateMediaItemRequest* _request;
}

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCCreateMediaItemRequest* )request
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
    NSMutableString* result = [ self result ];
    
    NSString* mediaPath = [ @"/sitecore/Media Library" stringByAppendingPathComponent: self->_request.folder ];
    NSString* encodedMediaPath = [ mediaPath stringByEncodingURLFormat ];
    
    [ result appendString: encodedMediaPath ];
}

-(NSArray*)getRestArgumentsList
{
//    NSParameterAssert( [ self->_request.itemName     hasSymbols ] );
//    NSParameterAssert( [ self->_request.itemTemplate hasSymbols ] );

    NSString* databaseParam_ = [ SCRestArgsBuilder databaseParamWithDatabase: self->_request.database ];
    NSString* languageParam_ = [ SCRestArgsBuilder languageParamWithLanguage: self->_request.language ];
    
    NSString* nameParam = [ SCRestArgsBuilder itemNameParam: self->_request.itemName ];
    NSString* templateParam = [ SCRestArgsBuilder templateParam: self->_request.itemTemplate ];
    
    NSString* fieldsParam_ = [ SCRestArgsBuilder fieldsURLParam: self->_request.fieldNames ];
    
    
    return @[ nameParam, templateParam, databaseParam_, languageParam_, fieldsParam_ ];
}

@end
