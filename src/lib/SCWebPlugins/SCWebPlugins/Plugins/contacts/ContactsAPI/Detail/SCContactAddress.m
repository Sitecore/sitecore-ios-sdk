#import "SCContactAddress.h"

#import "NSDictionary+ContactAddressExtensions.h"

#import <AddressBook/AddressBook.h>

@implementation SCContactAddress

+(id)contactAddressWithComponents:( NSDictionary* )fields_
{
    SCContactAddress* result_ = [ self new ];

    if ( result_ )
    {
        result_->_street  = [ fields_[ @"street"  ] description ];
        result_->_city    = [ fields_[ @"city"    ] description ];
        result_->_state   = [ fields_[ @"state"   ] description ];
        result_->_ZIP     = [ fields_[ @"zip"     ] description ];
        result_->_country = [ fields_[ @"country" ] description ];
    }

    return result_;
}

+(id)contactAddressWithContactValueDict:( NSDictionary* )dict_
{
    NSDictionary* jsonDict_ = [ dict_ addressesDictToJSONDict ];
    return [ self contactAddressWithComponents: jsonDict_ ];
}

-(NSDictionary*)contactApiDict
{
    return @{
    (__bridge NSString*)kABPersonAddressStreetKey  : self->_street  ?: @"",
    (__bridge NSString*)kABPersonAddressCityKey    : self->_city    ?: @"",
    (__bridge NSString*)kABPersonAddressStateKey   : self->_state   ?: @"",
    (__bridge NSString*)kABPersonAddressZIPKey     : self->_ZIP     ?: @"",
    (__bridge NSString*)kABPersonAddressCountryKey : self->_country ?: @"",
    };
}

-(NSDictionary*)toJSONDict
{
    return @{
    @"street"  : self->_street  ?: @"",
    @"city"    : self->_city    ?: @"",
    @"state"   : self->_state   ?: @"",
    @"zip"     : self->_ZIP     ?: @"",
    @"country" : self->_country ?: @"",
    };
}

@end
