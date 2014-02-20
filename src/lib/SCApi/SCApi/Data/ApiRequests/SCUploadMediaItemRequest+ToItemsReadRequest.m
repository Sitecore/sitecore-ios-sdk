#import "SCUploadMediaItemRequest+ToItemsReadRequest.h"

#import "SCApiSession.h"
#import "SCReadItemsRequest+Factory.h"

@implementation SCUploadMediaItemRequest (ToItemsReadRequest)

-(SCReadItemsRequest *)toItemsReadRequestWithApiSession:( SCExtendedApiSession* )apiSession_
{
    SCReadItemsRequest * result_ = [SCReadItemsRequest new];
    result_ = [ result_ itemsReaderRequestWithApiSession: apiSession_ ];
    result_.fieldNames = [ self.fieldNames copy ];
    result_.request = [ @"/sitecore/Media Library" stringByAppendingPathComponent: self.folder ];
    result_.requestType = SCItemReaderRequestItemPath;

    return result_;
}

@end
