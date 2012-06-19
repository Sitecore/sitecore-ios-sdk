#import "NSDictionary+AddressWithItem.h"

#import <SitecoreMobileSDK/SCApi.h>

#include <AddressBook/ABPerson.h>

@implementation SCImageField (SCPlacemark)

-(SCAsyncOp)placeMarkValue
{
    return [ self fieldValueReader ];
}

@end

@implementation SCField (SCPlacemark)

-(NSString*)placeMarkValue
{
    return [ self.rawValue length ] == 0 ? nil : self.rawValue;
}

@end

@implementation NSDictionary (AddressWithItem)

+(void)addField:( SCField* )field_
         toDict:( NSMutableDictionary* )dict_
            key:( id )key_
{
    if ( ![ field_ placeMarkValue ] )
        return;

    [ dict_ setObject: field_.placeMarkValue forKey: key_ ];
}

+(id)addressDictionaryWithItem:( SCItem* )item_
{
    NSMutableDictionary* result_ = [ NSMutableDictionary new ];

    NSDictionary* fields_ = [ item_ readFieldsByName ];

    NSDictionary* addressKeyByFieldName_ = [ NSDictionary dictionaryWithObjectsAndKeys:
                                            (__bridge id)kABPersonAddressStreetKey , @"Street"
                                            , (__bridge id)kABPersonAddressCityKey   , @"City"
                                            , (__bridge id)kABPersonAddressStateKey  , @"State"
                                            , (__bridge id)kABPersonAddressZIPKey    , @"ZIP"
                                            , (__bridge id)kABPersonAddressCountryKey, @"Country"
                                            , @"PlacemarkTitle"     , @"Title"
                                            , @"PlacemarkIconReader", @"Icon"
                                            , nil ];

    [ addressKeyByFieldName_ enumerateKeysAndObjectsUsingBlock: ^( id fieldName_, id addressKey_, BOOL *stop )
    {
        [ self addField: [ fields_ objectForKey: fieldName_ ]
                 toDict: result_
                    key: addressKey_ ];
    } ];

    return [ NSDictionary dictionaryWithDictionary: result_ ];
}

@end
