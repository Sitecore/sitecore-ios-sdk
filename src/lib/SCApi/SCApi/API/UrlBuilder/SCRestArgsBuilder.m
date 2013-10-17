#import "SCRestArgsBuilder.h"

@implementation SCRestArgsBuilder

+(NSString*)urlEncodedValue:( NSString* )value
                 forRestKey:( NSString* )restKey
{
    NSParameterAssert( nil != restKey );
    
    NSString* encodedValue = [ value stringByEncodingURLFormat ];
    
    if ( ![ encodedValue hasSymbols ] )
    {
        return @"";
    }
    
    return [ [ NSString alloc ] initWithFormat: @"%@=%@", restKey, encodedValue ];
}

+(NSString*)databaseParamWithDatabase:( NSString* )database
{
    return [ self urlEncodedValue: database
                       forRestKey: @"sc_database" ];
}

+(NSString*)languageParamWithLanguage:( NSString* )language
{
    return [ self urlEncodedValue: language
                       forRestKey: @"sc_lang" ];
}

+(NSString*)templateParam:( NSString* )templateName
{
    return [ self urlEncodedValue: templateName
                       forRestKey: @"template" ];
}

+(NSString*)itemNameParam:( NSString* )itemName
{
    return [ self urlEncodedValue: itemName
                       forRestKey: @"name" ];
    
}

+(NSString*)fieldsURLParam:( NSSet* )fieldNames
{
    if ( nil == fieldNames )
    {
        return @"payload=content";
    }

    if ( [ fieldNames count ] == 0 )
    {
        return @"payload=min";
    }

    NSString* fieldsParams_ = [ [ fieldNames allObjects ] componentsJoinedByString: @"|" ];
    return [ [ NSString alloc ] initWithFormat: @"fields=%@", [ fieldsParams_ stringByEncodingURLFormat ] ];
}

@end
