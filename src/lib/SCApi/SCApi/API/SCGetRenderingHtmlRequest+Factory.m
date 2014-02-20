#import "SCGetRenderingHtmlRequest+Factory.h"
#import "SCExtendedApiSession.h"

@implementation SCGetRenderingHtmlRequest (Factory)

-(SCGetRenderingHtmlRequest *)htmlRenderingReaderRequestWithApiSession:( SCExtendedApiSession* )context_
{
    SCGetRenderingHtmlRequest * result_ = [ self copy ];
    
    result_.language        = result_.language ?: context_.defaultLanguage;
    result_.database        = result_.database ?: context_.defaultDatabase;
    result_.site            = result_.site     ?: context_.defaultSite    ;
    
    return result_;
}

@end
