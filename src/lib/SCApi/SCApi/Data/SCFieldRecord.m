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

+(Class)fieldClassForType:( NSString* )type_
{
    static NSDictionary* classByFieldType_ = nil;
    if ( !classByFieldType_ )
    {
        classByFieldType_ = @{
        @"Image"        : [ SCImageField       class ],
        @"Checkbox"     : [ SCCheckboxField    class ],
        @"Date"         : [ SCDateField        class ],
        @"Datetime"     : [ SCDateTimeField    class ],
        @"Checklist"    : [ SCChecklistField   class ],
        @"Multilist"    : [ SCMultilistField   class ],
        @"Treelist"     : [ SCTreelistField    class ],
        @"Color Picker" : [ SCColorPickerField class ],
        @"Droplink"     : [ SCDroplinkField    class ],
        @"Droptree"     : [ SCDroptreeField    class ],
        @"General Link" : [ SCGeneralLinkField class ],
        };
    }
    id class_ = classByFieldType_[ type_ ];
    return class_ ?: [ SCField class ];
}

-(SCField*)field
{
    SCField* field_ = self->_fieldRef;

    if ( !field_ )
    {
        Class fieldClass_ = [ [ self class ] fieldClassForType: self.type ];
        field_ = [ fieldClass_ fieldWithFieldRecord: self
                                         apiContext: self.apiContext ];
        self->_fieldRef = field_;
    }

    return field_;
}

@end
