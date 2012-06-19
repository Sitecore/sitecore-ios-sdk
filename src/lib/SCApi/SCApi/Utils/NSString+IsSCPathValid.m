#import "NSString+IsSCPathValid.h"

#import "SCItemRecord.h"

@implementation NSString (IsSCPathValid)

-(BOOL)isSCPathValid
{
    NSString* rootPath_ = [ [ SCItemRecord rootItemPath ] lowercaseString ];
    return [ [ self lowercaseString ] hasPrefix: rootPath_ ];
}

@end
