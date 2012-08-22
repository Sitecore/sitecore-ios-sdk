#import "SCFieldLinkData+XMLParser.h"

#import "SCError.h"

@interface SCError (SCField)

+(id)errorWithDescription:( NSString* )description_;

@end

@interface SCFieldLinkData (XMLParserPrivate)

@property ( nonatomic ) NSString* linkDescription;
@property ( nonatomic ) NSString* linkType;
@property ( nonatomic ) NSString* url;

@end

@implementation SCFieldLinkData (XMLParser)

+(Class)fieldClassForType:( NSString* )type_
{
    static NSDictionary* classByFieldType_ = nil;
    if ( !classByFieldType_ )
    {
        classByFieldType_ = @{
        @"internal"   : [ SCInternalFieldLinkData   class ],
        @"media"      : [ SCMediaFieldLinkData      class ],
        @"external"   : [ SCExternalFieldLinkData   class ],
        @"anchor"     : [ SCAnchorFieldLinkData     class ],
        @"mailto"     : [ SCEmailFieldLinkData      class ],
        @"javascript" : [ SCJavascriptFieldLinkData class ],
        };
    }
    id class_ = classByFieldType_[ type_ ];
    return class_ ?: [ self class ];
}

+(id)createFieldLinkDataWithXMLElement:( CXMLElement* )rootElement_
{
    SCFieldLinkData* result_ = [ self new ];

    result_.linkDescription = [ [ rootElement_ attributeForName: @"text"     ] stringValue ];
    result_.linkType        = [ [ rootElement_ attributeForName: @"linktype" ] stringValue ];
    result_.url             = [ [ rootElement_ attributeForName: @"url"      ] stringValue ];

    return result_;
}

+(id)fieldLinkDataWithXMLDocument:( CXMLDocument* )xmlDocument_
{
    CXMLElement* rootElement_ = (CXMLElement*)[ xmlDocument_ rootElement ];

    NSString* linkType_ = [ [ rootElement_ attributeForName: @"linktype" ] stringValue ];

    Class class_ = [ self fieldClassForType: linkType_ ];

    return [ class_ createFieldLinkDataWithXMLElement: rootElement_ ];
}

+(id)fieldLinkDataWithXMLData:( NSData* )data_
                        error:( NSError** )outError_
{
    CXMLDocument* document_ = xmlDocumentWithData( data_, outError_ );

    if ( document_ )
        return [ self fieldLinkDataWithXMLDocument: document_ ];

    return nil;
}

@end

@interface SCInternalFieldLinkData (XMLParser)

@property ( nonatomic ) NSString *anchor;
@property ( nonatomic ) NSString *queryString;
@property ( nonatomic ) NSString *alternateText;
@property ( nonatomic ) NSString *itemId;

@end

@implementation SCInternalFieldLinkData (XMLParser)

@dynamic anchor
, queryString
, alternateText
, itemId;

+(id)createFieldLinkDataWithXMLElement:( CXMLElement* )rootElement_
{
    SCInternalFieldLinkData* result_ = [ super createFieldLinkDataWithXMLElement: rootElement_ ];

    result_.itemId        = [ [ rootElement_ attributeForName: @"id"          ] stringValue ];
    result_.anchor        = [ [ rootElement_ attributeForName: @"anchor"      ] stringValue ];
    result_.queryString   = [ [ rootElement_ attributeForName: @"querystring" ] stringValue ];
    result_.alternateText = [ [ rootElement_ attributeForName: @"title"       ] stringValue ];

    return result_;
}

@end

@interface SCMediaFieldLinkData (XMLParser)

@property ( nonatomic ) NSString *alternateText;
@property ( nonatomic ) NSString *itemId;

@end

@implementation SCMediaFieldLinkData (XMLParser)

@dynamic alternateText
, itemId;

+(id)createFieldLinkDataWithXMLElement:( CXMLElement* )rootElement_
{
    SCMediaFieldLinkData* result_ = [ super createFieldLinkDataWithXMLElement: rootElement_ ];

    result_.url           = [ [ rootElement_ attributeForName: @"url"   ] stringValue ];
    result_.itemId        = [ [ rootElement_ attributeForName: @"id"    ] stringValue ];
    result_.alternateText = [ [ rootElement_ attributeForName: @"title" ] stringValue ];

    return result_;
}

@end

@interface SCExternalFieldLinkData (XMLParser)

@property ( nonatomic ) NSString* url;
@property ( nonatomic ) NSString* alternateText;

@end

@implementation SCExternalFieldLinkData (XMLParser)

@dynamic alternateText, url;

+(id)createFieldLinkDataWithXMLElement:( CXMLElement* )rootElement_
{
    SCExternalFieldLinkData* result_ = [ super createFieldLinkDataWithXMLElement: rootElement_ ];

    result_.url             = [ [ rootElement_ attributeForName: @"url"      ] stringValue ];
    result_.alternateText   = [ [ rootElement_ attributeForName: @"title"    ] stringValue ];

    return result_;
}

@end

@interface SCAnchorFieldLinkData (XMLParser)

@property ( nonatomic ) NSString *anchor;
@property ( nonatomic ) NSString *alternateText;

@end

@implementation SCAnchorFieldLinkData (XMLParser)

@dynamic anchor
, alternateText;

+(id)createFieldLinkDataWithXMLElement:( CXMLElement* )rootElement_
{
    SCAnchorFieldLinkData* result_ = [ super createFieldLinkDataWithXMLElement: rootElement_ ];

    result_.url           = [ [ rootElement_ attributeForName: @"url"    ] stringValue ];
    result_.anchor        = [ [ rootElement_ attributeForName: @"anchor" ] stringValue ];
    result_.alternateText = [ [ rootElement_ attributeForName: @"title"  ] stringValue ];

    return result_;
}

@end

@interface SCEmailFieldLinkData (XMLParser)

@property ( nonatomic ) NSString *alternateText;

@end

@implementation SCEmailFieldLinkData (XMLParser)

@dynamic alternateText;

+(id)createFieldLinkDataWithXMLElement:( CXMLElement* )rootElement_
{
    SCExternalFieldLinkData* result_ = [ super createFieldLinkDataWithXMLElement: rootElement_ ];

    result_.url           = [ [ rootElement_ attributeForName: @"url"   ] stringValue ];
    result_.alternateText = [ [ rootElement_ attributeForName: @"title" ] stringValue ];

    return result_;
}

@end

@interface SCJavascriptFieldLinkData (XMLParser)

@property ( nonatomic ) NSString* alternateText;

@end

@implementation SCJavascriptFieldLinkData (XMLParser)

@dynamic alternateText;

+(id)createFieldLinkDataWithXMLElement:( CXMLElement* )rootElement_
{
    SCExternalFieldLinkData* result_ = [ super createFieldLinkDataWithXMLElement: rootElement_ ];

    result_.url           = [ [ rootElement_ attributeForName: @"url"   ] stringValue ];
    result_.alternateText = [ [ rootElement_ attributeForName: @"title" ] stringValue ];

    return result_;
}

@end
