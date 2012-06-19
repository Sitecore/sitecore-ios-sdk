#import "NSDictionary+SCItemFieldsWithURLParam.h"

@implementation NSDictionary (SCItemFieldsWithURLParam)

+(id)scItemFieldsWithURLParam:( NSString* )params_
{
    if ( [ params_ length ] == 0 )
        return nil;

    NSData* fieldsData_ = [ params_ dataUsingEncoding: NSUTF8StringEncoding ];
    NSDictionary* fieldsDict_ = [ NSJSONSerialization JSONObjectWithData: fieldsData_
                                                                 options: 0
                                                                   error: nil ];
    return [ fieldsDict_ isKindOfClass: [ NSDictionary class ] ]
        ? fieldsDict_
        : nil;
}

@end
