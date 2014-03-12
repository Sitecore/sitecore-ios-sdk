#import "SCItem.h"

#import "SCImageField.h"

#import "SCError.h"
#import "SCItemRecord.h"
#import "SCApiSession.h"
#import "SCExtendedApiSession.h"

#import "SCEditItemsRequest.h"
#import "SCReadItemsRequest.h"
#import "SCDownloadMediaOptions.h"

#import "SCApiUtils.h"

#import "SCApiAnalizers.h"

#import "NSString+ItemPathLogic.h"
#import "NSDictionary+FieldsRawFaluesByName.h"

#import "SCItemSourcePOD.h"
#import "SCItemRecord+SCItemSource.h"

#import "SCApiMacro.h"
#import <SitecoreMobileSDK/SCAsyncOpRelationsBuilder.h>

@interface SCExtendedApiSession (SCItem)

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;

-(JFFAsyncOperation)itemsLoaderWithRequest:( SCReadItemsRequest * )request_;
-(SCField*)fieldWithName:( NSString* )fieldName_
                  itemId:( NSString* )itemId_
                language:( NSString* )language_;

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )editItemsRequest_;
-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCReadItemsRequest * )request_;

@end

@interface SCApiError (SCItem)

+ (id)errorWithDescription:(NSString *)description;

@end

@interface SCItemRecord (SCItem)

-(SCItem*)parent;

@end

@interface SCItem ()

@property ( nonatomic ) SCItemRecord* record;
@property ( nonatomic, readonly ) NSMutableSet* lazyFieldNamesToChange;
@property ( nonatomic ) NSMutableSet* fieldNamesToChange;

@end

@implementation SCItem
{
    SCItemRecord* _record;
    SCExtendedApiSession* _apiSession;
    SCApiSession *_mainApiSession;
    
    SCItemSourcePOD *_itemSourcePOD;
}

@dynamic displayName
, path
, hasChildren
, itemId
, itemTemplate
, longID
, language
, lazyFieldNamesToChange;

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithRecord:( SCItemRecord* )record_
         apiSession:( SCExtendedApiSession* )apiSession_
{
    self = [ super init ];

    if ( self )
    {
        self->_record     = record_;
        self->_apiSession = apiSession_;
        self->_mainApiSession = apiSession_.mainContext;
        
        self->_itemSourcePOD = [ SCItemSourcePOD new ];
        
        [ self fillPodWithRecord: record_
                      apiSession: apiSession_ ];
    }

    return self;
}

-(void)fillPodWithRecord:( SCItemRecord* )record_
              apiSession:( SCExtendedApiSession* )apiSession_
{
    self->_itemSourcePOD.database = record_.itemSource.database;
    if ( self->_itemSourcePOD.database == nil)
    {
        self->_itemSourcePOD.database = apiSession_.defaultDatabase;
    }
    
    self->_itemSourcePOD.language = record_.itemSource.language;
    if ( self->_itemSourcePOD.language == nil)
    {
        self->_itemSourcePOD.language = apiSession_.defaultLanguage;
    }
    
    self->_itemSourcePOD.site = record_.itemSource.site;
    if ( self->_itemSourcePOD.site == nil)
    {
        self->_itemSourcePOD.site = apiSession_.defaultSite;
    }
    
    self->_itemSourcePOD.itemVersion = record_.itemSource.itemVersion;
    if ( self->_itemSourcePOD.itemVersion == nil)
    {
        self->_itemSourcePOD.itemVersion = apiSession_.defaultItemVersion;
    }
}

+(id)itemWithRecord:( SCItemRecord* )record_
         apiSession:( SCExtendedApiSession* )apiSession_
{
    return [ [ self alloc ] initWithRecord: record_
                                apiSession: apiSession_ ];
}

+(id)rootItemWithApiSession:( SCExtendedApiSession* )apiSession_
{
    return [ [ self alloc ] initWithRecord: [ SCItemRecord rootRecord ]
                                apiSession: apiSession_ ];
}

-(SCItem*)itemWithId:( NSString* )itemId_
{
    return [ self->_apiSession itemWithId: itemId_
                               itemSource: self->_record.itemSource ];
}

-(NSString*)description
{
    return [ [ NSString alloc ] initWithFormat: @"<SCItem displayName:\"%@\" template:\"%@\" hasChildren:\"%d\" path:\"%@\" >"
            , self.displayName
            , self.itemTemplate
            , self.hasChildren
            , self.path ];
}

-(NSMutableSet*)lazyFieldNamesToChange
{
    if ( !self->_fieldNamesToChange )
    {
        self->_fieldNamesToChange = [ NSMutableSet new ];
    }
    return self->_fieldNamesToChange;
}

-(SCExtendedApiSession*)apiSession
{
    return self->_apiSession;
}

-(id)forwardingTargetForSelector:( SEL )selector_
{
    return self->_record;
}

-(SCField*)fieldWithName:( NSString* )fieldName_
{
    NSLocale* posixLocale_ = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    NSString *uppercaseFieldName = [ fieldName_ uppercaseStringWithLocale:posixLocale_ ];
    SCFieldRecord* fieldRecord = [ self->_apiSession.itemsCache fieldWithName: uppercaseFieldName
                                                                       itemId: self->_record.itemId
                                                                   itemSource: self->_record.itemSource ];
    
    return fieldRecord.field;
}

-(id)fieldValueWithName:( NSString* )name_
{
    return [ [ self fieldWithName: name_ ] fieldValue ];
}

-(SCItem*)parent
{
    return self.record.parent;
}

-(NSDictionary*)allFieldsByName
{
    return [ self->_apiSession.itemsCache allFieldsByNameForItemId: self->_record.itemId
                                                        itemSource: self->_record.itemSource ];
}

-(NSDictionary*)readFieldsByName
{
    return [ self->_apiSession.itemsCache cachedFieldsByNameForItemId: self->_record.itemId
                                                           itemSource: self->_record.itemSource ];
}

-(SCAsyncOp)readChildrenOperation
{
    return asyncOpWithJAsyncOp( [ self readChildrenExtendedOperation ] );
}

-(SCExtendedAsyncOp)readChildrenExtendedOperation
{
    SCReadItemsRequest * request = [SCReadItemsRequest requestWithItemId:self.itemId
                                                             fieldsNames:[NSSet new]
                                                                   scope:SCReadItemChildrenScope];
    [ self->_itemSourcePOD fillRequestParameters: request ];
    
    return [ _apiSession readItemsOperationWithRequest: request ];
}

-(JFFAsyncOperation)fieldsLoaderForFieldsNames:( NSSet* )fieldNames_
{
    SCReadItemsRequest * request = [SCReadItemsRequest requestWithItemId:self.itemId
                                                             fieldsNames:fieldNames_];
    [ self->_itemSourcePOD fillRequestParameters: request ];

    JFFAsyncOperation loader_ = [ _apiSession itemsLoaderWithRequest: request ];

    loader_ = firstItemFromArrayReader( loader_ );

    JFFAsyncOperationBinder binder_ = asyncOperationBinderWithAnalyzer( ^id( id result_, NSError** error_ )
    {
        NSDictionary* dict_ = [ result_ readFieldsByName ];
        dict_ = dict_ ? dict_ : @{};
        return dict_;
    } );
    return bindSequenceOfAsyncOperations( loader_, binder_, nil );
}

-(SCAsyncOp)fieldsReaderForFieldsNames:( NSSet* )fieldNames_
{
    return asyncOpWithJAsyncOp( [ self fieldsLoaderForFieldsNames: fieldNames_ ] );
}

-(SCExtendedAsyncOp)extendedFieldsReaderForFieldsNames:( NSSet* )fieldNames_
{
    return [ self fieldsLoaderForFieldsNames: fieldNames_ ];
}

-(JFFAsyncOperation)fieldsValuesLoaderForFieldsNames:( NSSet* )fieldsNames_
{
    NSLocale* posixLocale_ = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    NSMutableSet *fieldsUpperNames_ = [ NSMutableSet new ];
    for ( NSString *elem in fieldsNames_ )
    {
        [ fieldsUpperNames_ addObject:[ elem uppercaseStringWithLocale: posixLocale_ ] ];
    }
                              
    
    JFFAsyncOperation loader_ = [ self fieldsLoaderForFieldsNames: fieldsUpperNames_ ];

    NSDictionary*(^fieldsGetter_)(void) = ^NSDictionary*()
    {
        return self.readFieldsByName;
    };

    JFFAsyncOperationBinder readFieldsValuesDict_ = fieldsByNameToFieldsValuesByName( fieldsUpperNames_, fieldsGetter_ );

    return bindSequenceOfAsyncOperations( loader_
                                         , readFieldsValuesDict_
                                         , nil );
}

-(SCAsyncOp)readFieldsValuesOperationForFieldsNames:( NSSet* )fieldsNames_
{
    // loader - reader mismatch
    return asyncOpWithJAsyncOp( [ self readFieldsValuesExtendedOperationForFieldsNames: fieldsNames_ ] );
}


-(SCExtendedAsyncOp)readFieldsValuesExtendedOperationForFieldsNames:( NSSet* )fieldsNames_
{
    return [ self fieldsValuesLoaderForFieldsNames: fieldsNames_ ];
}


-(SCAsyncOp)readFieldValueOperationForFieldName:( NSString* )fieldName_
{
    return asyncOpWithJAsyncOp( [self readFieldValueExtendedOperationForFieldName: fieldName_ ] );
}

-(SCExtendedAsyncOp)readFieldValueExtendedOperationForFieldName:( NSString* )fieldName_
{
    NSLocale* posixLocale_ = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    fieldName_ = [ fieldName_ uppercaseStringWithLocale:posixLocale_ ];
    
    NSSet* fieldsNames_ = [ NSSet setWithObject: fieldName_ ];
    JFFAsyncOperation loader_ = [ self fieldsValuesLoaderForFieldsNames: fieldsNames_ ];
    
    JFFAnalyzer analyzer_ = ^id( NSDictionary* fieldValueByName_, NSError** error_ )
    {
        id value_ = fieldValueByName_[ fieldName_ ];
        if ( !value_ && error_ )
            *error_ = [ SCNoFieldError new ];
        return value_;
    };
    JFFAsyncOperationBinder secondLoaderBinder_ = asyncOperationBinderWithAnalyzer( analyzer_ );
    
    return bindSequenceOfAsyncOperations( loader_, secondLoaderBinder_, nil );
}

-(NSArray*)allChildren
{
    return [ self.record.allChildrenRecords map: ^id( SCItemRecord* record_ )
    {
        return record_.item;
    } ];
}

-(NSArray*)readChildren
{
    NSArray* childRecords = self.record.readChildrenRecords;
    if ( ![ childRecords hasElements ] )
    {
        return nil;
    }
    
    return [ childRecords map: ^id( SCItemRecord* record_ )
    {
        return record_.item;
    } ];
}

-(NSArray*)readFields
{
    return [ [ self readFieldsByName ] allKeys ];
}

-(NSArray*)allFields
{
    return [ [ self allFieldsByName ] allKeys ];
}

#pragma mark -
#pragma mark SaveItem
-(SCAsyncOp)saveItem
{
    SCExtendedAsyncOp extendedSaveItem = [ self extendedSaveItem ];
    SCAsyncOp result = [ SCAsyncOpRelationsBuilder operationFromExtendedOperation: extendedSaveItem ];
    
    return result;
}

-(SCExtendedAsyncOp)asyncChangedFieldNames
{
#if USE_IN_MEMORY_CACHE
    {
        return asyncOperationWithSyncOperation(^NSSet*(NSError *__autoreleasing *outError)
        {
            return self.lazyFieldNamesToChange;
        } );
    }
#else
    {
        JFFSyncOperation syncChangedFieldNamesBlock = ^NSSet*( NSError** outError )
        {
            id<SCItemRecordCacheRW> cache = self.apiSession.itemsCache;
            NSArray* namesOfDirtyFields =
            [ cache changedFieldsForItemId: self.itemId
                                itemSource: self->_record.itemSource ];

            if ( nil == namesOfDirtyFields )
            {
                namesOfDirtyFields = @[];
            }

            return [ NSSet setWithArray: namesOfDirtyFields ];
        };

        return asyncOperationWithSyncOperation( syncChangedFieldNamesBlock );
    }
#endif
}

-(SCExtendedAsyncOp)extendedSaveItem
{
    SCExtendedAsyncOp result = bindSequenceOfAsyncOperationsArray( [ self asyncChangedFieldNames ], @[ [ self saveItemBinder ] ] );
    
    result = asyncOperationWithChangedResult( result, ^SCItem*(id previousBlockResult)
    {
        return self;
    } );

    return result;
}

-(JFFAsyncOperationBinder)saveItemBinder
{
    return ^JFFAsyncOperation( NSSet* dirtyFieldNames )
    {
        if ( 0 == [ dirtyFieldNames count ] )
        {
            return asyncOperationWithResult( self );
        }

        return [ self asyncSaveItemWithDirtyFields: dirtyFieldNames ];
    };
}

-(SCExtendedAsyncOp)asyncSaveItemWithDirtyFields:( NSSet* )dirtyFieldNames
{
    SCEditItemsRequest* editItemsRequest_ = [ SCEditItemsRequest requestWithItemId: self.itemId ];

    editItemsRequest_.fieldsRawValuesByName =
    [ NSDictionary fieldsRawFaluesByNameWithNames: dirtyFieldNames
                                     fieldsByName: [ self readFieldsByName ] ];
    self->_fieldNamesToChange = nil;
    [ [ self->_record itemSource ] fillRequestParameters: editItemsRequest_ ];
    
    JFFAsyncOperation loader_ = [ self.apiSession editItemsLoaderWithRequest: editItemsRequest_ ];
    loader_ = firstItemFromArrayReader( loader_ );
        
    return loader_;
}


#pragma mark -
#pragma mark RemoveItem
-(SCAsyncOp)removeItem
{
    SCExtendedAsyncOp result = [ self extendedRemoveItem ];
    return [ SCAsyncOpRelationsBuilder operationFromExtendedOperation: result ];
}

-(SCExtendedAsyncOp)extendedRemoveItem
{
    SCExtendedAsyncOp removeOp = bindSequenceOfAsyncOperationsArray( [ self asyncItemId ], @[ [ self removeItemBinder ] ] );

    JFFDidFinishAsyncOperationHook finishHook =
    ^void(NSArray* itemsIds, NSError *error, JFFDidFinishAsyncOperationHandler doneCallback )
    {
        NSParameterAssert( nil == itemsIds || [ itemsIds isKindOfClass: [ NSArray class ] ] );
        
        BOOL isNoError = ( nil == error );
        BOOL isNothingDeleted = ( 0 == [ itemsIds count ] );
        
        if ( isNoError && isNothingDeleted )
        {
            error = [ SCNoItemError new ];
        }

        SCItem* blockResult = self;
        if ( nil == itemsIds )
        {
            blockResult = nil;
        }

        if ( nil != doneCallback )
        {
            doneCallback( blockResult, error );
        }
    };
    
    SCExtendedAsyncOp result = nil;
    result = asyncOperationWithFinishHookBlock( removeOp, finishHook );
    
    return result;
}

-(SCExtendedAsyncOp)asyncRemoveItemWithId:( NSString* )itemId
{
    NSParameterAssert( [ itemId length ] > 0 );

    SCReadItemsRequest * request_ = [SCReadItemsRequest requestWithItemId:itemId];
    
    [ self->_itemSourcePOD fillRequestParameters: request_ ];
    JFFAsyncOperation loader_ = [ self.apiSession removeItemsLoaderWithRequest: request_ ];
    
    return loader_;
}

-(JFFAsyncOperationBinder)removeItemBinder
{
    __weak SCItem* weakSelf = self;
    
    return ^JFFAsyncOperation( NSString* itemId )
    {
        if ( 0 == [ itemId length ] )
        {
            return asyncOperationWithError( [ SCNoItemError new ] );
        }
        else
        {
            return [ weakSelf asyncRemoveItemWithId: itemId ];
        }
    };
}

-(SCExtendedAsyncOp)asyncItemId
{
    __weak SCItem* weakSelf = self;
    
    return asyncOperationWithSyncOperation(^NSString*(NSError *__autoreleasing *outError)
    {
        NSString* result = weakSelf.itemId;

        if ( nil == result )
        {
            [ [ SCNoItemError new ] setToPointer: outError ];
            return nil;
        }

        return result;
    } );
}

//STODO!! add children item and etc

#pragma mark -
#pragma mark Media Extensions
-(NSLocale*)posixLocale
{
    static NSLocale* posixLocale = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^void()
    {
      posixLocale = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    } );
    
    return posixLocale;
}

-(BOOL)isFolder
{
    NSString* itemTemplate = [ self.itemTemplate uppercaseStringWithLocale: [ self posixLocale ] ];
    
    NSArray* folderTemplates =
    @[
      @"SYSTEM/MEDIA/MEDIA FOLDER",
      @"COMMON/FOLDER"
      ];
    
    NSSet* folderTemplateSet = [ NSSet setWithArray: folderTemplates ];
    return [ folderTemplateSet containsObject: itemTemplate ];
}

-(BOOL)isImage
{
    NSString* itemTemplate = [ self.itemTemplate uppercaseStringWithLocale: [ self posixLocale ] ];
    NSArray* imageTemplates =
    @[
      @"SYSTEM/MEDIA/UNVERSIONED/IMAGE",
      @"SYSTEM/MEDIA/UNVERSIONED/JPEG" ,
      @"SYSTEM/MEDIA/VERSIONED/JPEG"
    ];
    NSSet* imageTemplatesSet = [ NSSet setWithArray: imageTemplates ];
    
    return [ imageTemplatesSet containsObject: itemTemplate ];
}

-(BOOL)isMediaImage
{
    BOOL result =
    [ self isMediaItem ] &&
    [ self isImage ];
    
    return result;
}

-(BOOL)isMediaItem
{
    NSString* path = [ self.path lowercaseStringWithLocale: [ self posixLocale ] ];
    NSString* mediaRoot = self.apiSession.mediaLibraryPath;
    
    BOOL result = ( [ path hasPrefix: mediaRoot ] );
    return result;
}

-(NSString*)mediaPath
{
    if ( ! [ self isMediaItem ] )
    {
        return nil;
    }
    
    NSString* mediaPath = [ self.path substringFromIndex: [ self.apiSession.mediaLibraryPath length ] ];
    return mediaPath;
}

-(SCExtendedAsyncOp)mediaLoaderWithOptions:( SCDownloadMediaOptions* )options
{
    if ( [ self isMediaItem ] )
    {
        if ( nil == options )
        {
            options = [ SCDownloadMediaOptions new ];
        }
        
        SCItemSourcePOD* recordSource = [ self recordItemSource ];
        {
            options.database = recordSource.database;
            options.language = recordSource.language;
            options.version  = recordSource.itemVersion;
        }
        
        
        NSString* mediaPath = [ self mediaPath ];
        
        return [ self.apiSession downloadResourceOperationForMediaPath: mediaPath
                                                           imageParams: options ];
        
    }
    else
    {
        return nil;
    }
}

-(SCItemSourcePOD*)recordItemSource
{
    return [ self.record getSource ];
}


@end
