#import "NSDictionary+ContactAddressExtensions.h"

#import <SCUtils/SCAsyncOpUtils.h>
#import <JFFNetwork/JFFNetwork.h>

#import <AddressBook/AddressBook.h>

//STODO remove
SCAsyncOp imageReaderForURLString( NSString* urlString_
                                  , NSTimeInterval cacheLifeTime_ );

@implementation NSDictionary (ContactAddressExtensions)

+(NSDictionary*)mapJSONToAddresses
{
    return @{
    @"street"  : ( __bridge id )kABPersonAddressStreetKey ,
    @"city"    : ( __bridge id )kABPersonAddressCityKey   ,
    @"state"   : ( __bridge id )kABPersonAddressStateKey  ,
    @"zip"     : ( __bridge id )kABPersonAddressZIPKey    ,
    @"country" : ( __bridge id )kABPersonAddressCountryKey,
    @"title"   : @"PlacemarkTitle",
    @"icon"    : @"PlacemarkIconReader",
    };
}

+(NSDictionary*)mapAddressesToJSON
{
    return @{
    ( __bridge id )kABPersonAddressStreetKey  : @"street" ,
    ( __bridge id )kABPersonAddressCityKey    : @"city"   ,
    ( __bridge id )kABPersonAddressStateKey   : @"state"  ,
    ( __bridge id )kABPersonAddressZIPKey     : @"zip"    ,
    ( __bridge id )kABPersonAddressCountryKey : @"country",
    };
}

-(NSDictionary*)addressesDictToJSONDict
{
    NSDictionary* mapAddressesToJSON_ = [ NSDictionary mapAddressesToJSON ];
    return [ self mapKey: ^id( id key_, id object_ )
    {
        return mapAddressesToJSON_[ key_ ];
    } ];
}

-(NSDictionary*)JSONDictToAddressesDict
{
    NSDictionary* mapJSONToAddresses_ = [ NSDictionary mapJSONToAddresses ];

    NSDictionary* result_ = [ self mapKey: ^id( id key_, id object_ )
    {
        return mapJSONToAddresses_[ key_ ];
    } ];

    return [ result_ map: ^id( id key_, id object_ )
    {
        if ( [ @"PlacemarkIconReader" isEqualToString: key_ ] )
        {
            static NSTimeInterval oneDayInSeconds_ = 60*60*24.;
            return imageReaderForURLString( object_, oneDayInSeconds_ );
        }
        return object_;
    } ];
}

@end
