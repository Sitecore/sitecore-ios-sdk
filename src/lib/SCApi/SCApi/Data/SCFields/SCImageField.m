#import "SCImageField.h"

#import "SCExtendedApiSession.h"
#import "SCParams.h"
#import "SCField+Private.h"
#import "SCExtendedApiSession+Private.h"

#import "SCDownloadMediaOptions.h"

@interface SCExtendedApiSession ()

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
   SCDownloadMediaOptions* resizingOptions = [ self defaultResizingOptions ];
   return [ self fieldValueLoaderWithParms: resizingOptions ];
}

-(JFFAsyncOperation)fieldValueLoaderWithParms:( SCDownloadMediaOptions * )params
{
    NSString *imagePath_ = self.imagePath;
    if ( nil != imagePath_)
    {
        JFFAsyncOperation loader_ = [ self.apiSession privateImageLoaderForSCMediaPath: imagePath_
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

-(SCDownloadMediaOptions*)defaultResizingOptions
{
    id<SCItemSource> itemSource = self.itemSource;
    SCDownloadMediaOptions* resizingOptions = [ SCDownloadMediaOptions new ];
    {
        resizingOptions.database = [ itemSource database ];
        resizingOptions.language = [ itemSource language ];
    }

    return resizingOptions;
}

-(SCAsyncOp)readFieldValueOperation
{
    SCDownloadMediaOptions* resizingOptions = [ self defaultResizingOptions ];
    return [ self readFieldValueOperationWithImageParams: resizingOptions ];
}

-(SCAsyncOp)readFieldValueOperationWithImageParams:( SCParams* )params;
{
    return [ super readFieldValueOperationWithParams: params ];
}

@end
