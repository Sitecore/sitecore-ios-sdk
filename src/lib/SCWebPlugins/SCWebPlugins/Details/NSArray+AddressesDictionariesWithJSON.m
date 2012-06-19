#import "NSArray+AddressesDictionariesWithJSON.h"

#import "NSDictionary+ContactAddressExtensions.h"

@implementation NSArray (ContactFieldsWithComponents)

+(NSArray*)scAddressesDictionariesWithJSON:( NSString* )addressesJSON_
{
    if ( [ addressesJSON_ length ] == 0 )
        return nil;

    NSArray* jsonObject_ = nil;
    {
        NSError* error_;
        NSData* addressesJSONData_ = [ addressesJSON_ dataUsingEncoding: NSUTF8StringEncoding ];
        jsonObject_ = [ NSJSONSerialization JSONObjectWithData: addressesJSONData_
                                                       options: 0
                                                         error: &error_ ];
    }
    if ( !jsonObject_ || ![ jsonObject_ isKindOfClass: [ NSArray class ] ] )
    {
        NSLog( @"%@ can not parse arguments: %@", [ self class ], addressesJSON_ );
        return nil;
    }

    NSArray* contactFields_ = [ jsonObject_ map: ^id( NSDictionary* addressFields_ )
    {
        return [ addressFields_ map: ^id( id key_, id object_ )
        {
            return [ object_ stringByTrimmingWhitespaces ];
        } ];
    } ];

    return [ contactFields_ select: ^BOOL( NSDictionary* addressFields_ )
    {
        return [ addressFields_ count: ^BOOL( id key_, id object_ )
        {
            return [ object_ length ] > 0;
        } ] != 0;
    } ];
}

+(NSArray*)contactAddressesDictionariesWithJSON:( NSString* )addressesJSON_
{
    NSArray* result_ = [ self scAddressesDictionariesWithJSON: addressesJSON_ ];

    result_ = [ result_ map: ^id( NSDictionary* dict_ )
    {
        return [ dict_ JSONDictToAddressesDict ];
    } ];

    return result_;
}

@end
