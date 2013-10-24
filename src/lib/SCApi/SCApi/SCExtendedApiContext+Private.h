#import <SitecoreMobileSDK/SCExtendedApiContext.h>

@class NSNotificationCenter;
@class NSSet;
@class NSString;

@class SCFieldImageParams;
@class SCItemSourcePOD;

@protocol SCItemSource;
@protocol SCItemRecordCacheRW;


@interface SCExtendedApiContext (Private)

@property (nonatomic) NSNotificationCenter* notificationCenter;

-(SCExtendedAsyncOp)privateImageLoaderForSCMediaPath:( NSString* )path_
                                              params:( SCFieldImageParams* )params;

-(SCItemSourcePOD*)contextSource;

-(id<SCItemRecordCacheRW>)itemsCache;

@end
