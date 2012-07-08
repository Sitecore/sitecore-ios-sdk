#import "SCSitecoreCredentials+XMLParser.h"

@implementation SCSitecoreCredentials (XMLParser)

+(id)sitecoreCredentialsWithDocument:( CXMLDocument* )xmlDocument_
{
    SCSitecoreCredentials* result_ = [ SCSitecoreCredentials new ];

    CXMLElement* rootElement_ = (CXMLElement*)[ xmlDocument_ rootElement ];

    {
        NSString* modulus_ = [ [ rootElement_ firstElementForNameNoThrow: @"Modulus"  ] stringValue ];
        result_.modulus  = modulus_ ?: @"";

        NSString* exponent_ = [ [ rootElement_ firstElementForNameNoThrow: @"Exponent" ] stringValue ];
        result_.exponent = exponent_ ?: @"";
    }

    return result_;
}

+(SCSitecoreCredentials*)sitecoreCredentialsWithXMLData:( NSData* )xmlData_
                                                  error:( NSError** )outError_
{
    CXMLDocument* document_ = xmlDocumentWithData( xmlData_, outError_ );

    if ( document_ )
        return [ self sitecoreCredentialsWithDocument: document_ ];

    return nil;
}

@end
