#import "SCAbstractRequestUrlBuilder.h"
#import <Foundation/Foundation.h>

@class SCWebApiConfig;
@class SCCreateMediaItemRequest;

@interface SCCreateMediaRequestUrlBuilder : SCAbstractRequestUrlBuilder

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCCreateMediaItemRequest* )request;

@property ( nonatomic, readonly ) SCCreateMediaItemRequest* request;

@end
