#import "SCExtendedApiSession.h"

#import "SCItemInfo.h"
#import "SCFieldRecord.h"
#import "SCApiUtils.h"
#import "SCRemoteApi.h"
#import "SCItemRecordsPage.h"

#import "SCEditItemsRequest.h"
#import "SCCreateItemRequest.h"
#import "SCGetRenderingHtmlRequest.h"
#import "SCGetRenderingHtmlRequest+Factory.h"

#import "SCItemRecord.h"
#import "NSString+DefaultSitecoreLanguage.h"
#import "SCReadItemsRequest+SCApiSession.h"
#import "SCReadItemsRequest+Factory.h"
#import "SCReadItemsRequest+SystemLanguages.h"
#import "SCReadItemsRequest+SCItemSource.h"

#import "SCUploadMediaItemRequest+ToItemsReadRequest.h"

#import "SCApiAnalizers.h"
#import "SCTriggeringRequest.h"

#import "SCError.h"
#import "SCParams.h"

#import "SCDownloadMediaOptions.h"
#import "SCItemSourcePOD.h"

#import "SCItemRecordCacheRW.h"
#import "SCMutableItemRecordCache.h"
#import "SCItemsCacheOperationsFactory.h"


@interface SCExtendedApiSession ()

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;
@property ( nonatomic ) SCRemoteApi * api;
@property ( nonatomic ) NSNotificationCenter* notificationCenter;

@end

@implementation SCExtendedApiSession
{
    id _memoryWarningObserver;
    
    NSLocale* _posixLocale;
    dispatch_once_t _posixLocaleToken;
}

@dynamic host;
@synthesize mediaLibraryPath = _mediaLibraryPath;

-(void)dealloc
{
    id<SCMutableItemRecordCache> cache = self->_itemsCache;
    [ cache cleanupAll ];
    
    [ self unSubscribeFromMemoryWarningNotification ];
}

-(id)init
{
    NSAssert( NO, @"don't call this method" );
    return [ super init ];
}

-(NSString*)defaultLanguage
{
    if ( !_defaultLanguage )
    {
        _defaultLanguage = [ NSString defaultSitecoreLanguage ];
    }
    return _defaultLanguage;
}

-(NSString*)defaultDatabase
{
    if ( !_defaultDatabase )
    {
        _defaultDatabase = [ NSString defaultSitecoreDatabase ];
    }
    return _defaultDatabase;
}

-(NSLocale*)lazyPosixLocale
{
    dispatch_once( &self->_posixLocaleToken, ^void()
    {
        self->_posixLocale = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    });
    
    return self->_posixLocale;
}

-(void)setMediaLibraryPath:(NSString *)mediaLibraryPath
{
    NSParameterAssert( nil == self->_mediaLibraryPath );
    
    NSLocale* posixLocale = [ self lazyPosixLocale ];
    NSString* newPath = [ mediaLibraryPath uppercaseStringWithLocale: posixLocale ];
    
    self->_mediaLibraryPath = newPath;
}

-(NSString*)mediaLibraryPath
{
    if ( nil == self->_mediaLibraryPath )
    {
        return [ [ self class ] defaultMediaLibraryPath ];
    }

    return self->_mediaLibraryPath;
}

+(NSString*)defaultMediaLibraryPath
{
    return @"/SITECORE/MEDIA LIBRARY";
}

-(NSTimeInterval)defaultLifeTimeInCache
{
    if ( !_defaultLifeTimeInCache )
    {
        _defaultLifeTimeInCache = 10.*60.0;
    }
    return _defaultLifeTimeInCache;
}

-(NSTimeInterval)defaultImagesLifeTimeInCache
{
    if ( !_defaultImagesLifeTimeInCache )
    {
        _defaultImagesLifeTimeInCache = 60*60*24*30;
    }
    return _defaultImagesLifeTimeInCache;
}

-(void)cleanupItemsCache
{
    [ self->_itemsCache cleanupAll ];
}

-(SCItemSourcePOD*)contextSource
{
    SCItemSourcePOD* result = [ SCItemSourcePOD new ];
    {
        result.language    = self.defaultLanguage;
        result.database    = self.defaultDatabase;
        result.site        = self.defaultSite    ;
        result.itemVersion = nil; // @adk : get the latest one
    }
    
    return result;
}

-(SCItem*)itemWithPath:( NSString* )path
            itemSource:(id<SCItemSource>)itemSource
{
    SCItemRecord* itemRecord = [ self.itemsCache itemRecordForItemWithPath: path
                                                                itemSource: itemSource ];
    return itemRecord.item;
}

-(SCItem*)itemWithId:( NSString* )itemId
          itemSource:(id<SCItemSource>)itemSource
{
    SCItemRecord* itemRecord = [ self.itemsCache itemRecordForItemWithId: itemId
                                                              itemSource: itemSource ];

    return itemRecord.item;
}

-(JFFAsyncOperation)itemLoaderForItemId:( NSString* )itemId
                             itemSource:(id<SCItemSource>)itemSource
{
    return [ self itemLoaderWithFieldsNames: [ NSSet new ]
                                 itemSource: itemSource
                                     itemId: itemId ];
}

-(SCExtendedAsyncOp)readItemOperationForItemId:( NSString* )itemId
                             itemSource:(id<SCItemSource>)itemSource
{
    return [ self readItemOperationForFieldsNames: [ NSSet new ]
                                     itemId: itemId
                                 itemSource: itemSource ];
}

-(SCExtendedAsyncOp)readItemOperationForItemPath:( NSString* )path
                               itemSource:(id<SCItemSource>)itemSource
{
    return [ self readItemOperationForFieldsNames: [ NSSet new ]
                                   itemPath: path
                                 itemSource: itemSource ];
}

-(JFFAsyncOperation)itemLoaderWithFieldsNames:( NSSet* )fieldNames
                                   itemSource:( id<SCItemSource> )itemSource
                                       itemId:( NSString* )itemId
{
    SCReadItemsRequest * request_ = [SCReadItemsRequest requestWithItemId:itemId
                                                              fieldsNames:fieldNames];

    SCItemSourcePOD* itemSourcePOD = [ itemSource toPlainStructure ];
    [ itemSourcePOD fillRequestParameters:request_ ];
    
    return firstItemFromArrayReader( [ self itemsLoaderWithRequest: request_ ] );
}

-(SCExtendedAsyncOp)readItemOperationForFieldsNames:( NSSet* )fieldNames
                                       itemId:( NSString* )itemId
                                   itemSource:( id<SCItemSource> )itemSource
{
    return [ self itemLoaderWithFieldsNames: fieldNames
                                 itemSource: itemSource
                                     itemId: itemId ];
}

-(SCExtendedAsyncOp)readItemOperationForFieldsNames:( NSSet* )fieldNames_
                                     itemPath:( NSString* )path_
                                   itemSource:(id<SCItemSource>)itemSource
{
    SCReadItemsRequest * request_ = [SCReadItemsRequest requestWithItemPath:path_
                                                                fieldsNames:fieldNames_];

    SCItemSourcePOD* itemSourcePOD = [ itemSource toPlainStructure ];
    [ itemSourcePOD fillRequestParameters:request_ ];

    
    JFFAsyncOperation loader_ = [ self itemsLoaderWithRequest: request_ ];
    loader_ = firstItemFromArrayReader( loader_ );

    return loader_;
}

-(SCExtendedAsyncOp)readChildrenOperationForItemPath:( NSString* )path_
                                    itemSource:(id<SCItemSource>)itemSource
{
    SCReadItemsRequest * request_ = [SCReadItemsRequest new];
    request_.request     = path_;
    request_.requestType = SCReadItemRequestItemPath;
    request_.scope       = SCReadItemChildrenScope;
    request_.fieldNames  = [ NSSet new ];
    
    SCItemSourcePOD* plainSource = [ itemSource toPlainStructure ];
    [ plainSource fillRequestParameters: request_ ];
    
    return [ self readItemsOperationWithRequest: request_ ];
}

-(SCExtendedAsyncOp)readChildrenOperationForItemId:( NSString* )itemId_
                                  itemSource:(id<SCItemSource>)itemSource
{
    SCReadItemsRequest * request_ = [SCReadItemsRequest new];
    request_.request     = itemId_;
    request_.requestType = SCReadItemRequestItemId;
    request_.scope       = SCReadItemChildrenScope;
    request_.fieldNames  = [ NSSet new ];
    
    SCItemSourcePOD* plainSource = [ itemSource toPlainStructure ];
    [ plainSource fillRequestParameters: request_ ];
    
    return [ self readItemsOperationWithRequest: request_ ];
}

-(NSDictionary*)readFieldsByNameForItemId:( NSString* )itemId_
                               itemSource:(id<SCItemSource>)itemSource
{
    return [ self.itemsCache cachedFieldsByNameForItemId: itemId_
                                              itemSource: itemSource ];
}

-(SCField*)fieldWithName:( NSString* )fieldName
                  itemId:( NSString* )itemId
                itemSource:(id<SCItemSource>)itemSource
{
    SCFieldRecord* fieldRecord = [ self.itemsCache fieldWithName: fieldName
                                                          itemId: itemId
                                                      itemSource: itemSource ];
    return fieldRecord.field;
}

-(JFFAsyncOperation)privateImageLoaderForSCMediaPath:( NSString* )path_
                                              params:( SCDownloadMediaOptions * )params
{
    params.database =  params.database ? : self.defaultDatabase;
    params.language =  params.language ? : self.defaultLanguage;

    return [ self->_api uploadOperationForSCMediaPath: path_
                                    cacheLifeTime: self.defaultImagesLifeTimeInCache
                                           params: params ];
}

-(JFFAsyncOperation)privateImageLoaderForSCMediaPath:( NSString* )path_
{
    return [ self privateImageLoaderForSCMediaPath: path_ params: nil ];
}

-(SCExtendedAsyncOp)uploadOperationForSCMediaPath:( NSString* )path_
{
    return [ self uploadOperationForSCMediaPath: path_
                         imageParams: nil ];
}

-(SCExtendedAsyncOp)uploadOperationForSCMediaPath:( NSString* )path_
                           imageParams:( SCDownloadMediaOptions * )params_
{
    return [ self privateImageLoaderForSCMediaPath: path_
                                            params: params_ ];
}

-(JFFAsyncOperation)cachedItemsPageLoader:( JFFAsyncOperation )loader_
                                  request:( SCReadItemsRequest * )request_
{
    JFFAnalyzer analyzer_ = ^id( SCItemRecordsPage* result_, NSError **error_ )
    {
        if ( result_ )
        {
            [ self.itemsCache cacheResponseItems: result_.itemRecords
                                      forRequest: request_
                                      apiSession: self ];
        };
        return result_;
    };
    JFFAsyncOperationBinder cacher_ = asyncOperationBinderWithAnalyzer( analyzer_ );

    return bindSequenceOfAsyncOperations( loader_, cacher_, nil );
}

-(JFFAsyncOperation)itemRecordLoaderForRequest:( SCReadItemsRequest * )request_
{
    JFFAsyncOperation loader_ = [ self->_api readItemsOperationWithRequest: request_
                                                         apiSession: self ];
    return [ self cachedItemsPageLoader: loader_
                                request: request_ ];
}

static JFFAsyncOperation validatedItemsPageLoaderWithFields( JFFAsyncOperation loader_
                                                            , SCReadItemsRequest * request_ )
{
    loader_ = itemRecordsPageToItemsPage( loader_ );
    loader_ = [ request_ asyncOpWithFieldsForAsyncOp: loader_ ];
    return [ request_ validatedLoader: loader_ ];
}

-(JFFAsyncOperation)privateItemsPageLoaderWithRequest:( SCReadItemsRequest * )request_
{
    request_ = [ request_ itemsReaderRequestWithApiSession: self ];

    JFFAsyncOperation loader_ = [ self itemRecordLoaderForRequest: request_ ];

    loader_ = validatedItemsPageLoaderWithFields( loader_, request_ );

    return [ self asyncOperationMergeLoaders: loader_
                                withArgument: request_ ];
}

-(SCExtendedAsyncOp)createItemsOperationWithRequest:( SCCreateItemRequest* )request_
{
    request_ = ( SCCreateItemRequest* )[ request_ itemsReaderRequestWithApiSession: self ];

    JFFAsyncOperation loader_ = [ self->_api createItemsOperationWithRequest: request_
                                                         apiSession: self ];
    loader_ = [ self cachedItemsPageLoader: loader_
                                   request: request_ ];

    loader_ = validatedItemsPageLoaderWithFields( loader_, request_ );

    loader_ = itemPageToItems( loader_ );
    loader_ = firstItemFromArrayReader( loader_ );

    loader_ = asyncOperationWithChangedError( loader_, ^NSError *(NSError *error)
    {
        SCCreateItemError* newError =
        [ [ SCCreateItemError alloc ] initWithDescription: @"Item not created"
                                                     code: 1 ];
        newError.underlyingError = error;
        
        return newError;
    });
    
    return loader_;
}

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )request_
{
    request_ = ( SCEditItemsRequest* )[ request_ itemsReaderRequestWithApiSession: self ];

    JFFAsyncOperation loader_ = [ _api editItemsLoaderWithRequest: request_
                                                       apiSession: self ];

    loader_ = [ self cachedItemsPageLoader: loader_
                                   request: request_ ];

    loader_ = validatedItemsPageLoaderWithFields( loader_, request_ );

    return itemPageToItems( loader_ );
}

-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCReadItemsRequest * )request_
{
    request_ = [ request_ itemsReaderRequestWithApiSession: self ];

    JFFAsyncOperation loader_ = [ self->_api removeItemsLoaderWithRequest: request_
                                                               apiSession: self ];

    
    
    loader_ = [ SCItemsCacheOperationsFactory unregisterItemsWithItemsIdsArrayLoader: loader_
                                                                           fromCache: self.itemsCache
                                                                      fromItemSource: request_ ];


    loader_ = [ self asyncOperationMergeLoaders: loader_
                                   withArgument: request_ ];

    return [ request_ validatedLoader: loader_ ];
}

-(SCExtendedAsyncOp)deleteItemsOperationWithRequest:( SCReadItemsRequest * )request_
{
    return [ self removeItemsLoaderWithRequest: request_ ];
}

-(JFFAsyncOperation)mediaItemCreatLoaderWithRequest:( SCUploadMediaItemRequest * )createMediaItemRequest_
{
    JFFAsyncOperation loader_ = [ self->_api uploadMediaOperationWithRequest: createMediaItemRequest_
                                                              apiSession: self ];

    SCReadItemsRequest * request_ = [ createMediaItemRequest_ toItemsReadRequestWithApiSession: self ];
    loader_ = [ self cachedItemsPageLoader: loader_
                                   request: request_ ];

    loader_ = itemRecordsPageToItemsPage( loader_ );
    loader_ = itemPageToItems( loader_ );
    return firstItemFromArrayReader( loader_ );
}

-(SCExtendedAsyncOp)uploadMediaOperationWithRequest:( SCUploadMediaItemRequest * )createMediaItemRequest_
{
    createMediaItemRequest_.language = createMediaItemRequest_.language ?: self.defaultLanguage;
    createMediaItemRequest_.database = createMediaItemRequest_.database ?: self.defaultDatabase;
    createMediaItemRequest_.site     = createMediaItemRequest_.site     ?: self.defaultSite    ;
    createMediaItemRequest_.itemVersion = createMediaItemRequest_.itemVersion ?: self.defaultItemVersion;
    
    
    JFFAsyncOperation loader_ = [ self mediaItemCreatLoaderWithRequest: createMediaItemRequest_ ];
    return loader_;
}

-(SCExtendedAsyncOp)editItemsOperationWithRequest:( SCEditItemsRequest* )request_
{
    JFFAsyncOperation loader_ = [ self editItemsLoaderWithRequest: request_ ];
    return loader_;
}

-(JFFAsyncOperation)itemsLoaderWithRequest:( SCReadItemsRequest * )request_
{
    JFFAsyncOperation loader_ = [ self privateItemsPageLoaderWithRequest: request_ ];
    return itemPageToItems( loader_ );
}

-(SCExtendedAsyncOp)readItemsOperationWithRequest:( SCReadItemsRequest * )request_
{
    return [ self itemsLoaderWithRequest: request_ ];
}

-(SCExtendedAsyncOp)checkCredentialsOperationForSite:( NSString* )site
{
    return [ self->_api checkCredentialsOperationForSite: site ];
}

-(SCExtendedAsyncOp)readSystemLanguagesOperation
{
    SCReadItemsRequest * request_ = [SCReadItemsRequest systemLanguagesItemsReader];
    request_ = [ request_ itemsReaderRequestWithApiSession: self ];
    
    JFFAsyncOperationBinder analyzeLanguagesBinder_ = itemRecordsPageToLanguageSet();

    JFFAsyncOperation loader_ = [ self itemRecordLoaderForRequest: request_ ];
    loader_ = bindSequenceOfAsyncOperations( loader_, analyzeLanguagesBinder_, nil );
    loader_ = [ self asyncOperationForPropertyWithName: @"systemLanguages"
                                        asyncOperation: loader_ ];

    return loader_;
}

-(SCExtendedAsyncOp)getRenderingHtmlOperationWithRequest:(SCGetRenderingHtmlRequest *)request
{
    request = [ request htmlRenderingReaderRequestWithApiSession: self ];

    JFFAsyncOperation loader_ = [ self->_api renderingHTMLLoaderForRequest: request
                                                                apiSession: self ];

    
    
    JFFAsyncOperationBinder binder_ = ^JFFAsyncOperation( NSArray* ids_ )
    {
        return loader_;
    };
    
    NSArray* ids_ = @[ request.renderingId ?:@"", request.sourceId ?:@"" ];
    loader_ = asyncOpWithValidIds( binder_, ids_ );
    
    return loader_ ;

}

-(SCExtendedAsyncOp)getRenderingHtmlOperationForRenderingWithId:( NSString* )renderingId_
                                                 sourceId:( NSString* )sourceId_
{
    
    SCGetRenderingHtmlRequest * request = [SCGetRenderingHtmlRequest new];
    request.renderingId = renderingId_;
    request.sourceId = sourceId_;
    
    return [ self getRenderingHtmlOperationWithRequest: request ];
}


-(JFFAsyncOperation)privateTriggerLoaderForRequest:( SCTriggeringRequest* )request_
{
    return [ _api triggerLoaderWithRequest: request_ ];
}

-(SCExtendedAsyncOp)triggerOperationWithRequest:( SCTriggeringRequest* )request_
{
    return [ self privateTriggerLoaderForRequest: request_ ];
}

-(SCRemoteApi *)getApi
{
    return self->_api;
}

-(void)setMainContext:(SCApiSession *)mainContext
{
    self->_mainContext = mainContext;
}

#pragma mark - 
#pragma mark Memory warning
-(void)subscribeToMemoryWarningNotification
{
    id<SCMutableItemRecordCache> cache = self->_itemsCache;
    void(^OnMemoryWarningBlock)(NSNotification*) = ^void( NSNotification *note )
    {
        [ cache cleanupAll ];
    };
    
    self->_memoryWarningObserver = [ [ self notificationCenter ] addObserverForName: UIApplicationDidReceiveMemoryWarningNotification
                                                                             object: nil
                                                                              queue: [ NSOperationQueue currentQueue ]
                                                                         usingBlock: OnMemoryWarningBlock ];
}

-(void)unSubscribeFromMemoryWarningNotification
{
    [ [ self notificationCenter ] removeObserver: self->_memoryWarningObserver ];
    self->_memoryWarningObserver = nil;
}

#pragma mark -
#pragma mark @dynamic
-(NSString*)host
{
    return [ self->_api host ];
}


@end
