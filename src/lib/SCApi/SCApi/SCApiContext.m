#import "SCApiContext.h"

#import "SCItemInfo.h"
#import "SCFieldRecord.h"
#import "SCApiUtils.h"
#import "SCRemoteApi.h"
#import "SCItemRecordsPage.h"

#import "SCEditItemsRequest.h"
#import "SCCreateItemRequest.h"

#import "SCHostLoginAndPassword.h"

#import "SCItemRecord.h"
#import "NSString+DefaultSitecoreLanguage.h"
#import "SCItemsReaderRequest+SCApiContext.h"
#import "SCItemsReaderRequest+Factory.h"
#import "SCItemsReaderRequest+SystemLanguages.h"
#import "SCCreateMediaItemRequest+ToItemsReadRequest.h"
#import "SCItemsCache+UnregisterItems.h"

#import "SCApiAnalizers.h"

@interface SCApiContext ()

@property ( nonatomic ) SCItemsCache* itemsCache;

@end

@implementation SCApiContext
{
    SCRemoteApi* _api;
}

@synthesize defaultLanguage              = _defaultLanguage;
@synthesize defaultDatabase              = _defaultDatabase;
@synthesize defaultLifeTimeInCache       = _defaultLifeTimeInCache;
@synthesize defaultImagesLifeTimeInCache = _defaultImagesLifeTimeInCache;
@synthesize systemLanguages              = _systemLanguages;
@synthesize itemsCache                   = _itemsCache;

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

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
{
    self = [ super init ];

    if ( self )
    {
        _api = [ [ SCRemoteApi alloc ] initWithHost: host_
                                              login: login_
                                           password: password_ ];
        _itemsCache = [ SCItemsCache new ];
    }

    return self;
}

+(id)contextWithHost:( NSString* )host_
               login:( NSString* )login_
            password:( NSString* )password_
{
    id key_ = [ [ SCHostLoginAndPassword alloc ] initWithHost: host_
                                                        login: login_
                                                     password: password_ ];

    static JFFMutableAssignDictionary* contextByHost_ = nil;
    if ( !contextByHost_ )
    {
        contextByHost_ = [ JFFMutableAssignDictionary new ];
    }
    id result_ = [ contextByHost_ objectForKey: key_ ];
    if ( !result_ )
    {
        result_ = [ [ self alloc ] initWithHost: host_
                                          login: login_
                                       password: password_ ];

        [ contextByHost_ setObject: result_ forKey: key_ ];
    }
    return result_;
}

+(id)contextWithHost:( NSString* )host_
{
    return [ self contextWithHost: host_
                            login: nil
                         password: nil ];
}

-(SCItem*)itemWithPath:( NSString* )path_
{
    SCItemInfo* info_ = [ SCItemInfo new ];
    info_.itemPath = path_;
    info_.language = self.defaultLanguage;
    SCItemRecord* itemRecord_ = [ self.itemsCache itemRecordWithItemInfo: info_ ];
    return itemRecord_.item;
}

-(SCItem*)itemWithId:( NSString* )itemId_
{
    SCItemInfo* info_ = [ SCItemInfo new ];
    info_.itemId   = itemId_;
    info_.language = self.defaultLanguage;
    SCItemRecord* itemRecord_ = [ self.itemsCache itemRecordWithItemInfo: info_ ];
    return itemRecord_.item;
}

-(JFFAsyncOperation)itemLoaderForItemId:( NSString* )itemId_
{
    return [ self itemLoaderWithFieldsNames: [ NSSet new ]
                                     itemId: itemId_ ];
}

-(SCAsyncOp)itemReaderForItemId:( NSString* )itemId_
{
    return [ self itemReaderWithFieldsNames: [ NSSet new ]
                                     itemId: itemId_ ];
}

-(SCAsyncOp)itemReaderForItemPath:( NSString* )path_
{
    return [ self itemReaderWithFieldsNames: [ NSSet new ]
                                   itemPath: path_ ];
}

-(JFFAsyncOperation)itemLoaderWithFieldsNames:( NSSet* )fieldNames_
                                       itemId:( NSString* )itemId_
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                  fieldsNames: fieldNames_ ];
    return firstItemFromArrayReader( [ self itemsLoaderWithRequest: request_ ] );
}

-(SCAsyncOp)itemReaderWithFieldsNames:( NSSet* )fieldNames
                               itemId:( NSString* )itemId
{
    return asyncOpWithJAsyncOp( [ self itemLoaderWithFieldsNames: fieldNames
                                                          itemId: itemId ] );
}

-(SCAsyncOp)itemReaderWithFieldsNames:( NSSet* )fieldNames_
                             itemPath:( NSString* )path_
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                    fieldsNames: fieldNames_ ];

    JFFAsyncOperation loader_ = [ self itemsLoaderWithRequest: request_ ];
    loader_ = firstItemFromArrayReader( loader_ );

    return asyncOpWithJAsyncOp( loader_ );
}

-(SCAsyncOp)childrenReaderWithItemPath:( NSString* )path_
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
    request_.request     = path_;
    request_.requestType = SCItemReaderRequestItemPath;
    request_.scope       = SCItemReaderChildrenScope;
    request_.fieldNames  = [ NSSet new ];
    return [ self itemsReaderWithRequest: request_ ];
}

- (SCAsyncOp)childrenReaderWithItemId:( NSString* )itemId_
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
    request_.request     = itemId_;
    request_.requestType = SCItemReaderRequestItemId;
    request_.scope       = SCItemReaderChildrenScope;
    request_.fieldNames  = [ NSSet new ];
    return [ self itemsReaderWithRequest: request_ ];
}

-(NSDictionary*)readFieldsByNameForItemId:( NSString* )itemId_
{
    JFFMutableAssignDictionary* dict_ = [ self.itemsCache readFieldsByNameForItemId: itemId_
                                                                           language: self.defaultLanguage ];
    return [ dict_ map: ^( id key_, SCFieldRecord* fieldRecord_ )
    {
        return fieldRecord_.field;
    } ];
}

-(SCField*)fieldWithName:( NSString* )fieldName_
                  itemId:( NSString* )itemId_
                language:( NSString* )language_
{
    SCFieldRecord* fieldRecord_ = [ self.itemsCache fieldWithName: fieldName_
                                                           itemId: itemId_
                                                         language: language_ ];
    return fieldRecord_.field;
}

-(SCField*)fieldWithName:( NSString* )fieldName_
                  itemId:( NSString* )itemId_
{
    return [ self fieldWithName: fieldName_
                         itemId: itemId_
                       language: self.defaultLanguage ];
}

-(JFFAsyncOperation)privateImageLoaderForSCMediaPath:( NSString* )path_
{
    return [ _api imageLoaderForSCMediaPath: path_
                              cacheLifeTime: self.defaultImagesLifeTimeInCache ];
}

-(SCAsyncOp)imageLoaderForSCMediaPath:( NSString* )path_
{
    return asyncOpWithJAsyncOp( [ self privateImageLoaderForSCMediaPath: path_ ] );
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

-(SCAsyncOp)itemCreatorWithRequest:( SCCreateItemRequest* )request_
{
    request_ = ( SCCreateItemRequest* )[ request_ itemsReaderRequestWithApiContext: self ];

    JFFAsyncOperation loader_ = [ _api itemCreatorWithRequest: request_
                                                   apiContext: self ];
    loader_ = [ self cachedItemsPageLoader: loader_
                                   request: request_ ];

    loader_ = validatedItemsPageLoaderWithFields( loader_, request_ );

    loader_ = itemPageToItems( loader_ );
    loader_ = firstItemFromArrayReader( loader_ );

    return asyncOpWithJAsyncOp( loader_ );
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

    loader_ = [ self.itemsCache unregisterItemsWithItemsIdsArrayLoader: loader_ ];

    loader_ = [ self asyncOperationMergeLoaders: loader_
                                   withArgument: request_ ];

    return [ request_ validatedLoader: loader_ ];
}

-(SCAsyncOp)removeItemsWithRequest:( SCItemsReaderRequest* )request_
{
    return asyncOpWithJAsyncOp( [ self removeItemsLoaderWithRequest: request_ ] );
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

-(SCAsyncOp)mediaItemCreatorWithRequest:( SCCreateMediaItemRequest* )createMediaItemRequest_
{
    JFFAsyncOperation loader_ = [ self mediaItemCreatLoaderWithRequest: createMediaItemRequest_ ];
    return asyncOpWithJAsyncOp( loader_ );
}

-(SCAsyncOp)editItemsWithRequest:( SCEditItemsRequest* )request_
{
    JFFAsyncOperation loader_ = [ self editItemsLoaderWithRequest: request_ ];
    return asyncOpWithJAsyncOp( loader_ );
}

-(JFFAsyncOperation)itemsLoaderWithRequest:( SCItemsReaderRequest* )request_
{
    JFFAsyncOperation loader_ = [ self privateItemsPageLoaderWithRequest: request_ ];
    return itemPageToItems( loader_ );
}

-(SCAsyncOp)itemsReaderWithRequest:( SCItemsReaderRequest* )request_
{
    return asyncOpWithJAsyncOp( [ self itemsLoaderWithRequest: request_ ] );
}

-(SCAsyncOp)systemLanguagesReader
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest systemLanguagesItemsReader ];

    JFFAsyncOperationBinder analyzeLanguagesBinder_ = itemRecordsPageToLanguageSet();

    JFFAsyncOperation loader_ = [ self itemRecordLoaderForRequest: request_ ];
    loader_ = bindSequenceOfAsyncOperations( loader_, analyzeLanguagesBinder_, nil );
    loader_ = [ self asyncOperationForPropertyWithName: @"systemLanguages"
                                        asyncOperation: loader_ ];

    return asyncOpWithJAsyncOp( loader_ );
}

-(SCAsyncOp)renderingHTMLLoaderForRenderingWithId:(NSString *)renderingId_
                                         sourceId:(NSString *)sourceId_
{
    JFFAsyncOperation loader_ = [ _api renderingHTMLLoaderForRenderingId: renderingId_
                                                                sourceId: sourceId_ 
                                                              apiContext: self ];

    JFFAsyncOperationBinder binder_ = ^JFFAsyncOperation( NSArray* ids_ )
    {
        return loader_;
    };

    NSArray* ids_ = [ NSArray arrayWithObjects: renderingId_?:@"", sourceId_?:@"", nil ];
    loader_ = asyncOpWithValidIds( binder_, ids_ );

    return asyncOpWithJAsyncOp( loader_ );
}

@end
