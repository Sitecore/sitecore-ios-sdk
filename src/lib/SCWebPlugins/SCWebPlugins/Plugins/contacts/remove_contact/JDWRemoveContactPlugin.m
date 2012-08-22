#import "SCWebPlugin.h"

#import "SCContact.h"
#import "SCAddressBook.h"
#import "SCAddressBookFactory.h"

#import <AddressBook/AddressBook.h>

@interface JDWRemoveContactPlugin : NSObject < SCWebPlugin >

@property ( nonatomic ) SCAddressBook* addressBook;
@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation JDWRemoveContactPlugin
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
    return [ request_.URL.path isEqualToString: @"/scmobile/contacts/remove_contact" ];
}

-(void)doWork
{
    NSDictionary* components_ = [ self->_request.URL queryComponents ];
    
    NSString* accountInternalId_ = [ components_ firstValueIfExsistsForKey: @"contactInternalId" ];
    NSLog(@"[BEGIN] - %@. ID : %@", NSStringFromClass( [ self class ] ), accountInternalId_ );
    
    
    ABAddressBookRef addressBook_ = self.addressBook.rawBook;
    
    ABRecordRef record_ = ABAddressBookGetPersonWithRecordID( addressBook_
                                                             , [ accountInternalId_ longLongValue ] );
    
    if ( record_ )
    {
        CFErrorRef error_ = NULL;
        bool added_ = ABAddressBookRemoveRecord( addressBook_, record_, &error_ );
        if (!added_)
        {
            NSLog( @"can not remove record from AddressBook" );
        }
    }
    
    CFErrorRef error_ = NULL;
    bool didSaved = ABAddressBookSave( addressBook_, &error_ );
    if (!didSaved)
    {
        NSLog( @"can not save AddressBook" );
    }
        
    [ self.delegate sendMessage: @"" ];
    [ self.delegate close ];
    
    NSLog(@"[END] - %@. ID : %@", NSStringFromClass( [ self class ] ), accountInternalId_ );
}

-(void)handleError:( NSError*)error_
forAuthorizationStatus:( ABAuthorizationStatus )status_
{
    NSLog(@"[ERROR] - %@", NSStringFromClass( [ self class ] ) );

    [ self.delegate sendMessage: error_.localizedDescription ];
    [ self.delegate close ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    [ SCAddressBookFactory asyncAddressBookWithSuccessBlock:
         ^void( SCAddressBook* book_ )
         {
             self.addressBook = book_;
             [ self doWork ];
         }
                                                  errorCallback:
         ^void( ABAuthorizationStatus status_, NSError* error_ )
         {
             [ self handleError: error_
         forAuthorizationStatus: status_ ];
         }
    ];
}

@end
