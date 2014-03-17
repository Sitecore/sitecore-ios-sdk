#import "SCWebApiUrlBuilder.h"

#import "SCExtendedApiSession.h"

#import "SCReadItemsRequest.h"
#import "SCReadItemsRequest+URLWithItemsReaderRequest.h"

#import "SCEditItemsRequest.h"
#import "SCCreateItemRequest.h"
#import "SCReadItemsRequest.h"
#import "SCGetRenderingHtmlRequest.h"

#import "SCUploadMediaItemRequest.h"
#import "SCUploadMediaItemRequest+ToItemsReadRequest.h"


#import "NSString+URLWithItemsReaderRequest.h"


#import "SCParams.h"
#import "SCParams+UrlBuilder.h"

#import "SCActionsUrlBuilder.h"
#import "SCWebApiConfig.h"

@interface SCWebApiUrlBuilder()

@property ( nonatomic ) NSString* webApiVersion;

@end



@implementation SCWebApiUrlBuilder

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithVersion:( NSString* )webApiVersion
{
    NSParameterAssert( [ webApiVersion hasSymbols ] );
    
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }

    self->_webApiVersion = webApiVersion;

    return self;
}



//    NSString* result = [ NSString stringWithFormat: @"%@/~/media%@.ashx%@", host, relativePath, paramsString ];
-(NSString*)urlStringForMediaItemAtPath:( NSString* )itemPath
                                   host:( NSString* )host
                              mediaRoot:( NSString* )mediaRoot
                           resizeParams:( SCParams* )params
{
    NSParameterAssert( [ itemPath hasSymbols ] );
    NSParameterAssert( [ host     hasSymbols ] );
    
    
    NSString* relativePath = itemPath;

    host = [ host scHostWithURLScheme ];
    NSString* result = host;
    
    
    NSRange itemPathFullRange = { 0, [ itemPath length ] };
    NSLocale* posixLocale = [ NSLocale localeWithLocaleIdentifier: @"en_US_POSIX" ];
    
    
    static NSString* const MEDIA_HOOK = @"~/media";
    NSRange mediaHookRange = [ itemPath rangeOfString: MEDIA_HOOK
                                              options: NSCaseInsensitiveSearch
                                                range: itemPathFullRange
                                               locale: posixLocale ];
    BOOL isMediaHookAvailable = ( 0 == mediaHookRange.location );
    
    
    static NSString* const ASHX_EXTENSION = @".ashx";
    NSRange extensionRange = [ itemPath rangeOfString: ASHX_EXTENSION
                                              options: NSCaseInsensitiveSearch
                                                range: itemPathFullRange
                                               locale: posixLocale ];
    BOOL isExtensionAvailable = ( NSNotFound != extensionRange.location );
    
    
    if ( isMediaHookAvailable )
    {
        result = [ result stringByAppendingFormat: @"/%@", itemPath ];
        
        if ( !isExtensionAvailable )
        {
            result = [ result stringByAppendingString: ASHX_EXTENSION ];
        }
    }
    else
    {
        result = [ result stringByAppendingFormat: @"/%@", MEDIA_HOOK ];
        
        
        NSRange mediaRootRange = [ itemPath rangeOfString: mediaRoot
                                                  options: NSCaseInsensitiveSearch
                                                    range: itemPathFullRange
                                                   locale: posixLocale ];
        if ( 0 == mediaRootRange.location )
        {
            NSUInteger afterRootMedia = NSMaxRange( mediaRootRange );
            relativePath = [ itemPath substringFromIndex: afterRootMedia ];
        }
        else
        {
            NSLog(@"root media not found");
        }
        
        
        {
            BOOL isValidRelativePath = [ relativePath hasSymbols ];
            NSParameterAssert( isValidRelativePath );
        }

        result = [ result stringByAppendingString: relativePath ];
        result = [ result stringByAppendingString: ASHX_EXTENSION ];
    }


    NSString *paramsString = [ params paramsString ];
    if ( nil != paramsString )
    {
        result = [ result stringByAppendingString: paramsString ];
    }

    return result;
}

@end
