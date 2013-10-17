#import "SCHTMLRenderingRestArgsBuilder.h"

@implementation SCHTMLRenderingRestArgsBuilder

+(NSString*)databaseParamWithDatabase:( NSString* )database
{
    return [ SCRestArgsBuilder urlEncodedValue: database
                       forRestKey: @"database" ];
}

+(NSString*)languageParamWithLanguage:( NSString* )language
{
    return [ SCRestArgsBuilder urlEncodedValue: language
                       forRestKey: @"language" ];
}

+(NSString*)renderingIdParamWithrenderingId:( NSString* )renderingId
{
    return [ SCRestArgsBuilder urlEncodedValue: renderingId
                       forRestKey: @"renderingId" ];
}

+(NSString*)itemIdParamWithitemId:( NSString* )itemId
{
    return [ SCRestArgsBuilder urlEncodedValue: itemId
                       forRestKey: @"itemId" ];
} 

@end
