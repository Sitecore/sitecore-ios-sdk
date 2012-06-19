#import "NSDictionary+ContacAddressBuilder.h"

#include <AddressBook/ABPerson.h>

@implementation NSDictionary (ContacAddressBuilder)

+(id)contactAddressWithStreet:( NSString* )street_
                         city:( NSString* )city_
                        state:( NSString* )state_
                          ZIP:( NSString* )ZIP_
                      country:( NSString* )country_
{
    return [ self dictionaryWithObjectsAndKeys:
            street_   ?:@"", (__bridge id)kABPersonAddressStreetKey
            , city_   ?:@"", (__bridge id)kABPersonAddressCityKey
            , state_  ?:@"", (__bridge id)kABPersonAddressStateKey
            , ZIP_    ?:@"", (__bridge id)kABPersonAddressZIPKey
            , country_?:@"", (__bridge id)kABPersonAddressCountryKey
            , nil ];
}

@end
