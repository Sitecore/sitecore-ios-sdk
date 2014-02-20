
#import "SCApiSession+Init.h"

@interface ApiContextInitializerTest : XCTestCase
@end

@implementation ApiContextInitializerTest

-(void)testContextAndExtendedContextHaveSameApiObject
{
    SCApiSession * context = [ [SCApiSession alloc] initWithHost: @"localhost" ];
    XCTAssertNotNil( context.extendedApiSession, @"extended context must not be nil" );
    
    
    SCRemoteApi* contextApi = objc_msgSend( context, @selector( api ) );
    SCRemoteApi* extendedApi = objc_msgSend( context.extendedApiSession, @selector( api ) );
    
    XCTAssertTrue( contextApi == extendedApi, @"api object must be exactly the same" );
}

-(void)testContextAndExtendedContextHaveSameCacheObject
{
    SCApiSession * context = [ [SCApiSession alloc] initWithHost: @"localhost" ];
    XCTAssertNotNil( context.extendedApiSession, @"extended context must not be nil" );
    
    
    id<SCItemRecordCacheRW> contextCache  = objc_msgSend( context, @selector( itemsCache ) );
    id<SCItemRecordCacheRW> extendedCache = objc_msgSend( context.extendedApiSession, @selector( itemsCache ) );
    
    XCTAssertTrue( contextCache == extendedCache, @"cache object must be exactly the same" );
}

@end
