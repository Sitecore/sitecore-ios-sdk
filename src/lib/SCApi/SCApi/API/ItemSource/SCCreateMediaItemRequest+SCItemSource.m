#import "SCCreateMediaItemRequest+SCItemSource.h"
#import "SCItemSourcePOD.h"

@implementation SCCreateMediaItemRequest (SCItemSource)

-(SCItemSourcePOD*)toPlainStructure
{
    return [ SCItemSourcePOD newPlainSourceFromItemSource: self ];
}

@end
