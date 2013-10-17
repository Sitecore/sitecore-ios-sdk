#import <Foundation/Foundation.h>

@interface SCRestArgsBuilder : NSObject

+(NSString*)urlEncodedValue:( NSString* )value
                 forRestKey:( NSString* )restKey;

+(NSString*)databaseParamWithDatabase:( NSString* )database_;
+(NSString*)languageParamWithLanguage:( NSString* )language_;

+(NSString*)templateParam:( NSString* )templateName;
+(NSString*)itemNameParam:( NSString* )itemName;

+(NSString*)fieldsURLParam:( NSSet* )fieldNames;

@end

