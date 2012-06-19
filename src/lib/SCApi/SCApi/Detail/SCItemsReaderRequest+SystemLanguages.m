#import "SCItemsReaderRequest+SystemLanguages.h"

@implementation SCItemsReaderRequest (SystemLanguages)

+(id)systemLanguagesItemsReader
{
    SCItemsReaderRequest* result_ = [ SCItemsReaderRequest new ];

    result_.request     = @"/sitecore/system/languages";
    result_.requestType = SCItemReaderRequestItemPath;
    result_.fieldNames  = [ NSSet new ];
    result_.scope       = SCItemReaderChildrenScope;

    return result_;
}

@end
