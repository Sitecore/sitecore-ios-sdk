#import <XCTest/XCTest.h>

#import "SCUploadMediaItemRequest+ToItemsReadRequest.h"

@interface UploadRequestTest : XCTestCase
@end


@implementation UploadRequestTest
{
@private
    SCApiSession        * _legacySession;
    SCExtendedApiSession* _apiSession   ;
    
    SCUploadMediaItemRequest* _request;
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

@end
