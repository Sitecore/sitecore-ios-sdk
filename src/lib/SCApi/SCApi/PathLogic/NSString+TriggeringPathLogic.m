#import "NSString+TriggeringPathLogic.h"

@implementation NSString (TriggeringPathLogic)

-(NSString *)triggeringPathWithHost:(NSString *)host_
{
    NSString *postfix = @"";
    if ( [ self hasSymbols ] )
    {
        postfix = @".aspx";
    }

    return [ NSString stringWithFormat:@"%@/%@%@", host_, self, postfix ];
}

@end
