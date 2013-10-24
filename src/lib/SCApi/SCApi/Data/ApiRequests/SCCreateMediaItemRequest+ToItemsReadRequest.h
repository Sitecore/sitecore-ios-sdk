#import "SCItemsReaderRequest.h"
#import "SCCreateMediaItemRequest.h"

@class SCExtendedApiContext;

@interface SCCreateMediaItemRequest (ToItemsReadRequest)

-(SCItemsReaderRequest*)toItemsReadRequestWithApiContext:( SCExtendedApiContext* )apiContext_;

@end
