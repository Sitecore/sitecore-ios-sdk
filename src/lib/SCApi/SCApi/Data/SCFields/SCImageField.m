#import "SCImageField.h"

#import "SCExtendedApiContext.h"
#import "SCParams.h"
#import "SCField+Private.h"
#import "SCExtendedApiContext+Private.h"

@interface SCExtendedApiContext ()

-(JFFAsyncOperation)privateImageLoaderForSCMediaPath:( NSString* )path_;
//-(JFFAsyncOperation)privateImageLoaderForSCMediaPath:( NSString* )path_
//                                              params:( SCParams* )params;
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
   return [ self fieldValueLoaderWithParms: nil ];
}

-(JFFAsyncOperation)fieldValueLoaderWithParms:( SCFieldImageParams* )params
{
    NSString *imagePath_ = self.imagePath;
    if (imagePath_)
    {
        JFFAsyncOperation loader_ = [ self.apiContext privateImageLoaderForSCMediaPath: imagePath_
                                                                                params: params ];
        
        return [ self asyncOperationForPropertyWithName: @"fieldValue"
                                         asyncOperation: loader_ ];
    }
    
    return NULL;
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
    return [ self fieldValueReaderWithImageParams: nil ];
}

-(SCAsyncOp)fieldValueReaderWithImageParams:( SCParams* )params;
{
    return [ super fieldValueReaderWithParams: params ];
}

@end
