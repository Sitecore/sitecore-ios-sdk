#import "NSString+DefaultSitecoreLanguage.h"

@implementation NSString (DefaultSitecoreLanguage)

+(NSString*)defaultSitecoreLanguage
{
    return @"en";
}

+(NSString*)defaultSitecoreDatabase
{
    return @"web";
}

@end
