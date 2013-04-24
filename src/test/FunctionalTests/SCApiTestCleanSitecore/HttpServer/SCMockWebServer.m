#import "SCMockWebServer.h"

static NSMutableSet* printedUrls;

@interface SCMockWebServer ()

-(void)sendFinishLoadingWithData:( NSData* )data_;

@end

@implementation SCMockWebServer

-(id)initWithRequest:( NSURLRequest* )request_
      cachedResponse:( NSCachedURLResponse* )cachedResponse_
              client:( id< NSURLProtocolClient > )client_
{
    self = [ super initWithRequest: request_
                    cachedResponse: cachedResponse_
                            client: client_ ];

    if ( self )
    {
    }

    return self;
}

+(NSURLRequest*)canonicalRequestForRequest:( NSURLRequest* )request_
{
    return request_;
}

+(BOOL)requestIsCacheEquivalent:( NSURLRequest* )a_ toRequest:( NSURLRequest* )b_
{
    return NO;
}

+(NSDictionary*)responseByRequest
{
    static NSDictionary* responseByRequest;
    if ( responseByRequest )
        return responseByRequest;

    responseByRequest = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
//   @"1", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=p%7Cc"
//   , @"2", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cc&&sc_itemid=%7BAEE0704D-5C40-4209-AB6B-16B6A24DD629%7D&&fields=Title%7CImage"
//   , @"3", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=p%7Cc&&payload=1"
//   , @"4", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products?scope=s&&payload=1"
//   , @"5", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content?scope=s&&payload=1"
//   , @"6", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam?scope=s&&payload=1"
//   , @"7", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=c&&sc_itemid=%7B812D47A0-4ED8-4E55-B2F7-9D64FBBF391D%7D&&payload=1"
//   , @"8", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=p%7Cc"
//   , @"9", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cc&&sc_itemid=%7BAEE0704D%2D5C40%2D4209%2DAB6B%2D16B6A24DD629%7D&&fields=Title%7CImage"
//   , @"10", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&fields=Title%7CImage"
//   , @"11", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=c"
//   , @"12", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=s"
//   , @"13", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=p%7Cs&&payload=1"
//   , @"14", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=c&&payload=1"    
//   , @"15", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=s&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&fields=Title%7CImage"
//   , @"16", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=p%7Cs%7Cc&&payload=1"                     
//   , @"17", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=c&&sc_itemid=%7B0E1BB3F7%2D7C3A%2D4DD9%2D8041%2D50B68689E6A2%7D&&fields=Title%7CImage"
//   , @"18", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products?scope=c&&payload=1"
//   , @"19", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products?scope=c"
//   , @"20", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cs&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&fields=Title%7CImage"
//   , @"21", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=p%7Cs"
//   , @"22", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=s%7Cc&&payload=1"
//   , @"23", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=p%7Cc&&payload=1"
//   , @"24", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cc&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&fields=Title%7CImage" 
//   , @"25", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=s%7Cc"
//   , @"26", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=p&&payload=1"
//   , @"27", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=p"
//   , @"28", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=c&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&fields=Title%7CImage"
//   , @"29", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cs%7Cc&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&fields=Title%7CImage"
//   , @"30", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=p%7Cs%7Cc"
//   , @"31", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=s%7Cc&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&fields=Title%7CImage"
//   , @"32", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses/normal?scope=s&&payload=1"
//   , @"33", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=s&&payload=1"
//   , @"34", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products?scope=s"
//   , @"35", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cs&&sc_itemid=%7BAEE0704D%2D5C40%2D4209%2DAB6B%2D16B6A24DD629%7D&&fields=Title%7CImage"
//   , @"36", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=p%7Cs&&payload=1"
//   , @"37", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=c&&sc_itemid=%7B0DE95AE4%2D41AB%2D4D01%2D9EB0%2D67441B7C2450%7D&&payload=1"
//   , @"38", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=s&&sc_itemid=%7B0E1BB3F7%2D7C3A%2D4DD9%2D8041%2D50B68689E6A2%7D"
//   , @"39", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=s&&sc_itemid=%7BEAAFB568%2D3143%2D4250%2DAF07%2D177F147CA951%7D"
//   , @"40", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/accessories/flash/r1?scope=s&&payload=1"
//   , @"41", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=c&&sc_itemid=%7B812D47A0%2D4ED8%2D4E55%2DB2F7%2D9D64FBBF391D%7D&&payload=1"
//   , @"42", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=s"
//   , @"43", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=s&&sc_itemid=%7B0E1BB3F7%2D7C3A%2D4DD9%2D8041%2D50B68689E6A2%7D&&fields=Image%7CTitle"
//   , @"44", @"http://mobilesdk.sc-demo.net/-/webapi/v1?query=%2Fsitecore%2Fcontent%2Fnicam%2Fchild%3A%3A%2A%5B%40%40templatename%3D%27Site%20Section%27%5D&&fields=Title%7CTab%20Icon"
//   , @"45", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=s&&sc_itemid=%7B0E1BB3F7%2D7C3A%2D4DD9%2D8041%2D50B68689E6A2%7D&&fields=Title%7CImage"
//   , @"46", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=p%7Cs"
//   , @"47", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=s%7Cc&&sc_itemid=%7B0E1BB3F7%2D7C3A%2D4DD9%2D8041%2D50B68689E6A2%7D&&fields=Title%7CImage"
//   , @"48", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products?scope=s%7Cc&&payload=1"
//   , @"49", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products?scope=s%7Cc"
//   , @"50", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cs%7Cc&&sc_itemid=%7BAEE0704D%2D5C40%2D4209%2DAB6B%2D16B6A24DD629%7D&&fields=Title%7CImage"
//   , @"51", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=p%7Cs%7Cc&&payload=1"
//   , @"52", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=p%7Cs%7Cc"
//   , @"53", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p&&sc_itemid=%7BAEE0704D%2D5C40%2D4209%2DAB6B%2D16B6A24DD629%7D&&fields=Title%7CImage"
//   , @"54", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=p"
//   , @"55", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/products/lenses?scope=p&&payload=1"
//   , @"56", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cc&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&pageSize=3&page=0"
//   , @"57", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/?scope=c&&fields=Title%7CTab%20Icon&pageSize=2&page=0"
//   , @"58", @"http://mobilesdk.sc-demo.net/-/webapi/v1?query=%2Fsitecore%2Fcontent%2FNicam%2Fchild%3A%3A%2A%5B%40%40templatename%3D%27Site%20Section%27%5D&&fields=Title%7CTab%20Icon&pageSize=3&page=0"
//   , @"59", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cs&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&payload=1&pageSize=2&page=0"
//   , @"60", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=s%7Cc&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&pageSize=2&page=0"
//   , @"61", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cs%7Cc&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&payload=1&pageSize=2&page=2"
//   , @"62", @"http://mobilesdk.sc-demo.net/-/webapi/v1?scope=p%7Cs%7Cc&&sc_itemid=%7BA1FF0BEE%2DAE21%2D4BAF%2DBECD%2D8029FC89601A%7D&&payload=1&pageSize=2&page=0"
//   , @"63", @"http://mobilesdk.sc-demo.net/-/webapi/v1/sitecore/content/nicam/?scope=c&&fields=Title%7CTab%20Icon&pageSize=2&page=2"
   nil ];
    return responseByRequest;
}

-(void)startLoading
{
    NSString* urlString_ = [ self.request.URL absoluteString ];
    NSString* fileName_  = [ [ [ self class ] responseByRequest ] objectForKey: urlString_ ];

    NSString* path_ = [ [ NSBundle mainBundle ] pathForResource: fileName_ ofType: @"json" ];
    NSData* data_ = [ NSData dataWithContentsOfFile: path_ ];

    [ self sendFinishLoadingWithData: data_ ];
}

-(void)stopLoading
{
}

+(BOOL)hasPrintedUrl:( NSString* )urlString_
{
    return [ printedUrls containsObject: urlString_ ];
}

+(void)addPrintedUrl:( NSString* )urlString_
{
    if ( !printedUrls )
    {
        printedUrls = [ NSMutableSet new ];
    }
    [ printedUrls addObject: urlString_ ];
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    NSString* urlString_ = [ request_.URL absoluteString ];
    if ( [ [ self responseByRequest ] objectForKey: urlString_ ] )
    {
        return YES;
    }
    else
    {
        if ( ![ self hasPrintedUrl: urlString_ ] )
        {
            NSLog( @"also can be cached: %@", urlString_ );
            [ self addPrintedUrl: urlString_ ];
        }
    }
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

+(void)load
{
    BOOL result_ = [ NSURLProtocol registerClass: [ self class ] ];
    NSAssert( result_, @"should be registered" );
}

@end
