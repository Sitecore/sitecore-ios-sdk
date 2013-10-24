#import <Foundation/Foundation.h>

@class SCWebApiConfig;

@interface SCActionsUrlBuilder : NSObject

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig;

@property ( nonatomic, readonly ) NSString      * host         ;
@property ( nonatomic, readonly ) NSString      * webApiVersion;
@property ( nonatomic, readonly ) SCWebApiConfig* restApiConfig;

-(NSString*)urlToCheckCredentialsForSite:( NSString* )site;
-(NSString*)urlToGetPublicKey;

@end
