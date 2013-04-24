
#import "SCWebPlugin.h"

#import "SCContact.h"
#import "SCAddressBook.h"
#import "SCAddressBookFactory.h"

#import <AddressBook/AddressBook.h>

@interface JDWSilentSaveContactPlugin : NSObject < SCWebPlugin >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation JDWSilentSaveContactPlugin
{
    NSURLRequest* _request;
}

-(id)initWithRequest:( NSURLRequest* )request_
{
    self = [ super init ];

    if ( self )
    {
        self->_request = request_;
    }

    return self;
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/contacts/silent_save_contact" ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    __weak JDWSilentSaveContactPlugin* weakSelf_ = self;

    [ SCAddressBookFactory asyncAddressBookWithOnCreatedBlock:
     ^void(SCAddressBook* book_, ABAuthorizationStatus status_, NSError* error_)
     {
         if ( kABAuthorizationStatusAuthorized != status_ )
         {
             [ weakSelf_ processAccessError: error_
                             forAddressBook: book_
                                     status: status_ ];
         }
         else
         {
             [ self doWorkWithAddressBook: book_ ];
         }
     } ];
}

-(void)processAccessError:( NSError* )error_
           forAddressBook:( SCAddressBook* )book_
                   status:( ABAuthorizationStatus )status_
{
    NSString* msg_ = [ error_ toJson ];

    [ self.delegate sendMessage: msg_ ];
    [ self.delegate close ];
}

-(void)doWorkWithAddressBook:( SCAddressBook* )book_
{
    NSDictionary* args_ = [ self->_request.URL queryComponents ];
    SCContact* arg_ = [ [ SCContact alloc ] initWithArguments: args_
                                                  addressBook: book_ ];

    [ arg_ save ];

    [ self->_delegate sendMessage: [ [ NSString alloc ] initWithFormat: @"%d", arg_.contactInternalId ] ];
    [ self->_delegate close ];
}

@end
