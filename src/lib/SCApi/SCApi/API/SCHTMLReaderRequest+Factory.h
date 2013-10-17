#import "SCHTMLReaderRequest.h"

@class SCExtendedApiContext;

@interface SCHTMLReaderRequest (Factory)

-(SCHTMLReaderRequest*)htmlRenderingReaderRequestWithApiContext:( SCExtendedApiContext* )context_;

@end
