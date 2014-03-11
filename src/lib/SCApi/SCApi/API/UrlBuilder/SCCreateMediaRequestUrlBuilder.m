#import "SCCreateMediaRequestUrlBuilder.h"
#import "SCAbstractRequestUrlBuilder+Private.h"

#import "SCWebApiConfig.h"

#import "SCUploadMediaItemRequest.h"
#import "SCUploadMediaItemRequest+ToItemsReadRequest.h"


#import "SCRestArgsBuilder.h"
#import "SCReadItemsRequest+URLWithItemsReaderRequest.h"


@implementation SCCreateMediaRequestUrlBuilder
{
@private
    SCUploadMediaItemRequest * _request         ;
    NSString                 * _mediaLibraryRoot;
    NSLocale                 * _posixLocale     ;
}

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCUploadMediaItemRequest * )request
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithHost:( NSString* )host
           mediaLibraryRoot:( NSString* )mediaLibraryRoot
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCUploadMediaItemRequest * )request
{
    NSParameterAssert( nil != host );
    NSParameterAssert( nil != mediaLibraryRoot );
    NSParameterAssert( nil != webApiVersion );
    NSParameterAssert( nil != restApiConfig );
    NSParameterAssert( nil != request );
    
    self = [ super initWithHost: host
                  webApiVersion: webApiVersion
                  restApiConfig: restApiConfig
                        request: request ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_request = request;
    self->_mediaLibraryRoot = mediaLibraryRoot;
    self->_posixLocale = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    
    return self;
}


-(void)appendItemPath
{
    NSMutableString* result = [ self result ];
    
    NSString* mediaPath = [ self->_mediaLibraryRoot stringByAppendingPathComponent: self->_request.folder ];
    NSString* lowerCaseMediaPath = [ mediaPath lowercaseStringWithLocale: self->_posixLocale ];
    NSString* encodedMediaPath = [ lowerCaseMediaPath stringByEncodingURLFormat ];
    
    [ result appendString: encodedMediaPath ];
}

-(NSArray*)getRestArgumentsList
{
//    NSParameterAssert( [ self->_request.itemName     hasSymbols ] );
//    NSParameterAssert( [ self->_request.itemTemplate hasSymbols ] );

    NSString* databaseParam_ = [ SCRestArgsBuilder databaseParamWithDatabase: self->_request.database ];
    NSString* languageParam_ = [ SCRestArgsBuilder languageParamWithLanguage: self->_request.language ];
    
    NSString* nameParam = [ SCRestArgsBuilder itemNameParam: self->_request.itemName ];
    NSString* templateParam = [ SCRestArgsBuilder templateParam: self->_request.itemTemplate ];
    
    NSString* fieldsParam_ = [ SCRestArgsBuilder fieldsURLParam: self->_request.fieldNames ];
    
    
    return @[ nameParam, templateParam, databaseParam_, languageParam_, fieldsParam_ ];
}

@end
