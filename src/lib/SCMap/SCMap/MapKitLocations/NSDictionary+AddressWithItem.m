#import "NSDictionary+AddressWithItem.h"

#import <SitecoreMobileSDK/SCApi.h>

#include <AddressBook/ABPerson.h>

@implementation SCImageField (SCPlacemark)

-(SCAsyncOp)placeMarkValue
{
    return [ self readFieldValueOperation ];
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
    NSString* placeMark = [ field_ placeMarkValue ];
    if ( nil == placeMark )
    {
        return;
    }

    dict_[ key_ ] = placeMark;
}

+(id)addressDictionaryWithItem:( SCItem* )item_
{
    NSMutableDictionary* result_ = [ NSMutableDictionary new ];

    NSDictionary* fields_;

    if ( [ item_ respondsToSelector:@selector(readFieldsByName) ])
    {
        fields_ = [ item_ performSelector:@selector(readFieldsByName) ];
    }
    else
    {
        NSAssert( YES, @"Unexpected item type");
    }
    
    NSDictionary* addressKeyByFieldName_ = @{
        @"Street"  : (__bridge id)kABPersonAddressStreetKey ,
        @"City"    : (__bridge id)kABPersonAddressCityKey   ,
        @"State"   : (__bridge id)kABPersonAddressStateKey  ,
        @"ZIP"     : (__bridge id)kABPersonAddressZIPKey    ,
        @"Country" : (__bridge id)kABPersonAddressCountryKey,
        @"Title"   : @"PlacemarkTitle",
        @"Icon"    : @"PlacemarkIconReader",
    };

    [ addressKeyByFieldName_ enumerateKeysAndObjectsUsingBlock: ^( id fieldName_, id addressKey_, BOOL *stop )
    {
        [ self addField: fields_[ fieldName_ ]
                 toDict: result_
                    key: addressKey_ ];
    } ];

    return [ result_ copy ];
}

@end
