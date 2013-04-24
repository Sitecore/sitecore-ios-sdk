#import "SCDataCache.h"
#import <Foundation/Foundation.h>

@protocol JFFCacheDB;

@interface SCCacheDBAdaptor : NSObject < SCDataCache >

@property ( nonatomic ) id< JFFCacheDB >  jffCacheDB;

@end