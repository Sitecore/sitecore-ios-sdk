#import "SCWebApiUrlBuilder.h"
#import "SCDownloadMediaOptions.h"

@interface MediaUrlBuilderTest : XCTestCase
@end

static NSString* const LEGACY_MEDIA_ROOT = @"/sitecore/media library";
static NSString* const DEFAULT_MEDIA_ROOT = @"/SITECORE/MEDIA LIBRARY";

@implementation MediaUrlBuilderTest

-(void)testMediaUrlRejectsNilPath
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    XCTAssertThrows
    (
         [ builder  urlStringForMediaItemAtPath: nil
                                           host: @"http://mobiledev1ua1.dk.sitecore.net"
                                      mediaRoot: LEGACY_MEDIA_ROOT
                                   resizeParams: [SCDownloadMediaOptions new] ],
         @"assert expected"
    );
    
    
}

-(void)testMediaUrlRejectsEmptyPath
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    XCTAssertThrows
    (
         [ builder  urlStringForMediaItemAtPath: @""
                                           host: @"http://mobiledev1ua1.dk.sitecore.net"
                                      mediaRoot: LEGACY_MEDIA_ROOT
                                   resizeParams: [SCDownloadMediaOptions new] ],
         @"assert expected"
    );
    
    
    XCTAssertThrows
    (
     [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library"
                                       host: @"http://mobiledev1ua1.dk.sitecore.net"
                                  mediaRoot: LEGACY_MEDIA_ROOT
                               resizeParams: [SCDownloadMediaOptions new] ],
     @"assert expected"
    );
}


-(void)testMediaUrlRejectsEmptyHost
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    XCTAssertThrows
    (
     [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                       host: nil
                                  mediaRoot: LEGACY_MEDIA_ROOT
                               resizeParams: [SCDownloadMediaOptions new] ],
     @"assert expected"
     );
    
    
    XCTAssertThrows
    (
     [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                       host: @""
                                  mediaRoot: LEGACY_MEDIA_ROOT
                               resizeParams: [SCDownloadMediaOptions new] ],
     @"assert expected"
     );
}

-(void)testMediaUrlAllowsNilParams
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    
    XCTAssertNoThrow
    (
     [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                       host: @"test.host"
                                  mediaRoot: LEGACY_MEDIA_ROOT
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
                                 mediaRoot: LEGACY_MEDIA_ROOT
                              resizeParams: nil ];

    NSString* expected = @"http://test.host/~/media/1.png.ashx";
    XCTAssertEqualObjects( result, expected, @"media url mismatch" );
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
                                     mediaRoot: LEGACY_MEDIA_ROOT
                                  resizeParams: nil ];

        expected = @"http://test.host/~/media/1.png.ashx";
        XCTAssertEqualObjects( result, expected, @"media url mismatch" );
    }

    {
        result =
        [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                          host: @"https://test.host"
                                     mediaRoot: LEGACY_MEDIA_ROOT
                                  resizeParams: [SCDownloadMediaOptions new] ];
        
        expected = @"https://test.host/~/media/1.png.ashx";
        XCTAssertEqualObjects( result, expected, @"media url mismatch" );
    }
}

-(void)testMediaUrlSupportsResizing
{
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    NSString* result = nil;
    NSString* expected = nil;
    
    
    {
        SCDownloadMediaOptions * resize = [SCDownloadMediaOptions new];
        resize.height = 480;
        resize.width  = 640;
        
        result =
        [ builder  urlStringForMediaItemAtPath: @"/sitecore/media library/1.png"
                                          host: @"https://test.host"
                                     mediaRoot: LEGACY_MEDIA_ROOT
                                  resizeParams: resize ];
        
        expected = @"https://test.host/~/media/1.png.ashx?w=640&h=480";
        XCTAssertEqualObjects( result, expected, @"media url mismatch" );
    }
}

-(void)testMediaUrlCanHaveDifferentRoot
{
    NSString* mediaRoot = @"/mediaXYZ";
    
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    NSString* result = nil;
    NSString* expected = nil;
    
    
    {
        SCDownloadMediaOptions * resize = [ SCDownloadMediaOptions new ];
        resize.height = 480;
        resize.width  = 640;
        
        result =
        [ builder  urlStringForMediaItemAtPath: @"/mediaXYZ/1.png"
                                          host: @"https://test.host"
                                     mediaRoot: mediaRoot
                                  resizeParams: resize ];
        
        expected = @"https://test.host/~/media/1.png.ashx?w=640&h=480";
        XCTAssertEqualObjects( result, expected, @"media url mismatch" );
    }
}

-(void)testMediaRootIsCaseInsensitive
{
    NSString* mediaRoot = @"/MEDIAxyz";
    
    SCWebApiUrlBuilder* builder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: @"v1" ];
    NSString* result = nil;
    NSString* expected = nil;
    
    
    {
        SCDownloadMediaOptions * resize = [ SCDownloadMediaOptions new ];
        resize.height = 480;
        resize.width  = 640;
        
        result =
        [ builder  urlStringForMediaItemAtPath: @"/mediaXYZ/1.png"
                                          host: @"https://test.host"
                                     mediaRoot: mediaRoot
                                  resizeParams: resize ];
        
        expected = @"https://test.host/~/media/1.png.ashx?w=640&h=480";
        XCTAssertEqualObjects( result, expected, @"media url mismatch" );
    }
}

@end
