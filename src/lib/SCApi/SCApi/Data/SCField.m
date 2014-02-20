#import "SCField.h"

#import "SCItem.h"

#import "SCItemRecord.h"
#import "SCItemRecord+SCItemSource.h"

#import "SCFieldRecord.h"
#import "SCItemSourcePOD.h"
#import "SCApiSession.h"
#import "SCExtendedApiSession+Private.h"

#import "SCApiMacro.h"

@interface SCItem (SCField)

@property ( nonatomic, readonly ) NSMutableSet* lazyFieldNamesToChange;
@property ( nonatomic, readonly ) NSMutableSet* fieldNamesToChange;

@end

@interface SCField ()

@property ( nonatomic ) id fieldValue;
@property ( nonatomic ) SCFieldRecord *fieldRecord;

@end

@implementation SCField

@dynamic fieldId;
@dynamic name;
@dynamic type;
@dynamic fieldValue;
@dynamic itemSource;

-(id)init
{
    self = [ super init ];

    [ self doesNotRecognizeSelector: _cmd ];

    return self;
}

-(id)initWithFieldRecord:( SCFieldRecord* )fieldRecord_
              apiSession:( SCExtendedApiSession* )apiSession_
{
    self = [ super init ];

    if ( self )
    {
        self.fieldRecord = fieldRecord_;
        self->_rawValue = self.fieldRecord.rawValue;
        self->_apiSession = apiSession_;
    }

    return self;
}

+(id)fieldWithFieldRecord:( SCFieldRecord* )fieldRecord_
               apiSession:( SCExtendedApiSession* )apiSession_
{
    return [ [ self alloc ] initWithFieldRecord: fieldRecord_
                                     apiSession: apiSession_ ];
}

-(id)forwardingTargetForSelector:( SEL )selector_
{
    return _fieldRecord;
}

-(JFFAsyncOperation)fieldValueLoader
{
    NSAssert( self.fieldValue, @"fieldValue should not be nil" );
    return asyncOperationWithResult( self.fieldValue );
}

-(JFFAsyncOperation)fieldValueLoaderWithParms:( SCParams* )params
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(SCAsyncOp)fieldValueReader
{
    return asyncOpWithJAsyncOp( [ self fieldValueLoader ] );
}

-(SCExtendedAsyncOp)extendedFieldValueReader
{
    return [ self fieldValueLoader ];
}

-(SCAsyncOp)fieldValueReaderWithParams:( SCParams* )params
{
    return asyncOpWithJAsyncOp( [ self fieldValueLoaderWithParms: params ] );
}

-(NSString*)description
{
    NSString* className_ = NSStringFromClass( [ self class ] );
    return [ [ NSString alloc ] initWithFormat: @"<%@ name:\"%@\" type:\"%@\" value:\"%@\" >"
            , className_
            , self.name
            , self.type
            , self.rawValue ];
}

-(id)createFieldValue
{
    return self.rawValue;
}

-(id)fieldValue
{
    if ( !_fieldRecord.fieldValue )
    {
        _fieldRecord.fieldValue = [ self createFieldValue ];
    }
    return _fieldRecord.fieldValue;
}

-(SCItem*)item
{
    return self.fieldRecord.itemRecord.item;
}

-(void)setRawValue:( NSString* )rawValue
{
    if ( self->_rawValue == rawValue )
    {
        return;
    }

    // @adk : order matters
    self->_rawValue = rawValue;
    [ self markFieldAsDirty ];

    // @adk - otherwise items from cache may be inconsistent
    self->_fieldRecord.rawValue = rawValue;
}

-(void)markFieldAsDirty
{
#if USE_IN_MEMORY_CACHE
    {
        if ( [ self.fieldRecord.rawValue isEqualToString: self->_rawValue ] )
        {
            [ self.item.fieldNamesToChange removeObject: self.name ];
        }
        else
        {
            [ self.item.lazyFieldNamesToChange addObject: self.name ];
        }
    }
#else
    // Persistent cache
    {
        id<SCItemRecordCacheRW> cache = self->_apiSession.itemsCache;
        [ cache setRawValue: self->_rawValue
                 forFieldId: self->_fieldRecord.fieldId
                     itemId: self->_fieldRecord.itemId
                 itemSource: self->_fieldRecord.itemSource ];
    }
#endif
}

//STODO!! add save to SCField
//STODO add load image for media item

-(id<SCItemSource>)itemSource
{
    return self.fieldRecord.itemSource;
}

@end
