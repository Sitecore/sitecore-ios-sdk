#import "NSArray+kABMultiValue.h"

@implementation NSArray (kABMultiValue)

+(id)arrayWithMultyValue:( ABMutableMultiValueRef )multyValue_
{
    CFIndex count_ = multyValue_
        ? ABMultiValueGetCount( multyValue_ )
        : 0;

    if ( 0 == count_ )
        return nil;

    NSMutableArray* result_ = [ NSMutableArray arrayWithCapacity: count_ ];

    for ( CFIndex index_ = 0; index_ < count_; ++index_ )
    {
        CFTypeRef value_ = ABMultiValueCopyValueAtIndex( multyValue_, index_ );
        if ( value_ )
        {
            [ result_ addObject: ( __bridge_transfer NSString* )value_ ];
        }
    }

    return [ result_ copy ];
}

@end
