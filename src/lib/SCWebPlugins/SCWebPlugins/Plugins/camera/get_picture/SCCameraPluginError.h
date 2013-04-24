#import "SCWebPluginError.h"

@interface SCCameraPluginError : SCWebPluginError


+(SCCameraPluginError*)noRootViewControllerError;
+(SCCameraPluginError*)operationCancelledError;
+(SCCameraPluginError*)cameraSourceUnavailableError;

@end
