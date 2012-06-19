#import "JDevice2WebSocketProtocol.h"
#import "WebSocket.h"

#import <Foundation/Foundation.h>

@interface JWSLogListener : WebSocket < JDevice2WebSocketProtocol >
@end
