#import "SCReaderRequestUrlBuilder.h"
#import "SCAbstractRequestUrlBuilder+Private.h"

#import "SCRestArgsBuilder.h"
#import "SCItemsReaderRequest.h"
#import "SCWebApiConfig.h"
#import "SCItemsReaderRequest+URLWithItemsReaderRequest.h"

@implementation SCReaderRequestUrlBuilder
{
@private
    SCItemsReaderRequest* _request      ;
}

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCItemsReaderRequest* )request
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
    [ result appendString: [ self->_request pathURLParam ] ];
}

-(NSArray*)getRestArgumentsList
{
    NSString* databaseParam_ = [ SCRestArgsBuilder databaseParamWithDatabase: self->_request.database ];
    NSString* languageParam_ = [ SCRestArgsBuilder languageParamWithLanguage: self->_request.language ];
    
    NSString* scopeParam_  = [ self->_request scopeURLParam  ];
    NSString* queryParam_  = [ self->_request queryURLParam  ];
    NSString* itemIdParam_ = [ self->_request itemIdURLParam ];
    NSString* fieldsParam_ = [ self->_request fieldsURLParam ];
    NSString* pagesParam_  = [ self->_request pagesURLParam  ];
    NSString* versionParam_ = [ self->_request itemVersionURLParam ];
    
    NSArray* params_ =
    @[ scopeParam_
       , queryParam_
       , itemIdParam_
       , fieldsParam_
       , pagesParam_
       , languageParam_
       , databaseParam_
       , versionParam_
    ];

    return params_;
}

@end
