#import "SCItemCreatorUrlBuilder.h"

#import "SCCreateItemRequest.h"
#import "SCReadItemsRequest.h"
#import "SCWebApiConfig.h"
#import "SCRestArgsBuilder.h"

#import "SCReaderRequestUrlBuilder+Virtual.h"

@implementation SCItemCreatorUrlBuilder
{
    SCCreateItemRequest* _creatorRequest;
}

-(instancetype)initWithHost:( NSString* )host
              webApiVersion:( NSString* )webApiVersion
              restApiConfig:( SCWebApiConfig* )restApiConfig
                    request:( SCCreateItemRequest* )request
{
    self = [ super initWithHost: host
                  webApiVersion: webApiVersion
                  restApiConfig: restApiConfig
                        request: request ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_creatorRequest = request;
    
    return self;
}

-(NSArray*)getRestArgumentsList
{
//    NSParameterAssert( [ self->_creatorRequest.itemName     hasSymbols ] );
//    NSParameterAssert( [ self->_creatorRequest.itemTemplate hasSymbols ] );
    

    NSString* nameParam = [ SCRestArgsBuilder itemNameParam: self->_creatorRequest.itemName ];

    NSString* templateParam = [ SCRestArgsBuilder templateParam: self->_creatorRequest.itemTemplate ];

    NSArray* readerParams = [ super getRestArgumentsList ];
    NSArray* createParams = @[ nameParam, templateParam ];
    
//    NSParameterAssert( 2 == [ createParams count ] );
    NSArray* result = [ createParams arrayByAddingObjectsFromArray: readerParams ];
    
    return result;
}


@end
