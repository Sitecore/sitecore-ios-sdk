#import "SCInMemoryRecordStorage.h"

@class SCItemAndFields;

@interface SCInMemoryRecordStorage (UnitTesting)

@property ( nonatomic ) NSMutableDictionary* storage;
@property ( nonatomic ) BOOL shouldCheckRecordTypes;

@end
