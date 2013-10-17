#import "SCWebApiConfig.h"

@implementation SCWebApiConfig

+(instancetype)webApiV1Config
{
    SCWebApiConfig* result = [ self new ];
    
    result->_webApiEndpoint      = @"-/item"          ;
    result->_actionEndpoint      = @"-/actions"       ;
    result->_renderingHtmlAction = @"GetRenderingHtml";
    result->_publicKeyAction     = @"GetPublicKey"    ;
    result->_checkPasswordAction = @"authenticate"    ;

    result->_pathSeparator         = @"/";
    result->_restArgsStart         = @"?";
    result->_restArgSeparator      = @"&";
    result->_restKeyValueSeparator = @"=";

    return result;
}


@end
