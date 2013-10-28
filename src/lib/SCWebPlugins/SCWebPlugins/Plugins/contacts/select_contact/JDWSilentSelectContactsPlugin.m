#import "SCWebPlugin.h"

#import "SCContact.h"
#import "NSArray+ContactsToJSON.h"

#import "SCAddressBookFactory.h"
#import "SCAddressBook.h"

#import "SCContactsPluginError.h"

#import <AddressBook/AddressBook.h>

#import "contacts.js.h"

@interface JDWSilentSelectContactsPlugin : NSObject < SCWebPlugin >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation JDWSilentSelectContactsPlugin
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

-(NSArray*)allAccountsWithAllFieldsFromAddressBook:( SCAddressBook* )book_
{
    NSMutableArray* contacts = nil;
    NSArray* result_ = nil;
    
    @autoreleasepool
    {
        ABAddressBookRef addressBook_ = book_.rawBook;
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook_ );

        CFIndex allPeopleCount = CFArrayGetCount( allPeople );
        NSUInteger castedPeopleCount = (NSUInteger)allPeopleCount;
        
        contacts = [ [ NSMutableArray alloc ] initWithCapacity: castedPeopleCount ];
        
        for ( CFIndex i = 0; i != allPeopleCount; ++i )
        {
            ABRecordRef person_ = CFArrayGetValueAtIndex( allPeople, i );
            
            if ( NULL != person_ )
            {
                SCContact* contact = [ [ SCContact alloc ] initWithPerson: person_
                                                              addressBook: book_ ];
                [ contacts addObject: contact ];            
            }
        }


        CFRelease( allPeople );
        allPeople = NULL;
        
        [ book_ releaseBook ];
    }
        
    result_ = [ NSArray arrayWithArray: contacts ];
    return result_;
}



-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSLog(@"[BEGIN] - %@.", NSStringFromClass( [ self class ] ) );
    
    __weak JDWSilentSelectContactsPlugin* weakSelf_ = self;
    
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
    NSLog(@"[ERROR] - %@. %@", NSStringFromClass( [ self class ] ), error_ );
    
    
    [ self.delegate sendMessage: msg_ ];
    [ self.delegate close ];
}

-(void)doWorkWithAddressBook:( SCAddressBook* )book_
{
    @autoreleasepool
    {
        NSArray* contacts_ = [ self allAccountsWithAllFieldsFromAddressBook: book_ ];
        
        NSString* msg_ = [ contacts_ scContactsToJSON ];
        if ( nil == msg_ )
        {
            msg_ = [ [ SCContactsPluginError invalidContactsJsonError ] toJson ];
        }
        
        [ self.delegate sendMessage: msg_ ];
        [ self.delegate close ];
        
        NSLog(@"[END] - %@.", NSStringFromClass( [ self class ] ) );
    }
}

@end
