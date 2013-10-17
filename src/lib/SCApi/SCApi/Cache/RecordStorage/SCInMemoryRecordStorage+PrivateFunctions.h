#import "SCInMemoryRecordStorage.h"

@class SCItemAndFields;

@interface SCInMemoryRecordStorage (PrivateFunctions)

-(SCItemAndFields*)getStoredEntityForItemKey:( NSString* )itemKey;

@end
