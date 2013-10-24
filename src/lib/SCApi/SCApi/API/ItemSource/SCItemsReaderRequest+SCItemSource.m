#import "SCItemsReaderRequest+SCItemSource.h"

#import "SCItemSourcePOD.h"

@implementation SCItemsReaderRequest (SCItemSource)

-(SCItemSourcePOD*)toPlainStructure
{
    return self.itemSource;
}

@end
