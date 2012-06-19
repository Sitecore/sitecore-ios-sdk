#import "NSArray+ScSelectUtils.h"

@implementation NSArray (ScSelectUtils)

-(id)scSelectWithEmailOnly
{
    NSArray* result_ = [ self map: ^id( NSString* str_ )
    {
        return [ str_ stringByTrimmingWhitespaces ];
    } ];
    return [ result_ select: ^BOOL( NSString* str_ )
    {
        return [ str_ isEmailValid ];
    } ];
}

-(id)scSelectNotEmptyStrings
{
    NSArray* result_ = [ self map: ^id( NSString* str_ )
    {
        return [ str_ stringByTrimmingWhitespaces ];
    } ];
    return [ result_ select: ^BOOL( NSString* str_ )
    {
        return [ str_ length ] != 0;
    } ];
}

@end
