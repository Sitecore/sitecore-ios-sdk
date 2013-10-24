#import "SCRestArgsBuilder.h"

@interface SCHTMLRenderingRestArgsBuilder : NSObject

+(NSString*)renderingIdParamWithrenderingId:( NSString* )renderingId;
+(NSString*)itemIdParamWithitemId:( NSString* )itemId;
+(NSString*)databaseParamWithDatabase:( NSString* )database;
+(NSString*)languageParamWithLanguage:( NSString* )language;

@end
