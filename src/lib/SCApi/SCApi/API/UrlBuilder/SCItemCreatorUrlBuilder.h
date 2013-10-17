#import "SCReaderRequestUrlBuilder.h"
#import <Foundation/Foundation.h>

@class SCCreateItemRequest;

@interface SCItemCreatorUrlBuilder : SCReaderRequestUrlBuilder

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCCreateItemRequest* )request;

@end
