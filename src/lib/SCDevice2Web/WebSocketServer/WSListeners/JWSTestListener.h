#import "JDevice2WebSocketProtocol.h"
#import "WebSocket.h"

#import <Foundation/Foundation.h>

@interface JWSTestListener : WebSocket < JDevice2WebSocketProtocol >
@end
