#import "NSString+PathToDWFileURL.h"

#import "SCDWSettings.h"

@implementation NSString (PathToDWFileURL)

-(NSString*)dwFilePath
{
    return [ NSString stringWithFormat: @"%@://localhost:%d%@", JDWFileSystemURLScheme
            , JDWFileSystemURLPort
            , self ];
}

@end
