#import "SCUploadMediaItemRequest+ToItemsReadRequest.h"

#import "SCExtendedApiSession.h"
#import "SCReadItemsRequest+Factory.h"



@implementation SCUploadMediaItemRequest (ToItemsReadRequest)

-(NSLocale*)posixLocale
{
    static NSLocale* result = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^void()
    {
        result = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    });
    
    return result;
}

-(SCReadItemsRequest *)toItemsReadRequestWithApiSession:( SCExtendedApiSession* )apiSession_
{
    SCReadItemsRequest * result_ = [SCReadItemsRequest new];
    result_ = [ result_ itemsReaderRequestWithApiSession: apiSession_ ];
    result_.fieldNames = [ self.fieldNames copy ];
    
    NSString* mediaPath = apiSession_.mediaLibraryPath;
    NSParameterAssert( nil != mediaPath );
    
    
    
    result_.request = [ mediaPath stringByAppendingPathComponent: self.folder ];
    result_.request = [ result_.request lowercaseStringWithLocale: [ self posixLocale ] ];
    
    result_.requestType = SCReadItemRequestItemPath;

    return result_;
}

@end

