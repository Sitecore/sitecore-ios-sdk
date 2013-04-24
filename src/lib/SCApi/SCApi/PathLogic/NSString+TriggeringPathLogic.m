#import "NSString+TriggeringPathLogic.h"

@implementation NSString (TriggeringPathLogic)

-(NSString *)triggeringPathWithHost:(NSString *)host_
{
    NSArray *hostComponents_ = [ host_ componentsSeparatedByString:@"/"];
    NSString *baseHost_ = [ hostComponents_ objectAtIndex:0 ];
    NSString *postfix = @"";
    if ( [ self hasSymbols ] )
    {
        postfix = @".aspx";
    }

    return [ NSString stringWithFormat:@"http://%@/%@%@", baseHost_, self, postfix ];
}

@end
