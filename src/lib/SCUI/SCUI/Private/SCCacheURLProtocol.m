//#import <SCApi/Cache/SCWebCache.h>

static NSString* const protocol_schema_ = @"scmobile";

typedef void (^JFFActionsPerfomer)( JFFSimpleBlock );

@interface SCCacheURLProtocol : NSURLProtocol

//STODO remove
@property ( nonatomic ) NSData* cachedData;

@end

@implementation SCCacheURLProtocol

@synthesize cachedData;

+(NSData*)cachedDataForURL:( NSURL* )url_
{
    __block id result_ = nil;

    //STODO dead lock happen here
    safe_dispatch_sync( dispatch_get_main_queue(), ^void( void )
    {
        result_ = nil;//[ [ SCWebCache sharedWebCache ] cachedDataForURL: url_ ];
    } );

    return result_;
}

+(NSURLRequest*)canonicalRequestForRequest:( NSURLRequest* )request_
{
    return request_;
}

+(BOOL)requestIsCacheEquivalent:( NSURLRequest* )a_ toRequest:( NSURLRequest* )b_
{
    return NO;
}

-(void)startLoading
{
   NSData* responseData_ = [ [ self class ] cachedDataForURL: self.request.URL ];

   //STODO check in loader or cache the response headers, response code and etc
   NSURLResponse* response_ = [ [ NSHTTPURLResponse alloc ] initWithURL: self.request.URL
                                                             statusCode: 200
                                                            HTTPVersion: (NSString*)kCFHTTPVersion1_1
                                                           headerFields: nil ];

   [ self.client URLProtocol: self didReceiveResponse: response_ cacheStoragePolicy: NSURLCacheStorageNotAllowed ];

   [ self.client URLProtocol: self didLoadData: responseData_ ];

   [ self.client URLProtocolDidFinishLoading: self ];
}

-(void)stopLoading
{
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    //STODO hangups on mapkit
    return NO;//[ self cachedDataForURL: request_.URL ] != nil;
}

/*+(void)load
{
    BOOL result_ = [ NSURLProtocol registerClass: [ self class ] ];
    NSAssert( result_, @"should be registered" );
}*/

@end
