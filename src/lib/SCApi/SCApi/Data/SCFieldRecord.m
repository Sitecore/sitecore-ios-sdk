#import "SCFieldRecord.h"

#import "SCImageField.h"
#import "SCCheckboxField.h"
#import "SCDateField.h"
#import "SCDateTimeField.h"
#import "SCChecklistField.h"
#import "SCMultilistField.h"
#import "SCTreelistField.h"
#import "SCColorPickerField.h"
#import "SCDroplinkField.h"
#import "SCDroptreeField.h"
#import "SCGeneralLinkField.h"

@interface SCField (SCFieldRecord)

+(id)fieldWithFieldRecord:( SCFieldRecord* )fieldRecord_
               apiContext:( SCApiContext* )apiContext_;

@end

@implementation SCFieldRecord

@synthesize apiContext = _apiContext;
@synthesize fieldId    = _fieldId;
@synthesize name       = _name;
@synthesize type       = _type;
@synthesize rawValue   = _rawValue;
@synthesize itemRecord = _itemRecord;
@synthesize fieldRef   = _fieldRef;
@synthesize fieldValue = _fieldValue;

+(Class)fieldClassForType:( NSString* )type_
{
    static NSDictionary* classByFieldType_ = nil;
    if ( !classByFieldType_ )
    {
        classByFieldType_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                             [ SCImageField         class ], @"Image"
                             , [ SCCheckboxField    class ], @"Checkbox"
                             , [ SCDateField        class ], @"Date"
                             , [ SCDateTimeField    class ], @"Datetime"
                             , [ SCChecklistField   class ], @"Checklist"
                             , [ SCMultilistField   class ], @"Multilist"
                             , [ SCTreelistField    class ], @"Treelist"
                             , [ SCColorPickerField class ], @"Color Picker"
                             , [ SCDroplinkField    class ], @"Droplink"
                             , [ SCDroptreeField    class ], @"Droptree"
                             , [ SCGeneralLinkField class ], @"General Link"
                             , nil ];
    }
    id class_ = [ classByFieldType_ objectForKey: type_ ];
    return class_ ?: [ SCField class ];
}

-(SCField*)field
{
    SCField* field_ = _fieldRef;

    if ( !field_ )
    {
        Class fieldClass_ = [ [ self class ] fieldClassForType: self.type ];
        field_ = [ fieldClass_ fieldWithFieldRecord: self
                                         apiContext: self.apiContext ];
        _fieldRef = field_;
    }

    return field_;
}

@end
