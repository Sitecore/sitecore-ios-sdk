#import "SCUploadMediaItemRequest+SCItemSource.h"
#import "SCItemSourcePOD.h"

@implementation SCUploadMediaItemRequest (SCItemSource)

-(SCItemSourcePOD*)toPlainStructure
{
    return [ SCItemSourcePOD newPlainSourceFromItemSource: self ];
}

@end
