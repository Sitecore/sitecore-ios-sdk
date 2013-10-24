#import "SCActionsUrlBuilder.h"

#import "SCWebApiConfig.h"
#import "NSString+URLWithItemsReaderRequest.h"

@implementation SCActionsUrlBuilder

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
{
    NSParameterAssert( nil != host );
    NSParameterAssert( nil != webApiVersion );
    NSParameterAssert( nil != restApiConfig );
    
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }

    self->_host = [ host scHostWithURLScheme ];
    self->_webApiVersion = webApiVersion;
    self->_restApiConfig = restApiConfig;

    return self;
}

-(NSMutableString*)newActionBaseUrlForSite:( NSString* )site
{
    NSMutableString* result = [ NSMutableString new ];
    {
        [ result appendString: self->_host ];
        [ result appendString: self->_restApiConfig.pathSeparator  ];       // "/"
        [ result appendString: self->_restApiConfig.webApiEndpoint ];       // "-/item"
        [ result appendString: self->_restApiConfig.pathSeparator  ];       // "/"
        [ result appendString: self->_webApiVersion ];                      // "v1"

        if ( [ site hasSymbols ] )
        {
            [ result appendString: site ];
        }

        [ result appendString: self->_restApiConfig.pathSeparator  ];       // "/"
        [ result appendString: self->_restApiConfig.actionEndpoint ];       // "-/actions"
        [ result appendString: self->_restApiConfig.pathSeparator  ];       // "/"
    }
    
    return result;
}

-(NSString*)urlToCheckCredentialsForSite:( NSString* )site
{
    NSMutableString* result = [ self newActionBaseUrlForSite: site ];
    [ result appendString: self->_restApiConfig.checkPasswordAction ];  // "authenticate"
    
    return [ NSString stringWithString: result ];
}


-(NSString*)urlToGetPublicKey
{
    NSMutableString* result = [ self newActionBaseUrlForSite: nil ];
    [ result appendString: self->_restApiConfig.publicKeyAction ];  // "GetPublicKey"
    
    return [ NSString stringWithString: result ];
}

@end
