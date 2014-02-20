#import "SCReadItemsRequest.h"

@class SCExtendedApiSession;

@interface SCReadItemsRequest (Factory)

-(SCReadItemsRequest *)itemsReaderRequestWithApiSession:( SCExtendedApiSession* )context_;

@end
