#import "SCItemRecord.h"

@class SCItemSourcePOD;

@interface SCItemRecord (SCItemSource)

-(SCItemSourcePOD*)getSource;

@property ( nonatomic ) SCItemSourcePOD* itemSource;

@end
