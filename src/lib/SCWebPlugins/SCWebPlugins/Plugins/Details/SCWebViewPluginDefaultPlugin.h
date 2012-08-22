#import "SCWebPlugin.h"

#import <Foundation/Foundation.h>

@interface SCWebViewPluginDefaultPlugin : NSObject < SCWebPlugin >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end
