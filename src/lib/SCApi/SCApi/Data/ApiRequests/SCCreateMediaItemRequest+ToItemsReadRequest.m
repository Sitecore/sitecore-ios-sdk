#import "SCCreateMediaItemRequest+ToItemsReadRequest.h"

#import "SCApiContext.h"
#import "SCItemsReaderRequest+Factory.h"

@implementation SCCreateMediaItemRequest (ToItemsReadRequest)

-(SCItemsReaderRequest*)toItemsReadRequestWithApiContext:( SCApiContext* )apiContext_
{
    SCItemsReaderRequest* result_ = [ SCItemsReaderRequest new ];
    result_ = [ result_ itemsReaderRequestWithApiContext: apiContext_ ];
    result_.fieldNames = [ self.fieldNames copy ];
    result_.request = [ @"/sitecore/Media Library" stringByAppendingPathComponent: self.folder ];
    result_.requestType = SCItemReaderRequestItemPath;

    return result_;
}

@end
