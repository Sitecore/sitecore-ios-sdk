#import "SCWebPluginError.h"

@interface SCContactsPluginError : SCWebPluginError

+(SCContactsPluginError*)noRootViewControllerError;
+(SCContactsPluginError*)operationCancelledError;
+(SCContactsPluginError*)invalidContactsJsonError;

@end
