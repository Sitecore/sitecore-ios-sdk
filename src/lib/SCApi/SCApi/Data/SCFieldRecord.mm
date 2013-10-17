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
#import "SCRichTextField.h"

#import "SCItemRecord+SCItemSource.h"

@interface SCField (SCFieldRecord)

+(id)fieldWithFieldRecord:( SCFieldRecord* )fieldRecord_
               apiContext:( SCExtendedApiContext* )apiContext_;

@end

@implementation SCFieldRecord

@dynamic itemSource;
@dynamic itemId;

+(Class)fieldClassForType:( NSString* )type_
{
    static NSDictionary* classByFieldType_ = nil;
    if ( !classByFieldType_ )
    {
        classByFieldType_ = @{
        @"Rich Text"    : [ SCRichTextField    class ],
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

-(BOOL)isEqual:(id)object
{
    JUncertainLogicStates pointerCheckResult = [ NSObject quickCheckObject: self
                                                                 isEqualTo: object ];
    if ( ULMaybe != pointerCheckResult )
    {
        return (BOOL)pointerCheckResult;
    }
    

    SCFieldRecord* otherField = objc_kind_of_cast<SCFieldRecord>( object );
    if ( nil == otherField )
    {
        return NO;
    }
    
    
    BOOL result =
       [ NSObject object: self.fieldId  isEqualTo: otherField.fieldId  ]
    && [ NSObject object: self.name     isEqualTo: otherField.name     ]
    && [ NSObject object: self.type     isEqualTo: otherField.type     ]
    && [ NSObject object: self.rawValue isEqualTo: otherField.rawValue ];
    
    return result;
}


#pragma mark -
#pragma mark Dynamic
-(SCItemSourcePOD*)itemSource
{
    return self.itemRecord.itemSource;
}

-(NSString*)itemId
{
    return self.itemRecord.itemId;
}

@end
