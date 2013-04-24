#import "SCContactsPluginError.h"

@implementation SCContactsPluginError

+(SCContactsPluginError*)noRootViewControllerError
{
    SCContactsPluginError* error_ = [ [ SCContactsPluginError alloc ] initWithDescription: @"Root view controller not found"
                                                                                     code: 1 ];
    return error_;
}

+(SCContactsPluginError*)operationCancelledError
{
    SCContactsPluginError* error_ = [ [ SCContactsPluginError alloc ] initWithDescription: @"Operation cancelled"
                                                                                     code: 2 ];
    return error_;
}

+(SCContactsPluginError*)invalidContactsJsonError
{
    SCContactsPluginError* error_ = [ [ SCContactsPluginError alloc ] initWithDescription: @"Invalid Contacts JSON"
                                                                                     code: 3 ];
    return error_;
}


@end
