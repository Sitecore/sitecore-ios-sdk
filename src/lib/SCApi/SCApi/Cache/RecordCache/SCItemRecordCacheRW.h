#import "SCItemRecordCache.h"
#import "SCMutableItemRecordCache.h"
#import <Foundation/Foundation.h>

@protocol SCItemRecordCacheRW <SCItemRecordCache, SCMutableItemRecordCache>
@end
