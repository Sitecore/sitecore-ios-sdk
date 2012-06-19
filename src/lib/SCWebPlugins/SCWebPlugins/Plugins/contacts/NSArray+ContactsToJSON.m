#import "NSArray+ContactsToJSON.h"

#import "SCContact.h"

@implementation NSArray (ContactsToJSON)

-(NSString*)scContactsToJSON
{
    NSArray* contacts_ = [ self map: ^id( id object_ )
    {
        SCContact* contact_ = object_;
        return [ contact_ toDictionary ];
    } ];

    NSDictionary* json_ = [ NSDictionary dictionaryWithObject: contacts_
                                                       forKey: @"contacts" ];

    NSData* data_ = [ NSJSONSerialization dataWithJSONObject: json_
                                                     options: NSJSONWritingPrettyPrinted
                                                       error: nil ];

    if ( !data_ )
        return nil;

    return [ [ NSString alloc ] initWithBytes: data_.bytes
                                       length: data_.length
                                     encoding: NSUTF8StringEncoding ];
}

@end
