#import <XCTest/XCTest.h>

#import "SCCreateMediaRequestUrlBuilder.h"
#import "SCUploadMediaItemRequest+ToItemsReadRequest.h"

static NSString* const MEDIA_ROOT_FOR_URL_BUILDER = @"/fotki/kompromat";

@interface UploadRequestTest : XCTestCase
@end


@implementation UploadRequestTest
{
@private
    SCApiSession        * _legacySession;
    SCExtendedApiSession* _apiSession   ;
    
    SCUploadMediaItemRequest* _request;
    SCCreateMediaRequestUrlBuilder* _defaultUrlBuilder;
    SCCreateMediaRequestUrlBuilder* _otherPathUrlBuilder;
}


-(void)setUp
{
    [ super setUp ];
    
    self->_legacySession = [ [ SCApiSession alloc] initWithHost: @"localhost" ];
    self->_apiSession = self->_legacySession.extendedApiSession;
    
    SCUploadMediaItemRequest* request = [ SCUploadMediaItemRequest new ];
    {
        request.itemName = @"Grumpy Cat";
        request.itemTemplate = @"/system/media/unversioned/jpeg";
        request.fileName = @"Grumpy.jpg";
        request.contentType = @"image/jpeg";
        
        request.folder = @"/cats/XYZ";
    }
    self->_request = request;
    
    
    self->_defaultUrlBuilder =
    [ [ SCCreateMediaRequestUrlBuilder alloc ] initWithHost: @"localhost"
                                           mediaLibraryRoot: [ SCApiSession defaultMediaLibraryPath ]
                                              webApiVersion: @"v1"
                                              restApiConfig: [ SCWebApiConfig webApiV1Config ]
                                                    request: self->_request ];


    self->_otherPathUrlBuilder =
    [ [ SCCreateMediaRequestUrlBuilder alloc ] initWithHost: @"localhost"
                                           mediaLibraryRoot: MEDIA_ROOT_FOR_URL_BUILDER
                                              webApiVersion: @"v1"
                                              restApiConfig: [ SCWebApiConfig webApiV1Config ]
                                                    request: self->_request ];

}

-(void)tearDown
{
    self->_legacySession = nil;
    self->_apiSession    = nil;
    
    [ super tearDown ];
}

-(void)testMediaPathIsPrependedToFolder
{
    SCReadItemsRequest* result = [ self->_request toItemsReadRequestWithApiSession: self->_apiSession ];
 
    XCTAssertTrue( result.requestType == SCReadItemRequestItemPath, @"request type mismatch" );
    XCTAssertEqualObjects( result.request, @"/sitecore/media library/cats/xyz", @"request string mismatch" );
}

-(void)testChangedMediaPathIsPrependedToFolder
{
    self->_apiSession.mediaLibraryPath = @"/ololo/trololo/медия паз";
    SCReadItemsRequest* result = [ self->_request toItemsReadRequestWithApiSession: self->_apiSession ];
    
    XCTAssertTrue( result.requestType == SCReadItemRequestItemPath, @"request type mismatch" );
    XCTAssertEqualObjects( result.request, @"/ololo/trololo/медия паз/cats/xyz", @"request string mismatch" );
}

-(void)testCreateMediaUrlBuilderPrependsDefaultMediaRoot
{
    NSString* result = [ self->_defaultUrlBuilder getRequestUrl ];
    NSString* expected = @"localhost/-/item/v1%2Fsitecore%2Fmedia%20library%2Fcats%2Fxyz?name=Grumpy%20Cat&template=%2Fsystem%2Fmedia%2Funversioned%2Fjpeg&payload=content";
    
    XCTAssertEqualObjects( result, expected, @"incorrect request" );
}

-(void)testCreateMediaUrlBuilderPrependsChangedMediaRoot
{
    NSString* result = [ self->_otherPathUrlBuilder getRequestUrl ];
    NSString* expected = @"localhost/-/item/v1%2Ffotki%2Fkompromat%2Fcats%2Fxyz?name=Grumpy%20Cat&template=%2Fsystem%2Fmedia%2Funversioned%2Fjpeg&payload=content";
    
    XCTAssertEqualObjects( result, expected, @"incorrect request" );
}

@end
