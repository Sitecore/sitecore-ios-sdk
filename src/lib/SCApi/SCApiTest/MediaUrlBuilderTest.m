#import "SCWebApiUrlBuilder.h"
#import "SCFieldImageParams.h"

@interface MediaUrlBuilderTest : SenTestCase
@end


@implementation MediaUrlBuilderTest

-(void)testMediaUrlRejectsNilPath
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    STAssertThrows
    (
         [ builder  urlStringForMediaItemAtPath: nil
                                           host: @"http://mobiledev1ua1.dk.sitecore.net"
                                   resizeParams: [ SCFieldImageParams new ] ],
         @"assert expected"
    );
    
    
}

-(void)testMediaUrlRejectsEmptyPath
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    STAssertThrows
    (
         [ builder  urlStringForMediaItemAtPath: @""
                                           host: @"http://mobiledev1ua1.dk.sitecore.net"
                                   resizeParams: [ SCFieldImageParams new ] ],
         @"assert expected"
    );
    
    
    STAssertThrows
    (
     [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library"
                                       host: @"http://mobiledev1ua1.dk.sitecore.net"
                               resizeParams: [ SCFieldImageParams new ] ],
     @"assert expected"
    );
}


-(void)testMediaUrlRejectsEmptyHost
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    STAssertThrows
    (
     [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                       host: nil
                               resizeParams: [ SCFieldImageParams new ] ],
     @"assert expected"
     );
    
    
    STAssertThrows
    (
     [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                       host: @""
                               resizeParams: [ SCFieldImageParams new ] ],
     @"assert expected"
     );
}

-(void)testMediaUrlAllowsNilParams
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    STAssertNoThrow
    (
     [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                       host: @"test.host"
                               resizeParams: nil ],
     @"assert fired"
     );
}


-(void)testMediaUrlDoesNotUseWebApi
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    NSString* result =
    [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                      host: @"test.host"
                              resizeParams: nil ];

    NSString* expected = @"http://test.host/~/media/1.png.ashx";
    STAssertEqualObjects( result, expected, @"media url mismatch" );
}

-(void)testMediaUrlDoesNotAutocompleteTwice
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    NSString* result = nil;
    NSString* expected = nil;
    
    
    {
        result =
        [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                          host: @"http://test.host"
                                  resizeParams: nil ];

        expected = @"http://test.host/~/media/1.png.ashx";
        STAssertEqualObjects( result, expected, @"media url mismatch" );
    }

    {
        result =
        [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                          host: @"https://test.host"
                                  resizeParams: [ SCFieldImageParams new ] ];
        
        expected = @"https://test.host/~/media/1.png.ashx";
        STAssertEqualObjects( result, expected, @"media url mismatch" );
    }
}

-(void)testMediaUrlSupportsResizing
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    NSString* result = nil;
    NSString* expected = nil;
    
    
    {
        SCFieldImageParams* resize = [ SCFieldImageParams new ];
        resize.height = 480;
        resize.width  = 640;
        
        result =
        [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                          host: @"https://test.host"
                                  resizeParams: resize ];
        
        expected = @"https://test.host/~/media/1.png.ashx?w=640&h=480";
        STAssertEqualObjects( result, expected, @"media url mismatch" );
    }
}

@end
