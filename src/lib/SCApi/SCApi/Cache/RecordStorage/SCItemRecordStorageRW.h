#import "SCItemRecordStorage.h"
#import "SCMutableItemRecordStorage.h"

#import <Foundation/Foundation.h>

@protocol SCItemRecordStorageRW < SCItemRecordStorage, SCMutableItemRecordStorage >
@end
