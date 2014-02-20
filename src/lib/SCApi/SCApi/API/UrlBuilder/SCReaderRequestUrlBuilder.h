#import "SCAbstractRequestUrlBuilder.h"
#import <Foundation/Foundation.h>


@class SCWebApiConfig;
@class SCReadItemsRequest;


@interface SCReaderRequestUrlBuilder : SCAbstractRequestUrlBuilder

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCReadItemsRequest * )request;

@end
