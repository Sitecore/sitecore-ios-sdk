#import "SCContactStringArrayField.h"

#import "NSArray+kABMultiValue.h"

static ABMutableMultiValueRef createMutableMultiValueWithArray( NSArray* elements_
                                                               , NSArray* labels_ )
{
    ABMutableMultiValueRef result = ABMultiValueCreateMutable( kABMultiStringPropertyType );

    NSUInteger index_ = 0;
    for ( NSString* element_ in elements_ )
    {
        id label_ = [ labels_ noThrowObjectAtIndex: index_ ];
        if ( ![ label_ isKindOfClass: [ NSString class ] ] )
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

@interface SCContactStringArrayField ()
@end

@implementation SCContactStringArrayField
{
    NSArray* _labels;
}

+(id)contactFieldWithName:( NSString* )name_
               propertyID:( ABPropertyID )propertyID_
                   labels:( NSArray* )labels_
{
    SCContactStringArrayField* result_ = [ self contactFieldWithName: name_
                                                          propertyID: propertyID_ ];

    result_->_labels = labels_;

    return result_;
}

-(void)readPropertyFromRecord:( ABRecordRef )record_
{
    CFTypeRef value_ = ABRecordCopyValue( record_, self.propertyID );
    self.value = [ NSArray arrayWithMultyValue: value_ ];
    if ( value_ )
        CFRelease( value_ );
}

-(NSArray*)filteredValues:( NSArray* )values_
{
    return [ values_ scSelectNotEmptyStrings ];
}

-(void)setPropertyFromValues:( NSDictionary* )components_
                    toRecord:( ABRecordRef )record_
{
    self.value = [ self filteredValues: components_[ self.name ] ];

    CFErrorRef error_ = NULL;
    ABMutableMultiValueRef values_ = createMutableMultiValueWithArray( self.value, self->_labels );
    BOOL didSet = ABRecordSetValue( record_
                                   , self.propertyID
                                   , values_
                                   , &error_);
    if (!didSet) { NSLog( @"can not set %@", self.name ); }
    if ( values_ )
        CFRelease( values_ );
}

-(NSString*)jsonValue
{
    return self.value ? self.value : @"[]";
}

@end
