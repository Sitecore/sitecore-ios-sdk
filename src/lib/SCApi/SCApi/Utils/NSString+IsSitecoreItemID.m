#import "NSString+IsSitecoreItemID.h"

@implementation NSString (IsSitecoreItemID)

-(BOOL)isSitecoreItemID
{
    BOOL result_ = [ self length ] != 0;

    if ( result_ )
    {
        NSString* timeStringPredicate_ = @"\\{[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}\\}";
        NSPredicate* uuidSearch_ = [ NSPredicate predicateWithFormat: @"SELF MATCHES %@", timeStringPredicate_ ];
        result_ = [ uuidSearch_ evaluateWithObject: self ];
    }

    return result_;
}

@end
