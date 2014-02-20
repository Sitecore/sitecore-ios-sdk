#import "SCReadItemsRequest.h"
#import "SCUploadMediaItemRequest.h"

@class SCExtendedApiSession;

@interface SCUploadMediaItemRequest (ToItemsReadRequest)

-(SCReadItemsRequest *)toItemsReadRequestWithApiSession:( SCExtendedApiSession* )apiSession_;

@end
