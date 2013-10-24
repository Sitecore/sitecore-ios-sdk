#import "SCAbstractRequestUrlBuilder.h"
#import <Foundation/Foundation.h>


@class SCWebApiConfig;
@class SCItemsReaderRequest;


@interface SCReaderRequestUrlBuilder : SCAbstractRequestUrlBuilder

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCItemsReaderRequest* )request;

@end
