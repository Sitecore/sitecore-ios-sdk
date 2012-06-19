#import "SCContactDictionaryArrayField.h"

#import "SCContactAddress.h"
#import "NSArray+kABMultiValue.h"
#import "NSArray+AddressesDictionariesWithJSON.h"

//STODO remove duplicates
static ABMutableMultiValueRef createMutableMultiValueWithArray( NSArray* elements_
                                                               , NSArray* labels_ )
{
    ABMutableMultiValueRef result = ABMultiValueCreateMutable( kABMultiDictionaryPropertyType );

    NSUInteger index_ = 0;
    for ( NSDictionary* element_ in elements_ )
    {
        id label_ = [ labels_ noThrowObjectAtIndex: index_ ];
        if ( ![ label_ isKindOfClass: [ NSDictionary class ] ] )
            label_ = nil;

        ABMultiValueAddValueAndLabel( result
                                     , (__bridge CFTypeRef)element_
                                     , (__bridge CFTypeRef)label_
                                     , NULL );
        ++index_;
    }

    return result;
}

//STODO remove
@interface NSArray (ArrayWithEmailOnlyPrivate3)

-(id)scSelectNotEmptyStrings;

@end

@interface SCContactDictionaryArrayField ()
@end

@implementation SCContactDictionaryArrayField
{
    NSArray* _labels;
}

+(id)contactFieldWithName:( NSString* )name_
               propertyID:( ABPropertyID )propertyID_
                   labels:( NSArray* )labels_
{
    SCContactDictionaryArrayField* result_ = [ self contactFieldWithName: name_
                                                              propertyID: propertyID_ ];

    result_->_labels = labels_;

    return result_;
}

-(void)readPropertyFromRecord:( ABRecordRef )record_
{
    CFTypeRef value_ = ABRecordCopyValue( record_, self.propertyID );
    NSArray* address_ = [ NSArray arrayWithMultyValue: value_ ];

    self.value = [ address_ map: ^id( NSDictionary* dict_ )
    {
        return [ SCContactAddress contactAddressWithContactValueDict: dict_ ];
    } ];

    if ( value_ )
        CFRelease( value_ );
}

-(NSArray*)filteredValues:( NSArray* )values_
{
    return [ values_ scSelectNotEmptyStrings ];
}

-(NSArray*)contactFieldsWithValues:( NSDictionary* )components_
{
    NSString* addressesJSONStr_ = [ components_ firstValueIfExsistsForKey: self.name ];
    return [ NSArray scAddressesDictionariesWithJSON: addressesJSONStr_ ];
}

-(void)setPropertyFromValues:( NSDictionary* )components_
                    toRecord:( ABRecordRef )record_
{
    NSArray* contactFields_ = [ self contactFieldsWithValues: components_ ];

    self.value = [ contactFields_ map: ^id(id object_)
    {
        return [ SCContactAddress contactAddressWithComponents: object_ ];
    } ];

    NSArray* contactsDicts_ = [ self.value map: ^id(SCContactAddress* object_)
    {
        return [ object_ contactApiDict ];
    } ];

    CFErrorRef error_ = NULL;
    ABMutableMultiValueRef values_ = createMutableMultiValueWithArray( contactsDicts_, _labels );
    BOOL didSet = ABRecordSetValue( record_
                                   , self.propertyID
                                   , values_
                                   , &error_ );
    if (!didSet) { NSLog( @"can not set %@", self.name ); }
    if ( values_ )
        CFRelease( values_ );
}

-(NSString*)jsonValue
{
    if ( [ self.value count ] == 0 )
        return @"[]";
    NSArray* json_ = [ self.value map: ^id(SCContactAddress* object_)
    {
        return [ object_ toJSONDict ];
    } ];
    NSError* error_;
    NSData* data_ = [ NSJSONSerialization dataWithJSONObject: json_
                                                     options: 0
                                                       error: &error_ ];

    if ( !data_ )
        return @"[]";

    return [ [ NSString alloc ] initWithData: data_ encoding: NSUTF8StringEncoding ];
}

@end
