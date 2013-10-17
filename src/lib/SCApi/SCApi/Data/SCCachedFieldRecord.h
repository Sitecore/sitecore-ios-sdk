#import "SCFieldRecord.h"

@class SCItemSourcePOD;

@interface SCCachedFieldRecord : SCFieldRecord

@property ( nonatomic ) SCItemSourcePOD* itemSource;
@property ( nonatomic ) NSString* itemId;

@end
