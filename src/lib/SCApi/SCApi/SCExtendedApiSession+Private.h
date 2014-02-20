#import <SitecoreMobileSDK/SCExtendedApiSession.h>

@class NSNotificationCenter;
@class NSSet;
@class NSString;

@class SCDownloadMediaOptions;
@class SCItemSourcePOD;

@protocol SCItemSource;
@protocol SCItemRecordCacheRW;


@interface SCExtendedApiSession (Private)

@property (nonatomic) NSNotificationCenter* notificationCenter;

-(SCExtendedAsyncOp)privateImageLoaderForSCMediaPath:( NSString* )path_
                                              params:( SCDownloadMediaOptions * )params;

-(SCItemSourcePOD*)contextSource;

-(id<SCItemRecordCacheRW>)itemsCache;

@end
