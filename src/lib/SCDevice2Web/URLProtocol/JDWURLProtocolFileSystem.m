#import "NSURL+IsDWFilePathURL.h"

@interface JDWURLProtocolFileSystem : NSURLProtocol
@end

@implementation JDWURLProtocolFileSystem

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
                                                             HTTPVersion: (NSString*)kCFHTTPVersion1_1
                                                            headerFields: nil ];

    [ self.client URLProtocol: self
           didReceiveResponse: response_
           cacheStoragePolicy: NSURLCacheStorageNotAllowed ];

    [ self.client URLProtocol: self didLoadData: data_ ];

    [ self.client URLProtocolDidFinishLoading: self ];
}

-(void)sendNotFoundError
{
    NSURLResponse* response_ = [ [ NSHTTPURLResponse alloc ] initWithURL: self.request.URL
                                                              statusCode: 404
                                                             HTTPVersion: (NSString*)kCFHTTPVersion1_1
                                                            headerFields: nil ];

    [ self.client URLProtocol: self
           didReceiveResponse: response_
           cacheStoragePolicy: NSURLCacheStorageNotAllowed ];

    [ self.client URLProtocolDidFinishLoading: self ];
}

-(void)sendFinishLoadingWithString:( NSString* )string_
{
    NSData* data_ = [ string_ dataUsingEncoding: NSUTF8StringEncoding ];
    [ self sendFinishLoadingWithData: data_ ];
}

-(void)startLoading
{
    NSString* path_ = [ self.request.URL.path stringByDecodingURLFormat ];
    NSData* data_ = [ NSData dataWithContentsOfFile: path_ ];

    if ( nil == data_ )
    {
        [ self sendNotFoundError ];
        return;
    }

    [ self sendFinishLoadingWithData: data_ ];
}

-(void)stopLoading
{
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL isDWFilePathURL ];
}

+(void)load
{
    BOOL result_ = [ NSURLProtocol registerClass: [ self class ] ];
    NSAssert( result_, @"should be registered" );
}

@end
