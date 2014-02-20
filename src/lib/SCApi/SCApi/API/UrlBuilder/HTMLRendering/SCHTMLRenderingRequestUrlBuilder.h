#import "SCAbstractRequestUrlBuilder.h"
#import <Foundation/Foundation.h>

@class SCWebApiConfig;
@class SCGetRenderingHtmlRequest;

@interface SCHTMLRenderingRequestUrlBuilder : SCAbstractRequestUrlBuilder

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCGetRenderingHtmlRequest * )request;

@property ( nonatomic, readonly ) SCGetRenderingHtmlRequest * request;

@end
