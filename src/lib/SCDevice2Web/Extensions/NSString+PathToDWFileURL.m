#import "NSString+PathToDWFileURL.h"

#import "SCDWSettings.h"

@implementation NSString (PathToDWFileURL)

-(NSString*)dwFilePath
{
    return [ [ NSString alloc ] initWithFormat: @"%@://localhost:%d%@", JDWFileSystemURLScheme
            , JDWFileSystemURLPort
            , self ];
}

@end
