#import "SCRichTextField.h"

#import "NSString+URLWithItemsReaderRequest.h"
#import "SCExtendedApiSession.h"


@implementation SCRichTextField

@dynamic fieldValue;

-(id)createFieldValue
{
    NSString* rawValue = self.rawValue;

    static NSString* const SITECORE_MEDIA = @"~/media";
    NSString* host = [ self.apiSession.host scHostWithURLScheme ];
    
    NSRange entireString = { 0, rawValue.length };

    #define WHITESPACE @"[ ]*?"
    NSString* imgTagPatternBase =
    @"(?:"
        @"("
            @"<img"  // opening tag
            @"[^>]*?" // all but close tag symbol
            @"src"   // "src" attribute
            WHITESPACE  // whitespaces
            @"="     // value separator
            WHITESPACE  // whitespaces
            @"[\"|']"    // single or double quote
            WHITESPACE  // whitespaces
        @")"
    @")";
    
    NSString* imgTagPattern = [ NSString stringWithFormat:@"%@(%@)", imgTagPatternBase, SITECORE_MEDIA ];
    
    
//    0 <img alt="" height="100" width="100" src=" ~/media
//    1 <img alt="" height="100" width="100" src="
//    2 ~/media
    NSString* replacementPattern = [ NSString stringWithFormat: @"$1%@/$2", host ];
    
    NSError* regexConstructorError = nil;
    NSRegularExpression* transform =
    [[ NSRegularExpression  alloc ] initWithPattern: imgTagPattern
                                            options: NSRegularExpressionCaseInsensitive
                                              error: &regexConstructorError ];
    NSParameterAssert( nil == regexConstructorError );
    NSParameterAssert( nil != transform );

    
    
    NSString* fixedUrls =
    [ transform stringByReplacingMatchesInString: rawValue
                                         options: 0
                                           range: entireString
                                    withTemplate: replacementPattern ];    
    
    return fixedUrls;
}

@end
