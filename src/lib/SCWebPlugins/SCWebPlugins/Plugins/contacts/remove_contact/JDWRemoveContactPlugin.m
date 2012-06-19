#import "SCWebPlugin.h"

#import "SCContact.h"

#import <AddressBook/AddressBook.h>

@interface JDWRemoveContactPlugin : NSObject < SCWebPlugin >
@end

@implementation JDWRemoveContactPlugin
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

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/contacts/remove_contact" ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSDictionary* components_ = [ _request.URL queryComponents ];

    NSString* accountInternalId_ = [ components_ firstValueIfExsistsForKey: @"contactInternalId" ];

    ABAddressBookRef addressBook_ = ABAddressBookCreate();

    ABRecordRef record_ = ABAddressBookGetPersonWithRecordID( addressBook_
                                                             , [ accountInternalId_ longLongValue ] );

    if ( record_ )
    {
        CFErrorRef error_ = NULL;
        bool added_ = ABAddressBookRemoveRecord( addressBook_, record_, &error_ );
        if (!added_) { NSLog( @"can not remove record from AddressBook" ); }
    }

    CFErrorRef error_ = NULL;
    bool didSaved = ABAddressBookSave( addressBook_, &error_ );
    if (!didSaved) { NSLog( @"can not save AddressBook" ); }

    CFRelease( addressBook_ );

    [ self.delegate sendMessage: @"" ];

    [ self.delegate close ];
}

@end
