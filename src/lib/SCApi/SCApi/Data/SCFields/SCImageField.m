#import "SCImageField.h"

#import "SCApiContext.h"

@interface SCApiContext ()

-(JFFAsyncOperation)privateImageLoaderForSCMediaPath:( NSString* )path_;

@end

@implementation SCImageField

//STODO should be full path
@dynamic fieldValue;

-(NSString*)description
{
    return [ [ NSString alloc ] initWithFormat: @"<SCImageField name:\"%@\" type:\"%@\" value:\"%@\" imagePath:\"%@\" >"
            , self.name
            , self.type
            , self.rawValue
            , self.imagePath ];
}

-(JFFAsyncOperation)fieldValueLoader
{
    JFFAsyncOperation loader_ = [ self.apiContext privateImageLoaderForSCMediaPath: self.imagePath ];
    return [ self asyncOperationForPropertyWithName: @"fieldValue"
                                     asyncOperation: loader_ ];
}

-(NSString*)imagePath
{
    if ( !_imagePath )
    {
        NSData* data_ = [ self.rawValue dataUsingEncoding: NSUTF8StringEncoding ];
        CXMLDocument* document_ = xmlDocumentWithData( data_, nil );
        CXMLElement* rootElement_ = (CXMLElement*)[ document_ rootElement ];
        _imagePath = [ [ rootElement_ attributeForName: @"mediapath" ] stringValue ];
    }
    return _imagePath;
}

-(id)createFieldValue
{
    return nil;
}

-(SCAsyncOp)fieldValueReader
{
    return [ super fieldValueReader ];
}

@end
