#import "SCItem.h"

#import "SCImageField.h"

#import "SCError.h"
#import "SCItemRecord.h"
#import "SCApiContext.h"
#import "SCExtendedApiContext.h"

#import "SCEditItemsRequest.h"
#import "SCItemsReaderRequest.h"

#import "SCApiUtils.h"

#import "SCApiAnalizers.h"

#import "NSString+ItemPathLogic.h"
#import "NSDictionary+FieldsRawFaluesByName.h"

#import "SCItemSourcePOD.h"
#import "SCItemRecord+SCItemSource.h"

#import "SCApiMacro.h"
#import <SitecoreMobileSDK/SCAsyncOpRelationsBuilder.h>

@interface SCExtendedApiContext (SCItem)

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;

-(JFFAsyncOperation)itemsLoaderWithRequest:( SCItemsReaderRequest* )request_;
-(SCField*)fieldWithName:( NSString* )fieldName_
                  itemId:( NSString* )itemId_
                language:( NSString* )language_;

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )editItemsRequest_;
-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCItemsReaderRequest* )request_;

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
    SCExtendedApiContext* _apiContext;
    SCApiContext *_mainApiContext;
    
    SCItemSourcePOD *_itemSourcePOD;
}

@dynamic displayName
, path
, hasChildren
, itemId
, itemTemplate
, longID
, allFieldsByName
, readFieldsByName
, language
, lazyFieldNamesToChange;

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithRecord:( SCItemRecord* )record_
         apiContext:( SCExtendedApiContext* )apiContext_
{
    self = [ super init ];

    if ( self )
    {
        self->_record     = record_;
        self->_apiContext = apiContext_;
        self->_mainApiContext = apiContext_.mainContext;
        
        self->_itemSourcePOD = [ SCItemSourcePOD new ];
        self->_itemSourcePOD.language = apiContext_.defaultLanguage;
        self->_itemSourcePOD.database = apiContext_.defaultDatabase;
        self->_itemSourcePOD.site = apiContext_.defaultSite;
        self->_itemSourcePOD.itemVersion = apiContext_.defaultItemVersion;
    }

    return self;
}

+(id)itemWithRecord:( SCItemRecord* )record_
         apiContext:( SCExtendedApiContext* )apiContext_
{
    return [ [ self alloc ] initWithRecord: record_
                                apiContext: apiContext_ ];
}

+(id)rootItemWithApiContext:( SCExtendedApiContext* )apiContext_
{
    return [ [ self alloc ] initWithRecord: [ SCItemRecord rootRecord ]
                                apiContext: apiContext_ ];
}

-(SCItem*)itemWithId:( NSString* )itemId_
{
    return [ self->_apiContext itemWithId: itemId_
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

-(SCExtendedApiContext*)apiContext
{
    return self->_apiContext;
}

-(id)forwardingTargetForSelector:( SEL )selector_
{
    return self->_record;
}

-(SCField*)fieldWithName:( NSString* )fieldName_
{
    SCFieldRecord* fieldRecord = [ self->_apiContext.itemsCache fieldWithName: fieldName_
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
    return [ self->_apiContext.itemsCache allFieldsByNameForItemId: self->_record.itemId
                                                        itemSource: self->_record.itemSource ];
}

-(NSDictionary*)readFieldsByName
{
    return [ self->_apiContext.itemsCache cachedFieldsByNameForItemId: self->_record.itemId
                                                           itemSource: self->_record.itemSource ];
}

-(SCAsyncOp)childrenReader
{
    return asyncOpWithJAsyncOp( [ self extendedChildrenReader ] );
}

-(SCExtendedAsyncOp)extendedChildrenReader
{
    SCItemsReaderRequest* request = [ SCItemsReaderRequest requestWithItemId: self.itemId
                                                                 fieldsNames: [ NSSet new ]
                                                                       scope: SCItemReaderChildrenScope ];
    [ self->_itemSourcePOD fillRequestParameters: request ];
    
    return [ _apiContext itemsReaderWithRequest: request ];
}

-(JFFAsyncOperation)fieldsLoaderForFieldsNames:( NSSet* )fieldNames_
{
    SCItemsReaderRequest* request = [ SCItemsReaderRequest requestWithItemId: self.itemId
                                                                 fieldsNames: fieldNames_ ];
    [ self->_itemSourcePOD fillRequestParameters: request ];

    JFFAsyncOperation loader_ = [ _apiContext itemsLoaderWithRequest: request ];

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
    JFFAsyncOperation loader_ = [ self fieldsLoaderForFieldsNames: fieldsNames_ ];

    NSDictionary*(^fieldsGetter_)(void) = ^NSDictionary*()
    {
        return self.readFieldsByName;
    };

    JFFAsyncOperationBinder readFieldsValuesDict_ = fieldsByNameToFieldsValuesByName( fieldsNames_, fieldsGetter_ );

    return bindSequenceOfAsyncOperations( loader_
                                         , readFieldsValuesDict_
                                         , nil );
}

-(SCAsyncOp)fieldsValuesReaderForFieldsNames:( NSSet* )fieldsNames_
{
    // loader - reader mismatch
    return asyncOpWithJAsyncOp( [ self extendedFieldsValuesReaderForFieldsNames: fieldsNames_ ] );
}


-(SCExtendedAsyncOp)extendedFieldsValuesReaderForFieldsNames:( NSSet* )fieldsNames_
{
    return [ self fieldsValuesLoaderForFieldsNames: fieldsNames_ ];
}


-(SCAsyncOp)fieldValueReaderForFieldName:( NSString* )fieldName_
{
    return asyncOpWithJAsyncOp( [self extendedFieldValueReaderForFieldName: fieldName_ ] );
}

-(SCExtendedAsyncOp)extendedFieldValueReaderForFieldName:( NSString* )fieldName_
{
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
            id<SCItemRecordCacheRW> cache = self.apiContext.itemsCache;
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
    
    JFFAsyncOperation loader_ = [ self.apiContext editItemsLoaderWithRequest: editItemsRequest_ ];
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
        NSParameterAssert( nil != doneCallback );
        
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

        doneCallback( blockResult, error );
    };
    
    SCExtendedAsyncOp result = nil;
    result = asyncOperationWithFinishHookBlock( removeOp, finishHook );
    
    return result;
}

-(SCExtendedAsyncOp)asyncRemoveItemWithId:( NSString* )itemId
{
    NSParameterAssert( [ itemId length ] > 0 );

    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId ];
    
    [ self->_itemSourcePOD fillRequestParameters: request_ ];
    JFFAsyncOperation loader_ = [ self.apiContext removeItemsLoaderWithRequest: request_ ];
    
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

@end
