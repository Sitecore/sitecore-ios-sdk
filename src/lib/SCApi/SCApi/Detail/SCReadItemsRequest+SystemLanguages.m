#import "SCReadItemsRequest+SystemLanguages.h"

@implementation SCReadItemsRequest (SystemLanguages)

+(id)systemLanguagesItemsReader
{
    SCReadItemsRequest * result_ = [SCReadItemsRequest new];

    result_.request     = @"/sitecore/system/languages";
    result_.requestType = SCItemReaderRequestItemPath;
    result_.fieldNames  = [ NSSet new ];
    result_.scope       = SCItemReaderChildrenScope;

    return result_;
}

@end
