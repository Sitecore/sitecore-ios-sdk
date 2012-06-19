#import "NSURL+IsDWFilePathURL.h"

#import "SCDWSettings.h"

@implementation NSURL (IsDWFilePathURL)

-(BOOL)isDWFilePathURL
{
    return [ [ self port ] longValue ] == JDWFileSystemURLPort
        && [ [ self scheme ] isEqualToString: JDWFileSystemURLScheme ];
}

@end
