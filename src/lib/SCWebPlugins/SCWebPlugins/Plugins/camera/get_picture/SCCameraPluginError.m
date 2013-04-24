#import "SCCameraPluginError.h"

@implementation SCCameraPluginError

+(SCCameraPluginError*)noRootViewControllerError
{
    SCCameraPluginError* error_ = [ [ SCCameraPluginError alloc ] initWithDescription: @"Root view controller not found"
                                                                                     code: 1 ];
    return error_;
}

+(SCCameraPluginError*)operationCancelledError
{
    SCCameraPluginError* error_ = [ [ SCCameraPluginError alloc ] initWithDescription: @"Operation cancelled"
                                                                                     code: 2 ];
    return error_;
}

+(SCCameraPluginError*)cameraSourceUnavailableError
{
    SCCameraPluginError* error_ = [ [ SCCameraPluginError alloc ] initWithDescription: @"Camera source type is not available"
                                                                                 code: 3 ];
    return error_;
}

@end
