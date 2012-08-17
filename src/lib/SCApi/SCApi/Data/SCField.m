#import "SCField.h"

#import "SCItem.h"
#import "SCItemRecord.h"
#import "SCFieldRecord.h"

@interface SCItem (SCField)

@property ( nonatomic, readonly ) NSMutableSet* lazyFieldNamesToChange;
@property ( nonatomic, readonly ) NSMutableSet* fieldNamesToChange;

@end

@interface SCField ()

@property ( nonatomic ) id fieldValue;
@property ( nonatomic ) SCFieldRecord *fieldRecord;

@end

@implementation SCField

@synthesize rawValue    = _rawValue;
@synthesize fieldRecord = _fieldRecord;

@dynamic fieldId
, name
, type
, fieldValue
, apiContext;

-(id)init
{
    self = [ super init ];

    [ self doesNotRecognizeSelector: _cmd ];

    return self;
}

-(id)initWithFieldRecord:( SCFieldRecord* )fieldRecord_
               apiContext:( SCApiContext* )apiContext_
{
    self = [ super init ];

    if ( self )
    {
        self.fieldRecord = fieldRecord_;

        _rawValue = self.fieldRecord.rawValue;
    }

    return self;
}

+(id)fieldWithFieldRecord:( SCFieldRecord* )fieldRecord_
               apiContext:( SCApiContext* )apiContext_
{
    return [ [ self alloc ] initWithFieldRecord: fieldRecord_
                                     apiContext: apiContext_ ];
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

-(SCAsyncOp)fieldValueReader
{
    return asyncOpWithJAsyncOp( [ self fieldValueLoader ] );
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

-(void)setRawValue:( NSString* )rawValue_
{
    if ( _rawValue == rawValue_ )
        return;

    _rawValue = rawValue_;

    if ( [ self.fieldRecord.rawValue isEqualToString: _rawValue ] )
    {
        [ self.item.fieldNamesToChange removeObject: self.name ];
    }
    else
    {
        [ self.item.lazyFieldNamesToChange addObject: self.name ];
    }
}

//STODO!! add save to SCField
//STODO add load image for media item

@end
