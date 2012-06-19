#import "NSData+EditFieldsBodyWithFieldsDict.h"

@implementation NSData (EditFieldsBodyWithFieldsDict)

+(id)editFieldsBodyWithFieldsDict:( NSDictionary* )dict_
                              url:( NSURL* )url_
{
    NSString* xPathParams_ = [ dict_ stringFromQueryComponents ];
    NSData* result_ = [ xPathParams_ dataUsingEncoding: NSUTF8StringEncoding ];
    result_ = result_ ?: [ self new ];
    return result_;
}

@end
