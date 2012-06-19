#import "SCContactAddress.h"

#import "NSDictionary+ContactAddressExtensions.h"

#import <AddressBook/AddressBook.h>

@interface NSDictionary (SCContactAddress)
@end

@implementation NSDictionary (SCContactAddress)

-(NSString*)stringObjectForKey:( id )key_
{
    id result_ = [ self objectForKey: key_ ];
    if ( !result_ )
        return nil;

    return [ NSString stringWithFormat: @"%@", result_ ];
}

@end

@implementation SCContactAddress

@synthesize street  = _street;
@synthesize city    = _city;
@synthesize state   = _state;
@synthesize ZIP     = _ZIP;
@synthesize country = _country;

+(id)contactAddressWithComponents:( NSDictionary* )fields_
{
    SCContactAddress* result_ = [ self new ];

    result_.street  = [ fields_ stringObjectForKey: @"street"  ];
    result_.city    = [ fields_ stringObjectForKey: @"city"    ];
    result_.state   = [ fields_ stringObjectForKey: @"state"   ];
    result_.ZIP     = [ fields_ stringObjectForKey: @"zip"     ];
    result_.country = [ fields_ stringObjectForKey: @"country" ];

    return result_;
}

+(id)contactAddressWithContactValueDict:( NSDictionary* )dict_
{
    NSDictionary* jsonDict_ = [ dict_ addressesDictToJSONDict ];
    return [ self contactAddressWithComponents: jsonDict_ ];
}

-(NSDictionary*)contactApiDict
{
    return [ NSDictionary dictionaryWithObjectsAndKeys:
            self.street   , kABPersonAddressStreetKey
            , self.city   , kABPersonAddressCityKey
            , self.state  , kABPersonAddressStateKey
            , self.ZIP    , kABPersonAddressZIPKey
            , self.country, kABPersonAddressCountryKey
            , nil ];
}

-(NSDictionary*)toJSONDict
{
    return [ NSDictionary dictionaryWithObjectsAndKeys:
            self.street   , @"street"
            , self.city   , @"city"
            , self.state  , @"state"
            , self.ZIP    , @"zip"
            , self.country, @"country"
            , nil ];
}

@end
