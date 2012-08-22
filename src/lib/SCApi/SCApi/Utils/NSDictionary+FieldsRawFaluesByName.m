#import "NSDictionary+FieldsRawFaluesByName.h"

#import "SCField.h"

@implementation NSDictionary (FieldsRawFaluesByName)

+(id)fieldsRawFaluesByNameWithNames:( NSSet* )fieldNames_
                       fieldsByName:( NSDictionary* )fieldsByName_
{
    NSMutableDictionary* result_ =
        [ [ NSMutableDictionary alloc ] initWithCapacity: [ fieldNames_ count ] ];

    for ( NSString* fieldName_ in fieldNames_ )
    {
        SCField* field_ = fieldsByName_[ fieldName_ ];
        result_[ fieldName_ ] = field_.rawValue ?: @"";
    }

    return [ result_ copy ];
}

@end
