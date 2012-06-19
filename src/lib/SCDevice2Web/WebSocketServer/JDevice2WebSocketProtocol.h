#import <Foundation/Foundation.h>

@class HTTPMessage;
@class GCDAsyncSocket;

@protocol JDevice2WebSocketProtocol < NSObject >

@required
-(id)initWithRequest:( HTTPMessage* )request_ socket:( GCDAsyncSocket* )socket_;

+(NSString*)requestURLPath;

@end
