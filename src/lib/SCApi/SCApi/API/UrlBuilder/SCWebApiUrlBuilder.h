#import <Foundation/Foundation.h>

@class SCExtendedApiSession;
@class SCCreateItemRequest;
@class SCReadItemsRequest;
@class SCUploadMediaItemRequest;
@class SCParams;
@class SCGetRenderingHtmlRequest;

@interface SCWebApiUrlBuilder : NSObject

-(instancetype)initWithVersion:( NSString* )webApiVersion;

@property ( nonatomic, readonly ) NSString* webApiVersion;

-(NSString*)urlStringForMediaItemAtPath:( NSString* )itemPath
                                   host:( NSString* )host
                           resizeParams:( SCParams* )params;


@end
