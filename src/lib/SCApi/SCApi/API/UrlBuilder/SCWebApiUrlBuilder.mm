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

-(NSString*)urlStringForMediaItemAtPath:( NSString* )itemPath
                                   host:( NSString* )host
                              mediaRoot:( NSString* )mediaRoot
                           resizeParams:( SCParams* )params
{
    NSParameterAssert( [ host hasSymbols ] );
    NSString* relativePath = itemPath;
    

    NSRange itemPathFullRange = { 0, [ itemPath length ] };
    NSLocale* posixLocale = [ NSLocale localeWithLocaleIdentifier: @"en_US_POSIX" ];
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

    NSString *paramsString = [ params paramsString ];
    if ( !paramsString )
    {
        paramsString = @"";
    }
    
    host = [ host scHostWithURLScheme ];
    
    NSString* result = [ NSString stringWithFormat: @"%@/~/media%@.ashx%@", host, relativePath, paramsString ];

    return result;
}

@end
