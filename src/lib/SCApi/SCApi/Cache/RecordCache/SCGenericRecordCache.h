#import <Foundation/Foundation.h>

#import "SCItemRecordCacheRW.h"
#import "SCItemRecordCache.h"
#import "SCMutableItemRecordCache.h"

@protocol SCItemRecordStorageBuilder;

@interface SCGenericRecordCache : NSObject< SCItemRecordCacheRW >

-(instancetype)initWithStorageBuilder:( id<SCItemRecordStorageBuilder> )storageBuilder;

@property ( nonatomic, readonly ) id<SCItemRecordStorageBuilder> storageBuilder;

@end
