#import "SCItemsReaderRequest.h"
#import "SCCreateMediaItemRequest.h"

@class SCApiContext;

@interface SCCreateMediaItemRequest (ToItemsReadRequest)

-(SCItemsReaderRequest*)toItemsReadRequestWithApiContext:( SCApiContext* )apiContext_;

@end
