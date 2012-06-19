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
        SCField* field_ = [ fieldsByName_ objectForKey: fieldName_ ];
        NSString* rawValue_ = field_.rawValue ?: @"";
        [ result_ setObject: rawValue_ forKey: fieldName_ ];
    }

    return [ NSDictionary dictionaryWithDictionary: result_ ];
}

@end
