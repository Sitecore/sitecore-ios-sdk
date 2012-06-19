#import "SCPluginsURLProtocol.h"

@implementation SCPluginsURLProtocol

+(NSURLRequest*)canonicalRequestForRequest:( NSURLRequest* )request_
{
    return request_;
}

+(BOOL)requestIsCacheEquivalent:( NSURLRequest* )a_ toRequest:( NSURLRequest* )b_
{
    return NO;
}

-(void)sendFinishLoading
{
    NSURLResponse* response_ = [ [ NSHTTPURLResponse alloc ] initWithURL: self.request.URL
                                                              statusCode: 200
                                                             HTTPVersion: (NSString*)kCFHTTPVersion1_1
                                                            headerFields: nil ];

    [ self.client URLProtocol: self
           didReceiveResponse: response_
           cacheStoragePolicy: NSURLCacheStorageNotAllowed ];

    [ self.client URLProtocol: self didLoadData: [ NSData data ] ];

    [ self.client URLProtocolDidFinishLoading: self ];
}

-(void)startLoading
{
    NSDictionary* components_ = [ self.request.URL queryComponents ];
    NSString* log_message_ = [ [ components_ objectForKey: @"log" ] noThrowObjectAtIndex: 0 ];
    NSLog( @"WebView: %@", log_message_ );

    [ self sendFinishLoading ];
}

-(void)stopLoading
{
}

@end
