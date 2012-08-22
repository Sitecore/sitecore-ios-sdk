#import "SCItem.h"

#import "SCImageField.h"

#import "SCError.h"
#import "SCItemRecord.h"
#import "SCApiContext.h"

#import "SCEditItemsRequest.h"
#import "SCItemsReaderRequest.h"

#import "SCApiUtils.h"
#import "SCApiAnalizers.h"

#import "NSString+ItemPathLogic.h"
#import "NSDictionary+FieldsRawFaluesByName.h"

@interface SCApiContext (SCItem)

-(JFFAsyncOperation)itemsLoaderWithRequest:( SCItemsReaderRequest* )request_;
-(SCField*)fieldWithName:( NSString* )fieldName_
                  itemId:( NSString* )itemId_
                language:( NSString* )language_;

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )editItemsRequest_;
-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCItemsReaderRequest* )request_;

@end

@interface SCError (SCItem)

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
    SCApiContext* _apiContext;
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
         apiContext:( SCApiContext* )apiContext_
{
    self = [ super init ];

    if ( self )
    {
        _record     = record_;
        _apiContext = apiContext_;
    }

    return self;
}

+(id)itemWithRecord:( SCItemRecord* )record_
         apiContext:( SCApiContext* )apiContext_
{
    return [ [ self alloc ] initWithRecord: record_
                                apiContext: apiContext_ ];
}

+(id)rootItemWithApiContext:( SCApiContext* )apiContext_
{
    return [ [ self alloc ] initWithRecord: [ SCItemRecord rootRecord ]
                                apiContext: apiContext_ ];
}

-(SCItem*)itemWithId:( NSString* )itemId_
{
    return [ self->_apiContext itemWithId: itemId_ ];
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
    if ( !_fieldNamesToChange )
    {
        _fieldNamesToChange = [ NSMutableSet new ];
    }
    return _fieldNamesToChange;
}

-(SCApiContext*)apiContext
{
    return _apiContext;
}

-(id)forwardingTargetForSelector:( SEL )selector_
{
    return _record;
}

-(SCField*)fieldWithName:( NSString* )fieldName_
{
    return [ _apiContext fieldWithName: fieldName_
                                itemId: self.itemId
                              language: self.language ];
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
    return self.record.hasAllFields
        ? [ _apiContext readFieldsByNameForItemId: self.itemId ]
        : nil;
}

-(NSDictionary*)readFieldsByName
{
    return [ _apiContext readFieldsByNameForItemId: self.itemId ];
}

-(SCAsyncOp)childrenReader
{
    SCItemsReaderRequest* request = [ SCItemsReaderRequest requestWithItemId: self.itemId
                                                                 fieldsNames: [ NSSet new ]
                                                                       scope: SCItemReaderChildrenScope ];
    return [ _apiContext itemsReaderWithRequest: request ];
}

-(JFFAsyncOperation)fieldsLoaderForFieldsNames:( NSSet* )fieldNames_
{
    SCItemsReaderRequest* request = [ SCItemsReaderRequest requestWithItemId: self.itemId
                                                                 fieldsNames: fieldNames_ ];
    JFFAsyncOperation loader_ = [ _apiContext itemsLoaderWithRequest: request ];

    loader_ = firstItemFromArrayReader( loader_ );

    JFFAsyncOperationBinder binder_ = asyncOperationBinderWithAnalyzer( ^id( id result_, NSError** error_ )
    {
        NSDictionary* dict_ = [ result_ readFieldsByName ];
        dict_ = dict_ ? dict_ : [ NSDictionary new ];
        return dict_;
    } );
    return bindSequenceOfAsyncOperations( loader_, binder_, nil );
}

-(SCAsyncOp)fieldsReaderForFieldsNames:( NSSet* )fieldNames_
{
    return asyncOpWithJAsyncOp( [ self fieldsLoaderForFieldsNames: fieldNames_ ] );
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
    return asyncOpWithJAsyncOp( [ self fieldsValuesLoaderForFieldsNames: fieldsNames_ ] );
}

-(SCAsyncOp)fieldValueReaderForFieldName:( NSString* )fieldName_
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

    return asyncOpWithJAsyncOp( bindSequenceOfAsyncOperations( loader_, secondLoaderBinder_, nil ) );
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
    return [ self.record.readChildrenRecords map: ^id( SCItemRecord* record_ )
    {
        return record_.item;
    } ];
}

-(SCAsyncOp)saveItem
{
    return ^( SCAsyncOpResult handler_ )
    {
        if ( [ _fieldNamesToChange count ] == 0 )
        {
            if ( handler_ )
                handler_( self, nil );
            return;
        }

        SCEditItemsRequest* editItemsRequest_ = [ SCEditItemsRequest requestWithItemId: self.itemId ];

        editItemsRequest_.fieldsRawValuesByName =
            [ NSDictionary fieldsRawFaluesByNameWithNames: _fieldNamesToChange
                                             fieldsByName: [ self readFieldsByName ] ];
        _fieldNamesToChange = nil;

        JFFAsyncOperation loader_ = [ self.apiContext editItemsLoaderWithRequest: editItemsRequest_ ];
        loader_ = firstItemFromArrayReader( loader_ );

        handler_ = [ handler_ copy ];
        loader_( nil, nil, ^( SCItem* item_, NSError* error_ )
        {
            if ( handler_ )
                handler_( item_ ? self : nil, error_ );
        } );
    };
}

-(SCAsyncOp)removeItem
{
    return ^( SCAsyncOpResult handler_ )
    {
        if ( [ self.itemId length ] == 0 )
        {
            if ( handler_ )
                handler_( nil, [ SCNoItemError new ] );
            return;
        }

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: self.itemId ];

        JFFAsyncOperation loader_ = [ self.apiContext removeItemsLoaderWithRequest: request_ ];
        handler_ = [ handler_ copy ];
        loader_( nil, nil, ^( NSArray* itemsIds_, NSError* error_ )
        {
            if ( !error_ && [ itemsIds_ count ] == 0 )
            {
                error_ = [ SCNoItemError new ];
            }
            if ( handler_ )
                handler_( error_ ? nil : self, error_ );
        } );
    };
}

//STODO!! add children item and etc

@end
