#import <Foundation/Foundation.h>

@class SCApiContext;
@class SCCreateItemRequest;
@class SCItemsReaderRequest;
@class SCCreateMediaItemRequest;

@interface NSURL (URLWithItemsReaderRequest)

+(id)URLWithItemsReaderRequest:( SCItemsReaderRequest* )request_
                          host:( NSString* )host_;

+(id)URLToEditItemsWithRequest:( SCItemsReaderRequest* )request_
                          host:( NSString* )host_;

+(id)URLToCreateItemWithRequest:( SCCreateItemRequest* )createItemRequest_
                           host:( NSString* )host_;

+(id)URLToCreateMediaItemWithRequest:( SCCreateMediaItemRequest* )createItemRequest_
                                host:( NSString* )host_
                          apiContext:( SCApiContext* )apiContext_;

+(id)URLToGetSecureKeyForHost:( NSString* )host_;

+(id)URLToGetRenderingHTMLLoaderForRenderingId:( NSString* )rendereringId_
                                      sourceId:( NSString* )sourceId_
                                          host:( NSString* )host_
                                    apiContext:( SCApiContext* )apiContext_;

+(id)URLToTriggerAction:( NSString* )itemPath_
              paramName:( NSString* )paramName_
             paramValue:( NSString* )paramValue_;

@end
