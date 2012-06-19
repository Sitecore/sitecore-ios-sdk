#import <Foundation/Foundation.h>

#include <MacTypes.h>

extern NSString *const SCWebSocketServerPortChanged;

@interface SCWebSocketServer : NSObject

+(void)start;
+(UInt16)port;

@end
