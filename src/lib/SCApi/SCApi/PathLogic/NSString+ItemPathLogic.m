#import "NSString+ItemPathLogic.h"

@implementation NSString (ItemPathLogic)

-(NSString*)parentIdOfLongId
{
    NSString* longId_ = [ self stringByDeletingLastPathComponent ];
    return [ longId_ lastPathComponent ];
}

@end
