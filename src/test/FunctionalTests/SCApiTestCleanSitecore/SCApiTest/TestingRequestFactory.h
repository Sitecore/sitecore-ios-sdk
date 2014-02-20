#import <Foundation/Foundation.h>
#import <JFFUtils/JFFUtils.h>

@class SCApiSession;
@class SCReadItemsRequest;
typedef void (^CLEANUP_BLOCK)(JFFSimpleBlock);


@interface TestingRequestFactory : NSObject

+(SCReadItemsRequest*)removeAllTestItemsFromWebAsSitecoreAdmin;
+(CLEANUP_BLOCK)doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase;

+(SCReadItemsRequest*)removeAllTestItemsFromMasterAsSitecoreAdmin;
+(CLEANUP_BLOCK)doRemoveAllTestItemsFromMasterAsSitecoreAdminForTestCase;

+(CLEANUP_BLOCK)doRemoveAllTestItemsFromMasterForContext:( SCApiSession* )context;

+(SCApiSession*)getNewAnonymousContext;
+(SCApiSession*)getNewAdminContextWithShell;

@end
