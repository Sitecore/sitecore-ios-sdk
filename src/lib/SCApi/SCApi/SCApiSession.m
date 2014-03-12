#import "SCApiSession.h"
#import "SCExtendedApiSession.h"
#import "SCExtendedApiSession+Private.h"
#import "SCGetRenderingHtmlRequest.h"

#import "SCHostLoginAndPassword.h"
#import "SCApiSession+Init.h"
#import "SCItemSource.h"
#import "SCItemSourcePOD.h"

@interface SCApiSession ()

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;
@property ( nonatomic ) SCRemoteApi * api;

@end

@interface SCExtendedApiSession (CacheApi)

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;
@property ( nonatomic ) SCRemoteApi * api;

@end

@implementation SCApiSession

@dynamic itemsCache;
@dynamic api;
@dynamic mediaLibraryPath;

+(id)sessionWithHost:( NSString* )host_
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

+(id)sessionWithHost:( NSString* )host_
             version:(SCWebApiVersion)webApiVersion
{
    return [ self sessionWithHost: host_
                            login: nil
                         password: nil
                          version: webApiVersion ];
}

+(id)sessionWithHost:(NSString*)host
{
    return [ self sessionWithHost: host
                          version: SCWebApiMaxSupportedVersion ];
}

+(id)sessionWithHost:(NSString *)host
               login:(NSString *)login
            password:(NSString *)password
{
    return [ self sessionWithHost: host
                            login: login
                         password: password
                          version: SCWebApiMaxSupportedVersion ];
}

-(void)setApi:(SCRemoteApi *)api
{
    self.extendedApiSession.api = api;
}

-(SCRemoteApi *)api
{
    return self.extendedApiSession.api;
}

-(void)setItemsCache:(id<SCItemRecordCacheRW>)itemsCache
{
    self.extendedApiSession.itemsCache = itemsCache;
}

-(id<SCItemRecordCacheRW>)itemsCache
{
    return self.extendedApiSession.itemsCache;
}

-(void)setExtendedApiSession:(SCExtendedApiSession *)extendedApiSession
{
    self->_extendedApiSession = extendedApiSession;
}

-(void)setDefaultSite:(NSString *)defaultSite
{
    self.extendedApiSession.defaultSite = defaultSite;
}

-(void)setDefaultLanguage:(NSString *)defaultLanguage
{
    self.extendedApiSession.defaultLanguage = defaultLanguage;
}

-(void)setDefaultDatabase:(NSString *)defaultDatabase
{
    self.extendedApiSession.defaultDatabase = defaultDatabase;
}

-(void)setDefaultItemVersion:(NSString *)defaultItemVersion
{
    self.extendedApiSession.defaultItemVersion = defaultItemVersion;
}

-(void)setMediaLibraryPath:(NSString *)mediaLibraryPath
{
    [ self->_extendedApiSession setMediaLibraryPath: mediaLibraryPath ];
}

-(void)setDefaultLifeTimeInCache:(NSTimeInterval)defaultLifeTimeInCache
{
    self.extendedApiSession.defaultLifeTimeInCache = defaultLifeTimeInCache;
}

-(void)setDefaultImagesLifeTimeInCache:(NSTimeInterval)defaultImagesLifeTimeInCache
{
    self.extendedApiSession.defaultImagesLifeTimeInCache = defaultImagesLifeTimeInCache;
}

-(void)setSystemLanguages:(NSSet *)systemLanguages
{
    self.extendedApiSession.systemLanguages = systemLanguages;
}

-(NSString *)defaultSite
{
    return self.extendedApiSession.defaultSite;
}

-(NSString *)defaultLanguage
{
    return self.extendedApiSession.defaultLanguage;
}

-(NSString *)defaultDatabase
{
    return self.extendedApiSession.defaultDatabase;
}

-(NSString *)defaultItemVersion
{
    return self.extendedApiSession.defaultItemVersion;
}

-(NSString*)mediaLibraryPath
{
    return [ self->_extendedApiSession mediaLibraryPath ];
}

+(NSString*)defaultMediaLibraryPath
{
    return [ SCExtendedApiSession defaultMediaLibraryPath ];
}

-(NSTimeInterval)defaultLifeTimeInCache
{
    return self.extendedApiSession.defaultLifeTimeInCache;
}

-(NSTimeInterval)defaultImagesLifeTimeInCache
{
    return self.extendedApiSession.defaultImagesLifeTimeInCache;
}

-(NSSet *)systemLanguages
{
    return self.extendedApiSession.systemLanguages;
}

-(void)cleanupItemsCache
{
    return [ self->_extendedApiSession cleanupItemsCache ];
}

- (SCAsyncOp)checkCredentialsOperationForSite:( NSString* )site
{
    return asyncOpWithJAsyncOp( [ self.extendedApiSession checkCredentialsOperationForSite: site ] );
}

- (SCAsyncOp)readSystemLanguagesOperation
{
    return asyncOpWithJAsyncOp( [ self.extendedApiSession readSystemLanguagesOperation ] );
}

- (SCAsyncOp)readItemsOperationWithRequest:(SCReadItemsRequest *)request
{
    return asyncOpWithJAsyncOp( [ self.extendedApiSession readItemsOperationWithRequest: request ] );
}

- (SCAsyncOp)readItemOperationForItemId:(NSString *)itemId
{
    return asyncOpWithJAsyncOp( [ self.extendedApiSession readItemOperationForItemId: itemId
                                                                          itemSource: [ self contextSource ] ] );
}

- (SCAsyncOp)readItemOperationForItemPath:(NSString *)path
{
    SCExtendedAsyncOp result =
    [ self.extendedApiSession readItemOperationForItemPath: path
                                                itemSource: [ self contextSource ] ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)readItemOperationForFieldsNames:(NSSet *)fieldNames
                                      itemId:(NSString *)itemId
{
    SCExtendedAsyncOp result =
    [ self.extendedApiSession readItemOperationForFieldsNames: fieldNames
                                                       itemId: itemId
                                                   itemSource: [ self contextSource ] ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)readItemOperationForFieldsNames:(NSSet *)fieldNames
                                  itemSource:(id<SCItemSource>)itemSource
                                      itemId:(NSString *)itemId
{
    SCExtendedAsyncOp result = [ self.extendedApiSession readItemOperationForFieldsNames: fieldNames
                                                                                  itemId: itemId
                                                                              itemSource: itemSource ];
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)readItemOperationForFieldsNames:(NSSet *)fieldNames
                                    itemPath:(NSString *)path
{
    SCExtendedAsyncOp result =
    [ self.extendedApiSession readItemOperationForFieldsNames: fieldNames
                                                     itemPath: path
                                                   itemSource: [ self contextSource ] ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)readItemOperationForFieldsNames:(NSSet *)fieldNames
                               itemSourcePOD:(SCItemSourcePOD *)itemSourcePOD
                                    itemPath:(NSString *)path
{
    SCExtendedAsyncOp result = [ self.extendedApiSession readItemOperationForFieldsNames: fieldNames
                                                                                itemPath: path
                                                                              itemSource: [ self contextSource ] ];
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)createItemsOperationWithRequest:(SCCreateItemRequest *)createItemRequest
{
    return asyncOpWithJAsyncOp( [ self.extendedApiSession createItemsOperationWithRequest: createItemRequest ] );
}

- (SCAsyncOp)editItemsOperationWithRequest:(SCEditItemsRequest *)editItemsRequest
{
    return asyncOpWithJAsyncOp( [ self.extendedApiSession editItemsOperationWithRequest: editItemsRequest ] );
}

- (SCAsyncOp)deleteItemsOperationWithRequest:(SCReadItemsRequest *)request
{
    return asyncOpWithJAsyncOp( [ self.extendedApiSession deleteItemsOperationWithRequest: request ] );
}

- (SCAsyncOp)uploadMediaOperationWithRequest:(SCUploadMediaItemRequest *)createMediaItemRequest
{
    return asyncOpWithJAsyncOp( [ self.extendedApiSession uploadMediaOperationWithRequest: createMediaItemRequest ] );
}

- (SCAsyncOp)readChildrenOperationForItemId:(NSString *)itemId
{
    SCExtendedAsyncOp result =
    [ self.extendedApiSession readChildrenOperationForItemId: itemId
                                                  itemSource: [ self contextSource ] ];
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)readChildrenOperationForItemPath:(NSString *)path
{
    SCExtendedAsyncOp result =
    [ self.extendedApiSession readChildrenOperationForItemPath: path
                                                    itemSource: [ self contextSource ] ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)downloadResourceOperationForMediaPath:(NSString *)path
{
    SCExtendedAsyncOp result =
    [ self.extendedApiSession downloadResourceOperationForMediaPath: path
                                                imageParams: nil ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)downloadResourceOperationForMediaPath:(NSString *)path
                               imageParams:( SCDownloadMediaOptions * )params
{
    SCExtendedAsyncOp result = [ self.extendedApiSession downloadResourceOperationForMediaPath: path
                                                                           imageParams: params ];
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)getRenderingHtmlOperationWithRequest:(SCGetRenderingHtmlRequest *)request
{
    SCExtendedAsyncOp result = [ self.extendedApiSession getRenderingHtmlOperationWithRequest: request ];
    
    return asyncOpWithJAsyncOp( result );
}

- (SCAsyncOp)getRenderingHtmlOperationForRenderingWithId:(NSString *)renderingId
                                                sourceId:(NSString *)sourceId
{
    SCGetRenderingHtmlRequest * request = [SCGetRenderingHtmlRequest new];
    request.renderingId = renderingId;
    request.sourceId = sourceId;
    
    SCExtendedAsyncOp result =
    [ self.extendedApiSession getRenderingHtmlOperationWithRequest: request ];
    
    return asyncOpWithJAsyncOp( result );
}


- (SCAsyncOp)triggerOperationWithRequest:( SCTriggeringRequest* )request
{
    SCExtendedAsyncOp result = [ self.extendedApiSession triggerOperationWithRequest: request ];
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
    return [ self.extendedApiSession itemWithPath: path
                                       itemSource: itemSource ];
}

- (SCItem *)itemWithId:(NSString *)itemId
                source:( id<SCItemSource> )itemSource
{
    return [ self.extendedApiSession itemWithId: itemId
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
    return [ self.extendedApiSession fieldWithName: fieldName
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
    return [ self.extendedApiSession readFieldsByNameForItemId: itemId
                                                    itemSource: itemSource ];
}

-(SCItemSourcePOD*)contextSource
{
    return [ self.extendedApiSession contextSource ];
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
