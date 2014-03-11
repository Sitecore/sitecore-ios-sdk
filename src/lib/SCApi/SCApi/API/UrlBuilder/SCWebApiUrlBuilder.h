#import <Foundation/Foundation.h>

@class SCExtendedApiSession;
@class SCCreateItemRequest;
@class SCReadItemsRequest;
@class SCUploadMediaItemRequest;
@class SCParams;
@class SCGetRenderingHtmlRequest;

@interface SCWebApiUrlBuilder : NSObject

/**
 A designated initializer.
 
 @param webApiVersion It is used to avoid data duplication and initialize other URL builders
*/
-(instancetype)initWithVersion:( NSString* )webApiVersion;
@property ( nonatomic, readonly ) NSString* webApiVersion;

-(NSString*)urlStringForMediaItemAtPath:( NSString* )itemPath
                                   host:( NSString* )host
                              mediaRoot:( NSString* )mediaRoot
                           resizeParams:( SCParams* )params;


@end
