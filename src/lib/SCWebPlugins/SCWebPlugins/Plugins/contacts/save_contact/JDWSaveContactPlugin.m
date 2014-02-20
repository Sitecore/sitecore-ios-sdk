#import "SCWebPlugin.h"

#import "SCAddressBookFactory.h"
#import "SCAddressBook.h"
#import "SCContact.h"
#import "SCContactsPluginError.h"

#import "UIPopoverController+PresentPopoverInWebView.h"



@interface JDWSaveContactPlugin : NSObject
<
    SCWebPlugin
    , ABNewPersonViewControllerDelegate
    , UIPopoverControllerDelegate
>

@property ( nonatomic, strong ) SCAddressBook* book;
@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@property ( nonatomic ) UINavigationController* navigationController;

@end

@implementation JDWSaveContactPlugin
{
    NSURLRequest* _request;
    UINavigationController* _navigationController;
    UIPopoverController* _popover;
    ABNewPersonViewController* _newPersonController;
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
    return [ request_.URL.path isEqualToString: @"/scmobile/contacts/save_contact" ];
}

-(void)showPopoverWithController:( UIViewController* )controller_
                            view:( UIWebView* )view_
{
    _popover = [ [ UIPopoverController alloc ] initWithContentViewController: _navigationController ];
    _popover.delegate = self;

    [ _popover presentPopoverFromRect: CGRectMake( 0.f, 0.f, 480.f, 320.f )
                            inWebView: view_ ];
}

-(BOOL)closeWhenBackground
{
    return YES;
}

-(void)saveOrCreateContact:( SCContact* )contact_
                   webView:( UIWebView* )webView_
{
    UIViewController* rootController_ = webView_.window.rootViewController;
    
    if ( !rootController_ )
    {
        SCContactsPluginError* error_ = [ SCContactsPluginError noRootViewControllerError ];
        
        [ self.delegate sendMessage: [ error_ toJson ] ];
        [ self.delegate close ];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        
        self->_newPersonController = [ ABNewPersonViewController new ];
        self->_newPersonController.newPersonViewDelegate = self;
        
        self->_newPersonController.displayedPerson = contact_.person;
        self->_newPersonController.addressBook     = contact_.addressBook;
        
        
        _navigationController = [ [ UINavigationController alloc ] initWithRootViewController: self->_newPersonController ];
        
        if ( [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone )
        {
            [ rootController_ presentTopViewController: _navigationController ];
        }
        else
        {
            [ self showPopoverWithController: _navigationController
                                        view: webView_ ];
        }
        
    });
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    __weak JDWSaveContactPlugin* weakSelf_ = self;

    
    SCAddressBookSuccessCallback addressBookReceived = ^( SCAddressBook* book_ )
    {
        weakSelf_.book = book_;
        
        NSDictionary* args_  = [ _request.URL queryComponents ];
        SCContact* contact_ = [ [ SCContact alloc ] initWithArguments: args_
                                                          addressBook: self->_book ];
        
        [ weakSelf_ saveOrCreateContact: contact_
                                webView: webView_ ];
        
    };
    
    
    SCAddressBookErrorCallback onAddressBookError = ^(ABAuthorizationStatus status_, NSError* error_)
    {
        [ weakSelf_.delegate sendMessage: [ error_ toJson ] ];
        [ weakSelf_.delegate close ];
    };
    
    [ SCAddressBookFactory asyncAddressBookWithSuccessBlock: addressBookReceived
                                              errorCallback: onAddressBookError ];
}

-(void)sendSavedPerson:( ABRecordRef )person_
{
    SCContact* contact_ = person_
        ? [ [ SCContact alloc ] initWithPerson: person_
                                   addressBook: self->_book ]
        : nil;

    NSString* message_;
    if ( contact_ )
    {
        //STODO - send all fields
        message_ = [ [ NSString alloc ] initWithFormat: @"{ contactInternalId: %d }", contact_.contactInternalId ];
    }
    else
    {
        SCContactsPluginError* error_ = [ SCContactsPluginError operationCancelledError ];
        message_ = [ error_ toJson ];
    }

    [ self.delegate sendMessage: message_ ];
    [ self.delegate close ];
}

-(void)hideControllers
{
    if ( _popover )
    {
        [ _popover dismissPopoverAnimated: YES ];
    }
    else
    {
        [ _navigationController dismissViewControllerAnimated: YES completion: nil ];
    }

    _popover = nil;
    _navigationController = nil;
}

-(void)onStopWithPerson:( ABRecordRef )person_
{
    self->_popover = nil;

    __weak JDWSaveContactPlugin* weakSelf = self;
    
    JFFTimer* timer = [ JFFTimer sharedByThreadTimer ];
    JFFScheduledBlock disposeNavigationController = ^void( JFFCancelScheduledBlock cancel_ )
    {
        weakSelf.navigationController = nil;
    };
    
    // @adk - a nasty threading issue.
    [ timer addBlock: disposeNavigationController
            duration: 0.2 ];

    [ self sendSavedPerson: person_ ];
}

-(void)didClose
{
    [ self hideControllers ];
}

#pragma mark ABNewPersonViewControllerDelegate

-(void)newPersonViewController:( ABNewPersonViewController* )newPersonView_
      didCompleteWithNewPerson:( ABRecordRef )person_
{
    [ self hideControllers ];
    [ self onStopWithPerson: person_ ];
}

#pragma mark UIPopoverControllerDelegate

-(void)popoverControllerDidDismissPopover:( UIPopoverController* )popoverController_
{
    [ self onStopWithPerson: NULL ];
}

-(void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person_
{
    [ self hideControllers ];
    [ self onStopWithPerson: person_ ];
}

@end
