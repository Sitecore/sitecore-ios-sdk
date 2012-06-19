#import "SCWebPlugin.h"

#import "SCContact.h"
#import "NSArray+ContactsToJSON.h"

#import <AddressBook/AddressBook.h>

#include "contacts.js.h"

@interface JDWSilentSelectContactsPlugin : NSObject < SCWebPlugin >
@end

@implementation JDWSilentSelectContactsPlugin
{
    NSURLRequest* _request;
}

@synthesize delegate;

-(id)initWithRequest:( NSURLRequest* )request_
{
    self = [ super init ];

    _request = request_;

    return self;
}

+(NSString*)pluginJavascript
{
    return [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_contacts_contacts_js
                                       length: __SCWebPlugins_Plugins_contacts_contacts_js_len
                                     encoding: NSUTF8StringEncoding ];
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/contacts/silent_select_contact" ];
}

-(NSArray*)allAccountsWithAllFields
{
    ABAddressBookRef addressBook_ = ABAddressBookCreate();

    NSArray* result_ = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople( addressBook_ );

    result_ = [ result_ map: ^id( id object_ )
    {
        ABRecordRef person_ = ( __bridge ABRecordRef )object_;
        return [ [ SCContact alloc ] initWithPerson: person_ ];
    } ];

    CFRelease( addressBook_ );

    return result_;
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSArray* contacts_ = [ self allAccountsWithAllFields ];

    NSString* msg_ = [ contacts_ scContactsToJSON ];
    msg_ = msg_ ?: @"{ error: 'Invalid Contacts JSON 2' }";
    [ self.delegate sendMessage: msg_ ];
    [ self.delegate close ];
}

@end
