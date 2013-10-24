
#import "SCApiContext+Init.h"

@interface ApiContextInitializerTest : SenTestCase
@end

@implementation ApiContextInitializerTest

-(void)testContextAndExtendedContextHaveSameApiObject
{
    SCApiContext* context = [ [ SCApiContext alloc ] initWithHost: @"localhost" ];
    STAssertNotNil( context.extendedApiContext, @"extended context must not be nil" );
    
    
    SCRemoteApi* contextApi = objc_msgSend( context, @selector( api ) );
    SCRemoteApi* extendedApi = objc_msgSend( context.extendedApiContext, @selector( api ) );
    
    STAssertTrue( contextApi == extendedApi, @"api object must be exactly the same" );
}

-(void)testContextAndExtendedContextHaveSameCacheObject
{
    SCApiContext* context = [ [ SCApiContext alloc ] initWithHost: @"localhost" ];
    STAssertNotNil( context.extendedApiContext, @"extended context must not be nil" );
    
    
    id<SCItemRecordCacheRW> contextCache  = objc_msgSend( context, @selector( itemsCache ) );
    id<SCItemRecordCacheRW> extendedCache = objc_msgSend( context.extendedApiContext, @selector( itemsCache ) );
    
    STAssertTrue( contextCache == extendedCache, @"cache object must be exactly the same" );
}

@end
