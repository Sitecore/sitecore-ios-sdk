#import "SCReadItemsRequest+SCItemSource.h"

#import "SCItemSourcePOD.h"

@implementation SCReadItemsRequest (SCItemSource)

-(SCItemSourcePOD*)toPlainStructure
{
    return self.itemSource;
}

@end
