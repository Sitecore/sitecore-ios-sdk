#import "SCApiContext.h"
#import "SCExtendedApiContext.h"
#import "SCExtendedApiContext+Private.h"
#import "SCHTMLReaderRequest.h"

#import "SCHostLoginAndPassword.h"
#import "SCApiContext+Init.h"
#import "SCItemSource.h"
#import "SCItemSourcePOD.h"

@interface SCApiContext ()

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;
@property ( nonatomic ) SCRemoteApi * api;

@end

@interface SCExtendedApiContext (CacheApi)

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;
@property ( nonatomic ) SCRemoteApi * api;

@end

@implementation SCApiContext

@dynamic itemsCache;
@dynamic api;

+(id)contextWithHost:( NSString* )host_
               login:( NSString* )login_
            password:( NSString* )password_
             version:(SCWebApiVersion)webApiVersion
{
    id key_ = [ [ SCHostLoginAndPassword alloc ] initWithHost: host_
                                                        login: login_
                                                     password: password_ ];
    
    static JFFMutableAssignDictionary* contextByHost_ = nil;
    if ( !contextByHost_ )
    {
        contextByHost_ = [ JFFMutableAssignDictionary new ];
    }
    id result_ = contextByHost_[ key_ ];
    if ( !result_ )
    {
        result_ = [ [ self alloc ] initWithHost: host_
                                          login: login_
                                       password: password_
                                        version: webApiVersion ];
        
        contextByHost_[ key_ ] = result_;
    }
    return result_;
}

+(id)contextWithHost:( NSString* )host_
             version:(SCWebApiVersion)webApiVersion
{
    return [ self contextWithHost: host_
                            login: nil
                         password: nil
                          version: webApiVersion ];
}

+(id)contextWithHost:(NSString*)host
{
    return [ self contextWithHost: host
                          version: SCWebApiMaxSupportedVersion ];
}

+(id)contextWithHost:(NSString *)host
               login:(NSString *)login
            password:(NSString *)password
{
    return [ self contextWithHost: host
                            login: login
                         password: password
                          version: SCWebApiMaxSupportedVersion ];
}

-(void)setApi:(SCRemoteApi *)api
{
    self.extendedApiContext.api = api;
}

-(SCRemoteApi *)api
{
    return self.extendedApiContext.api;
}

-(void)setItemsCache:(id<SCItemRecordCacheRW>)itemsCache
{
    self.extendedApiContext.itemsCache = itemsCache;
}

-(id<SCItemRecordCacheRW>)itemsCache
{
    return self.extendedApiContext.itemsCache;
}

-(void)setExtendedApiContext:(SCExtendedApiContext *)extendedApiContext
{
    self->_extendedApiContext = extendedApiContext;
}

-(void)setDefaultSite:(NSString *)defaultSite
{
    self.extendedApiContext.defaultSite = defaultSite;
}

-(void)setDefaultLanguage:(NSString *)defaultLanguage
{
    self.extendedApiContext.defaultLanguage = defaultLanguage;
}

-(void)setDefaultDatabase:(NSString *)defaultDatabase
{
    self.extendedApiContext.defaultDatabase = defaultDatabase;
}

-(void)setDefaultItemVersion:(NSString *)defaultItemVersion
{
    self.extendedApiContext.defaultItemVersion = defaultItemVersion;
}

-(void)setDefaultLifeTimeInCache:(NSTimeInterval)defaultLifeTimeInCache
{
    self.extendedApiContext.defaultLifeTimeInCache = defaultLifeTimeInCache;
}

-(void)setDefaultImagesLifeTimeInCache:(NSTimeInterval)defaultImagesLifeTimeInCache
{
    self.extendedApiContext.defaultImagesLifeTimeInCache = defaultImagesLifeTimeInCache;
}

-(void)setSystemLanguages:(NSSet *)systemLanguages
{
    self.extendedApiContext.systemLanguages = systemLanguages;
}

-(NSString *)defaultSite
{
    return self.extendedApiContext.defaultSite;
}

-(NSString *)defaultLanguage
{
    return self.extendedApiContext.defaultLanguage;
}

-(NSString *)defaultDatabase
{
    return self.extendedApiContext.defaultDatabase;
}

-(NSString *)defaultItemVersion
{
    return self.extendedApiContext.defaultItemVersion;
}

-(NSTimeInterval)defaultLifeTimeInCache
{
    return self.extendedApiContext.defaultLifeTimeInCache;
}

-(NSTimeInterval)defaultImagesLifeTimeInCache
{
    return self.extendedApiContext.defaultImagesLifeTimeInCache;
}

-(NSSet *)systemLanguages
{
    return self.extendedApiContext.systemLanguages;
}

- (SCAsyncOp)credentialsCheckerForSite:( NSString* )site
{
    return asyncOpWithJAsyncOp( [ self.extendedApiContext credentialsCheckerForSite: site ] );
}

- (SCAsyncOp)systemLanguagesReader
{
    return asyncOpWithJAsyncOp( [ self.extendedApiContext systemLanguagesReader ] );
}

- (SCAsyncOp)itemsReaderWithRequest:(SCItemsReaderRequest *)request
{
    return asyncOpWithJAsyncOp( [ self.extendedApiContext itemsReaderWithRequest: request ] );
}

- (SCAsyncOp)itemReaderForItemId:(NSString *)itemId
{
    return asyncOpWithJAsyncOp( [ self.extendedApiContext itemReaderForItemId: itemId
                                                                   itemSource: [ self contextSource ] ] );
}

- (SCAsyncOp)itemReaderForItemPath:(NSString *)path
{
    SCExtendedAsyncOp result =
    [ self.extendedApiContext itemReaderForItemPath: path
                                         itemSource: [ self contextSource ] ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)itemReaderWithFieldsNames:(NSSet *)fieldNames
                                itemId:(NSString *)itemId
{
    SCExtendedAsyncOp result =
    [ self.extendedApiContext itemReaderWithFieldsNames: fieldNames
                                                 itemId: itemId
                                             itemSource: [ self contextSource ] ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)itemReaderWithFieldsNames:(NSSet *)fieldNames
                            itemSource:(id<SCItemSource>)itemSource
                                itemId:(NSString *)itemId
{
    SCExtendedAsyncOp result = [ self.extendedApiContext itemReaderWithFieldsNames: fieldNames
                                                                            itemId: itemId
                                                                        itemSource: itemSource ];
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)itemReaderWithFieldsNames:(NSSet *)fieldNames
                              itemPath:(NSString *)path
{
    SCExtendedAsyncOp result =
    [ self.extendedApiContext itemReaderWithFieldsNames: fieldNames
                                               itemPath: path
                                             itemSource: [ self contextSource ] ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)itemReaderWithFieldsNames:(NSSet *)fieldNames
                         itemSourcePOD:(SCItemSourcePOD *)itemSourcePOD
                              itemPath:(NSString *)path
{
    SCExtendedAsyncOp result = [ self.extendedApiContext itemReaderWithFieldsNames: fieldNames
                                                                          itemPath: path
                                                                        itemSource: [ self contextSource ] ];
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)itemCreatorWithRequest:(SCCreateItemRequest *)createItemRequest
{
    return asyncOpWithJAsyncOp( [ self.extendedApiContext itemCreatorWithRequest: createItemRequest ] );
}

- (SCAsyncOp)editItemsWithRequest:(SCEditItemsRequest *)editItemsRequest
{
    return asyncOpWithJAsyncOp( [ self.extendedApiContext editItemsWithRequest: editItemsRequest ] );
}

- (SCAsyncOp)removeItemsWithRequest:(SCItemsReaderRequest *)request
{
    return asyncOpWithJAsyncOp( [ self.extendedApiContext removeItemsWithRequest: request ] );
}

- (SCAsyncOp)mediaItemCreatorWithRequest:(SCCreateMediaItemRequest *)createMediaItemRequest
{
    return asyncOpWithJAsyncOp( [ self.extendedApiContext mediaItemCreatorWithRequest: createMediaItemRequest ] );
}

- (SCAsyncOp)childrenReaderWithItemId:(NSString *)itemId
{
    SCExtendedAsyncOp result =
    [ self.extendedApiContext childrenReaderWithItemId: itemId
                                            itemSource: [ self contextSource ] ];
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)childrenReaderWithItemPath:(NSString *)path
{
    SCExtendedAsyncOp result =
    [ self.extendedApiContext childrenReaderWithItemPath: path
                                              itemSource: [ self contextSource ] ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)imageLoaderForSCMediaPath:(NSString *)path
{
    SCExtendedAsyncOp result =
    [ self.extendedApiContext imageLoaderForSCMediaPath: path
                                            imageParams: nil ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)imageLoaderForSCMediaPath:(NSString *)path
                           imageParams:( SCFieldImageParams* )params
{
    SCExtendedAsyncOp result = [ self.extendedApiContext imageLoaderForSCMediaPath: path
                                                                       imageParams: params ];
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)renderingHTMLReaderWithRequest:(SCHTMLReaderRequest *)request
{
    SCExtendedAsyncOp result = [ self.extendedApiContext renderingHTMLReaderWithRequest: request ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)renderingHTMLLoaderForRenderingWithId:(NSString *)renderingId
                                          sourceId:(NSString *)sourceId
{
    SCHTMLReaderRequest * request = [ SCHTMLReaderRequest new ];
    request.renderingId = renderingId;
    request.sourceId = sourceId;
    
    SCExtendedAsyncOp result =
    [ self.extendedApiContext renderingHTMLReaderWithRequest: request ];
    
    return asyncOpWithJAsyncOp( result );
}


- (SCAsyncOp)triggerLoaderForRequest:( SCTriggeringRequest* )request
{
    SCExtendedAsyncOp result = [ self.extendedApiContext triggerLoaderForRequest: request ];
    return asyncOpWithJAsyncOp( result );
}


#pragma mark -
#pragma mark Cache
- (SCItem *)itemWithPath:(NSString *)path
{
    return [ self itemWithPath: path
                        source: [ self contextSource ] ];    
}

- (SCItem *)itemWithId:(NSString *)itemId
{
    return [ self itemWithId: itemId
                      source: [ self contextSource ] ];
}

- (SCItem *)itemWithPath:(NSString *)path
                  source:( id<SCItemSource> )itemSource
{
    return [ self.extendedApiContext itemWithPath: path
                                       itemSource: itemSource ];
}

- (SCItem *)itemWithId:(NSString *)itemId
                source:( id<SCItemSource> )itemSource
{
    return [ self.extendedApiContext itemWithId: itemId
                                     itemSource: itemSource ];
}

- (SCField*)fieldWithName:(NSString *)fieldName
                   itemId:(NSString *)itemId
{
    return [ self fieldWithName: fieldName
                         itemId: itemId
                         source: [ self contextSource ] ];
}


- (SCField*)fieldWithName:(NSString *)fieldName
                   itemId:(NSString *)itemId
                   source:( id<SCItemSource> )itemSource
{
    return [ self.extendedApiContext fieldWithName: fieldName
                                            itemId: itemId
                                        itemSource: itemSource ];
}

- (NSDictionary*)readFieldsByNameForItemId:(NSString *)itemId
{
    return [ self readFieldsByNameForItemId: itemId
                                     source: [ self contextSource ] ];
}


- (NSDictionary*)readFieldsByNameForItemId:(NSString *)itemId
                                    source:( id<SCItemSource> )itemSource
{
    return [ self.extendedApiContext readFieldsByNameForItemId: itemId
                                                    itemSource: itemSource ];
}

-(SCItemSourcePOD*)contextSource
{
    return [ self.extendedApiContext contextSource ];
}


// @igk hack to use NSString lowercaseStringWithLocale: method in ios 5.x

- (NSString *)lowercaseStringWithLocale:(NSLocale *)locale
{
    NSAssert([self isKindOfClass:[NSString class]], @"wrong instance class");
    
    return [(NSString *)self lowercaseString];
}

+(void)load
{
    //for ios 5.x only
    [ self addInstanceMethodIfNeedWithSelector: @selector( lowercaseStringWithLocale: )
                                       toClass: [ NSString class ] ];
}


@end
