#import <Foundation/Foundation.h>
#import <JFFUtils/JFFUtils.h>

@class SCApiContext;
@class SCItemsReaderRequest;
typedef void (^CLEANUP_BLOCK)(JFFSimpleBlock);


@interface TestingRequestFactory : NSObject

+(SCItemsReaderRequest*)removeAllTestItemsFromWebAsSitecoreAdmin;
+(CLEANUP_BLOCK)doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase;

+(SCItemsReaderRequest*)removeAllTestItemsFromMasterAsSitecoreAdmin;
+(CLEANUP_BLOCK)doRemoveAllTestItemsFromMasterAsSitecoreAdminForTestCase;

+(CLEANUP_BLOCK)doRemoveAllTestItemsFromMasterForContext:( SCApiContext* )context;

+(SCApiContext*)getNewAnonymousContext;
+(SCApiContext*)getNewAdminContextWithShell;

@end
