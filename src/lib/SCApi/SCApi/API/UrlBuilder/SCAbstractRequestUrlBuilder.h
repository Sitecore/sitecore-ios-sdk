#import <Foundation/Foundation.h>

@class SCWebApiConfig;

@interface SCAbstractRequestUrlBuilder : NSObject

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( id )request;

@property ( nonatomic, readonly ) NSString* host;
@property ( nonatomic, readonly ) NSString* webApiVersion;
@property ( nonatomic, readonly ) SCWebApiConfig* restConfig;
@property ( nonatomic, readonly ) id abstractRequest;

-(NSString*)getRequestUrl;

@end
