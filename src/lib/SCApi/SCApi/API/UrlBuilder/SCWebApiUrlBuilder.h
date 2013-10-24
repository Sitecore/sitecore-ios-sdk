#import <Foundation/Foundation.h>

@class SCExtendedApiContext;
@class SCCreateItemRequest;
@class SCItemsReaderRequest;
@class SCCreateMediaItemRequest;
@class SCParams;
@class SCHTMLReaderRequest;

@interface SCWebApiUrlBuilder : NSObject

-(instancetype)initWithVersion:( NSString* )webApiVersion;

@property ( nonatomic, readonly ) NSString* webApiVersion;

-(NSString*)urlStringForMediaItemAtPath:( NSString* )itemPath
                                   host:( NSString* )host
                           resizeParams:( SCParams* )params;


@end
