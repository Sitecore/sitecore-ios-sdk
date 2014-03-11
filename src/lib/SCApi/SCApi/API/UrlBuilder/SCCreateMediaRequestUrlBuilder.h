#import "SCAbstractRequestUrlBuilder.h"
#import <Foundation/Foundation.h>

@class SCWebApiConfig;
@class SCUploadMediaItemRequest;

@interface SCCreateMediaRequestUrlBuilder : SCAbstractRequestUrlBuilder

-(instancetype)initWithHost:( NSString* )host
           mediaLibraryRoot:( NSString* )mediaLibraryRoot
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCUploadMediaItemRequest * )request;

@property ( nonatomic, readonly ) SCUploadMediaItemRequest * request;
@property ( nonatomic, readonly ) NSString* mediaLibraryRoot;

@end
