#import "SCReadItemsRequest+SystemLanguages.h"

@implementation SCReadItemsRequest (SystemLanguages)

+(id)systemLanguagesItemsReader
{
    SCReadItemsRequest * result_ = [SCReadItemsRequest new];

    result_.request     = @"/sitecore/system/languages";
    result_.requestType = SCReadItemRequestItemPath;
    result_.fieldNames  = [ NSSet new ];
    result_.scope       = SCReadItemChildrenScope;

    return result_;
}

@end
