#import "NSURL+URLWithItemsReaderRequest.h"

#import "SCEditItemsRequest.h"
#import "SCCreateItemRequest.h"
#import "SCReadItemsRequest.h"
#import "SCUploadMediaItemRequest.h"

#import "SCReadItemsRequest+Factory.h"
#import "SCUploadMediaItemRequest+ToItemsReadRequest.h"
#import "SCApiSession.h"


#import "SCReadItemsRequest+URLWithItemsReaderRequest.h"
#import "NSString+URLWithItemsReaderRequest.h"


static NSString* const apiVersion_ = @"v1";

@implementation NSURL (URLWithItemsReaderRequest)



+(id)URLToTriggerAction:( NSString* )itemPath_
              paramName:( NSString* )paramName_
             paramValue:( NSString* )paramValue_
{
    static NSString* const urlFormat_ = @"%@?%@=%@";
    
    NSString* requestString_ = [ [ NSString alloc ] initWithFormat: urlFormat_
                                , itemPath_
                                , paramName_
                                , paramValue_
                                ];
    requestString_ = [ requestString_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    return [ [ NSURL alloc ] initWithString: requestString_ ];
}


@end
