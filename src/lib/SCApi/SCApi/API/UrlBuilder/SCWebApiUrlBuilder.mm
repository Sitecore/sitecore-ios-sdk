#import "SCWebApiUrlBuilder.h"

#import "SCExtendedApiContext.h"

#import "SCItemsReaderRequest.h"
#import "SCItemsReaderRequest+URLWithItemsReaderRequest.h"

#import "SCEditItemsRequest.h"
#import "SCCreateItemRequest.h"
#import "SCItemsReaderRequest.h"
#import "SCHTMLReaderRequest.h"

#import "SCCreateMediaItemRequest.h"
#import "SCCreateMediaItemRequest+ToItemsReadRequest.h"


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
                           resizeParams:( SCParams* )params
{
    NSParameterAssert( [ host hasSymbols ] );
    
    
    NSString* relativePath = [ itemPath stringWithCutPrefix: @"/sitecore/media library" ];
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
