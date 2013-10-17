#import "SCAbstractRequestUrlBuilder.h"

#import "SCWebApiConfig.h"

@implementation SCAbstractRequestUrlBuilder
{
@private
    NSMutableString* _result ;
}


-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( id )request
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_abstractRequest = request      ;
    self->_restConfig      = restApiConfig;
    self->_host            = host         ;
    self->_webApiVersion   = webApiVersion;
    
    return self;
}

-(NSMutableString*)result
{
    return self->_result;
}

-(NSString*)getRequestUrl
{
    if ( nil == self->_result )
    {
        [ self calculateRequestUrl ];
    }
    
    return [ NSString stringWithString: self->_result ];
}

-(void)calculateRequestUrl
{
    self->_result = [ NSMutableString new ];
    
    
    [ self appendHost           ];
    [ self appendWebApiEndpoint ];
    [ self appendWebApiVersion  ];
    [ self appendSite           ];
    [ self appendItemPath       ];
    [ self appendArguments      ];
}

-(void)appendHost
{
    [ self->_result appendString: self->_host ]; // http://ws-alr1.dk.sitecore.net:80
}

-(void)appendWebApiEndpoint
{
    [ self->_result appendString: self->_restConfig.pathSeparator  ]; // "/"
    [ self->_result appendString: self->_restConfig.webApiEndpoint ]; // "-/item"
}

-(void)appendWebApiVersion
{
    [ self->_result appendString: self->_restConfig.pathSeparator  ]; // "/"
    [ self->_result appendString: self->_webApiVersion             ]; // "v1"
}

-(void)appendSite
{
    NSString* site = objc_msgSend( self->_abstractRequest, @selector(site) );
    
    if ( [ site hasSymbols ] )
    {
        [ self->_result appendString: site  ]; // "/sitecore/shell"
    }
}

-(void)appendItemPath
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(NSArray*)getRestArgumentsList
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(void)appendArguments
{
    NSString* paramsString = nil;
    {
        NSArray* params_ = [ self getRestArgumentsList ];
        params_ = [ params_ select: ^BOOL( NSString* string_ )
        {
           return [ string_ length ] != 0;
        } ];
        paramsString = [ params_ componentsJoinedByString: self->_restConfig.restArgSeparator ];
        // &sc_database=web &sc_lang=en &....
    }

    if ( [ paramsString hasSymbols ] )
    {
        [ self->_result appendString: self->_restConfig.restArgsStart ]; // "?"
        [ self->_result appendString: paramsString ];
    }
}

@end
