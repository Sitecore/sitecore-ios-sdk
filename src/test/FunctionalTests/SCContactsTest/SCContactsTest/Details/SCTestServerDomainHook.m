
#import "NSURLRequest+isTestDomain.h"

@interface SCTestServerDomainHook : NSURLProtocol
@end

@implementation SCTestServerDomainHook

+(NSURLRequest*)canonicalRequestForRequest:( NSURLRequest* )request_
{
    return request_;
}

+(BOOL)requestIsCacheEquivalent:( NSURLRequest* )a_ toRequest:( NSURLRequest* )b_
{
    return NO;
}

-(void)sendFinishLoadingWithData:( NSData* )data_
{
    NSURLResponse* response_ = [ [ NSHTTPURLResponse alloc ] initWithURL: self.request.URL
                                                              statusCode: 200
                                                             HTTPVersion: (__bridge NSString*)kCFHTTPVersion1_1
                                                            headerFields: nil ];

    [ self.client URLProtocol: self
           didReceiveResponse: response_
           cacheStoragePolicy: NSURLCacheStorageNotAllowed ];

    [ self.client URLProtocol: self didLoadData: data_ ];

    [ self.client URLProtocolDidFinishLoading: self ];
}

-(void)startLoading
{
    NSString* path_ = [ [ NSBundle mainBundle ] pathForResource: @"test" ofType: @"html" ];
    NSData* data_ = [ NSData dataWithContentsOfFile: path_ ];
    [ self sendFinishLoadingWithData: data_ ];
}

-(void)stopLoading
{
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_ isTestDomain ];
}

+(void)load
{
    BOOL result_ = [ NSURLProtocol registerClass: [ self class ] ];
    NSAssert( result_, @"should be registered" );
}

@end
