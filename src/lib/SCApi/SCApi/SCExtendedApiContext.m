#import "SCExtendedApiContext.h"

#import "SCItemInfo.h"
#import "SCFieldRecord.h"
#import "SCApiUtils.h"
#import "SCRemoteApi.h"
#import "SCItemRecordsPage.h"

#import "SCEditItemsRequest.h"
#import "SCCreateItemRequest.h"
#import "SCHTMLReaderRequest.h"
#import "SCHTMLReaderRequest+Factory.h"

#import "SCItemRecord.h"
#import "NSString+DefaultSitecoreLanguage.h"
#import "SCItemsReaderRequest+SCApiContext.h"
#import "SCItemsReaderRequest+Factory.h"
#import "SCItemsReaderRequest+SystemLanguages.h"
#import "SCItemsReaderRequest+SCItemSource.h"

#import "SCCreateMediaItemRequest+ToItemsReadRequest.h"

#import "SCApiAnalizers.h"
#import "SCTriggeringRequest.h"

#import "SCError.h"
#import "SCParams.h"

#import "SCFieldImageParams.h"
#import "SCItemSourcePOD.h"

#import "SCItemRecordCacheRW.h"
#import "SCMutableItemRecordCache.h"
#import "SCItemsCacheOperationsFactory.h"


@interface SCExtendedApiContext ()

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;
@property ( nonatomic ) SCRemoteApi * api;
@property ( nonatomic ) NSNotificationCenter* notificationCenter;

@end

@implementation SCExtendedApiContext
{
    id _memoryWarningObserver;
}

@dynamic host;

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

-(SCExtendedAsyncOp)itemReaderForItemId:( NSString* )itemId
                             itemSource:(id<SCItemSource>)itemSource
{
    return [ self itemReaderWithFieldsNames: [ NSSet new ]
                                     itemId: itemId
                                 itemSource: itemSource ];
}

-(SCExtendedAsyncOp)itemReaderForItemPath:( NSString* )path
                               itemSource:(id<SCItemSource>)itemSource
{
    return [ self itemReaderWithFieldsNames: [ NSSet new ]
                                   itemPath: path
                                 itemSource: itemSource ];
}

-(JFFAsyncOperation)itemLoaderWithFieldsNames:( NSSet* )fieldNames
                                   itemSource:( id<SCItemSource> )itemSource
                                       itemId:( NSString* )itemId
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId
                                                                  fieldsNames: fieldNames ];

    SCItemSourcePOD* itemSourcePOD = [ itemSource toPlainStructure ];
    [ itemSourcePOD fillRequestParameters:request_ ];
    
    return firstItemFromArrayReader( [ self itemsLoaderWithRequest: request_ ] );
}

-(SCExtendedAsyncOp)itemReaderWithFieldsNames:( NSSet* )fieldNames
                                       itemId:( NSString* )itemId
                                   itemSource:( id<SCItemSource> )itemSource
{
    return [ self itemLoaderWithFieldsNames: fieldNames
                                 itemSource: itemSource
                                     itemId: itemId ];
}

-(SCExtendedAsyncOp)itemReaderWithFieldsNames:( NSSet* )fieldNames_
                                     itemPath:( NSString* )path_
                                   itemSource:(id<SCItemSource>)itemSource
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                    fieldsNames: fieldNames_ ];

    SCItemSourcePOD* itemSourcePOD = [ itemSource toPlainStructure ];
    [ itemSourcePOD fillRequestParameters:request_ ];

    
    JFFAsyncOperation loader_ = [ self itemsLoaderWithRequest: request_ ];
    loader_ = firstItemFromArrayReader( loader_ );

    return loader_;
}

-(SCExtendedAsyncOp)childrenReaderWithItemPath:( NSString* )path_
                                    itemSource:(id<SCItemSource>)itemSource
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
    request_.request     = path_;
    request_.requestType = SCItemReaderRequestItemPath;
    request_.scope       = SCItemReaderChildrenScope;
    request_.fieldNames  = [ NSSet new ];
    
    SCItemSourcePOD* plainSource = [ itemSource toPlainStructure ];
    [ plainSource fillRequestParameters: request_ ];
    
    return [ self itemsReaderWithRequest: request_ ];
}

-(SCExtendedAsyncOp)childrenReaderWithItemId:( NSString* )itemId_
                                  itemSource:(id<SCItemSource>)itemSource
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
    request_.request     = itemId_;
    request_.requestType = SCItemReaderRequestItemId;
    request_.scope       = SCItemReaderChildrenScope;
    request_.fieldNames  = [ NSSet new ];
    
    SCItemSourcePOD* plainSource = [ itemSource toPlainStructure ];
    [ plainSource fillRequestParameters: request_ ];
    
    return [ self itemsReaderWithRequest: request_ ];
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
                                              params:( SCFieldImageParams* )params
{
    params.database =  params.database ? : self.defaultDatabase;
    params.language =  params.language ? : self.defaultLanguage;

    return [ self->_api imageLoaderForSCMediaPath: path_
                                    cacheLifeTime: self.defaultImagesLifeTimeInCache
                                           params: params ];
}

-(JFFAsyncOperation)privateImageLoaderForSCMediaPath:( NSString* )path_
{
    return [ self privateImageLoaderForSCMediaPath: path_ params: nil ];
}

-(SCExtendedAsyncOp)imageLoaderForSCMediaPath:( NSString* )path_
{
    return [ self imageLoaderForSCMediaPath: path_
                         imageParams: nil ];
}

-(SCExtendedAsyncOp)imageLoaderForSCMediaPath:( NSString* )path_
                           imageParams:( SCFieldImageParams* )params_
{
    return [ self privateImageLoaderForSCMediaPath: path_
                                            params: params_ ];
}

-(JFFAsyncOperation)cachedItemsPageLoader:( JFFAsyncOperation )loader_
                                  request:( SCItemsReaderRequest* )request_
{
    JFFAnalyzer analyzer_ = ^id( SCItemRecordsPage* result_, NSError **error_ )
    {
        if ( result_ )
        {
            [ self.itemsCache cacheResponseItems: result_.itemRecords
                                      forRequest: request_
                                      apiContext: self ];
        };
        return result_;
    };
    JFFAsyncOperationBinder cacher_ = asyncOperationBinderWithAnalyzer( analyzer_ );

    return bindSequenceOfAsyncOperations( loader_, cacher_, nil );
}

-(JFFAsyncOperation)itemRecordLoaderForRequest:( SCItemsReaderRequest* )request_
{
    JFFAsyncOperation loader_ = [ self->_api itemsReaderWithRequest: request_
                                                         apiContext: self ];
    return [ self cachedItemsPageLoader: loader_
                                request: request_ ];
}

static JFFAsyncOperation validatedItemsPageLoaderWithFields( JFFAsyncOperation loader_
                                                            , SCItemsReaderRequest* request_ )
{
    loader_ = itemRecordsPageToItemsPage( loader_ );
    loader_ = [ request_ asyncOpWithFieldsForAsyncOp: loader_ ];
    return [ request_ validatedLoader: loader_ ];
}

-(JFFAsyncOperation)privateItemsPageLoaderWithRequest:( SCItemsReaderRequest* )request_
{
    request_ = [ request_ itemsReaderRequestWithApiContext: self ];

    JFFAsyncOperation loader_ = [ self itemRecordLoaderForRequest: request_ ];

    loader_ = validatedItemsPageLoaderWithFields( loader_, request_ );

    return [ self asyncOperationMergeLoaders: loader_
                                withArgument: request_ ];
}

-(SCExtendedAsyncOp)itemCreatorWithRequest:( SCCreateItemRequest* )request_
{
    request_ = ( SCCreateItemRequest* )[ request_ itemsReaderRequestWithApiContext: self ];

    JFFAsyncOperation loader_ = [ self->_api itemCreatorWithRequest: request_
                                                         apiContext: self ];
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
    request_ = ( SCEditItemsRequest* )[ request_ itemsReaderRequestWithApiContext: self ];

    JFFAsyncOperation loader_ = [ _api editItemsLoaderWithRequest: request_
                                                       apiContext: self ];

    loader_ = [ self cachedItemsPageLoader: loader_
                                   request: request_ ];

    loader_ = validatedItemsPageLoaderWithFields( loader_, request_ );

    return itemPageToItems( loader_ );
}

-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCItemsReaderRequest* )request_
{
    request_ = [ request_ itemsReaderRequestWithApiContext: self ];

    JFFAsyncOperation loader_ = [ self->_api removeItemsLoaderWithRequest: request_
                                                               apiContext: self ];

    
    
    loader_ = [ SCItemsCacheOperationsFactory unregisterItemsWithItemsIdsArrayLoader: loader_
                                                                           fromCache: self.itemsCache
                                                                      fromItemSource: request_ ];


    loader_ = [ self asyncOperationMergeLoaders: loader_
                                   withArgument: request_ ];

    return [ request_ validatedLoader: loader_ ];
}

-(SCExtendedAsyncOp)removeItemsWithRequest:( SCItemsReaderRequest* )request_
{
    return [ self removeItemsLoaderWithRequest: request_ ];
}

-(JFFAsyncOperation)mediaItemCreatLoaderWithRequest:( SCCreateMediaItemRequest* )createMediaItemRequest_
{
    JFFAsyncOperation loader_ = [ self->_api mediaItemCreatorWithRequest: createMediaItemRequest_
                                                              apiContext: self ];

    SCItemsReaderRequest* request_ = [ createMediaItemRequest_ toItemsReadRequestWithApiContext: self ];
    loader_ = [ self cachedItemsPageLoader: loader_
                                   request: request_ ];

    loader_ = itemRecordsPageToItemsPage( loader_ );
    loader_ = itemPageToItems( loader_ );
    return firstItemFromArrayReader( loader_ );
}

-(SCExtendedAsyncOp)mediaItemCreatorWithRequest:( SCCreateMediaItemRequest* )createMediaItemRequest_
{
    createMediaItemRequest_.language = createMediaItemRequest_.language ?: self.defaultLanguage;
    createMediaItemRequest_.database = createMediaItemRequest_.database ?: self.defaultDatabase;
    createMediaItemRequest_.site     = createMediaItemRequest_.site     ?: self.defaultSite    ;
    createMediaItemRequest_.itemVersion = createMediaItemRequest_.itemVersion ?: self.defaultItemVersion;
    
    
    JFFAsyncOperation loader_ = [ self mediaItemCreatLoaderWithRequest: createMediaItemRequest_ ];
    return loader_;
}

-(SCExtendedAsyncOp)editItemsWithRequest:( SCEditItemsRequest* )request_
{
    JFFAsyncOperation loader_ = [ self editItemsLoaderWithRequest: request_ ];
    return loader_;
}

-(JFFAsyncOperation)itemsLoaderWithRequest:( SCItemsReaderRequest* )request_
{
    JFFAsyncOperation loader_ = [ self privateItemsPageLoaderWithRequest: request_ ];
    return itemPageToItems( loader_ );
}

-(SCExtendedAsyncOp)itemsReaderWithRequest:( SCItemsReaderRequest* )request_
{
    return [ self itemsLoaderWithRequest: request_ ];
}

-(SCExtendedAsyncOp)credentialsCheckerForSite:( NSString* )site
{
    return [ self->_api credentialsCheckerForSite: site ];
}

-(SCExtendedAsyncOp)systemLanguagesReader
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest systemLanguagesItemsReader ];
    request_ = [ request_ itemsReaderRequestWithApiContext: self ];
    
    JFFAsyncOperationBinder analyzeLanguagesBinder_ = itemRecordsPageToLanguageSet();

    JFFAsyncOperation loader_ = [ self itemRecordLoaderForRequest: request_ ];
    loader_ = bindSequenceOfAsyncOperations( loader_, analyzeLanguagesBinder_, nil );
    loader_ = [ self asyncOperationForPropertyWithName: @"systemLanguages"
                                        asyncOperation: loader_ ];

    return loader_;
}

-(SCExtendedAsyncOp)renderingHTMLReaderWithRequest:(SCHTMLReaderRequest *)request
{
    request = [ request htmlRenderingReaderRequestWithApiContext: self ];

    JFFAsyncOperation loader_ = [ self->_api renderingHTMLLoaderForRequest: request
                                                                apiContext: self ];

    
    
    JFFAsyncOperationBinder binder_ = ^JFFAsyncOperation( NSArray* ids_ )
    {
        return loader_;
    };
    
    NSArray* ids_ = @[ request.renderingId ?:@"", request.sourceId ?:@"" ];
    loader_ = asyncOpWithValidIds( binder_, ids_ );
    
    return loader_ ;

}

-(SCExtendedAsyncOp)renderingHTMLLoaderForRenderingWithId:( NSString* )renderingId_
                                                 sourceId:( NSString* )sourceId_
{
    
    SCHTMLReaderRequest * request = [ SCHTMLReaderRequest new ];
    request.renderingId = renderingId_;
    request.sourceId = sourceId_;
    
    return [ self renderingHTMLReaderWithRequest: request ];
}


-(JFFAsyncOperation)privateTriggerLoaderForRequest:( SCTriggeringRequest* )request_
{
    return [ _api triggerLoaderWithRequest: request_ ];
}

-(SCExtendedAsyncOp)triggerLoaderForRequest:( SCTriggeringRequest* )request_
{
    return [ self privateTriggerLoaderForRequest: request_ ];
}

-(SCRemoteApi *)getApi
{
    return self->_api;
}

-(void)setMainContext:(SCApiContext *)mainContext
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
