#import "SCAbstractRequestUrlBuilder.h"
#import <Foundation/Foundation.h>

@class SCWebApiConfig;
@class SCHTMLReaderRequest;

@interface SCHTMLRenderingRequestUrlBuilder : SCAbstractRequestUrlBuilder

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCHTMLReaderRequest* )request;

@property ( nonatomic, readonly ) SCHTMLReaderRequest* request;

@end
