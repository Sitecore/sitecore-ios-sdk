#import "SCHTMLReaderRequest+Factory.h"
#import "SCExtendedApiContext.h"

@implementation SCHTMLReaderRequest (Factory)

-(SCHTMLReaderRequest*)htmlRenderingReaderRequestWithApiContext:( SCExtendedApiContext* )context_
{
    SCHTMLReaderRequest* result_ = [ self copy ];
    
    result_.language        = result_.language ?: context_.defaultLanguage;
    result_.database        = result_.database ?: context_.defaultDatabase;
    result_.site            = result_.site     ?: context_.defaultSite    ;
    
    return result_;
}

@end
