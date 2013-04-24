#import <Foundation/Foundation.h>

@protocol SCDataCache;
@protocol JFFCacheDB;
@class JFFCaches;

@interface SCSrvResponseCachesFactory : NSObject

+(JFFCaches*)sharedSCCaches;
+(id< SCDataCache >)sharedSrvResponseCache;
+(id< JFFCacheDB >)mobileSdkRawCache;

@end
