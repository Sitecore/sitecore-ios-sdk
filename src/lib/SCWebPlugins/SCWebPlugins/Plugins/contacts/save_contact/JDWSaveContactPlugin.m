#import "SCWebPlugin.h"

#import "SCContact.h"

#import "UIPopoverController+PresentPopoverInWebView.h"

#import <AddressBookUI/AddressBookUI.h>

@interface SCPluginABNewPersonViewController : ABNewPersonViewController
@end

@implementation SCPluginABNewPersonViewController

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    UIBarButtonItem* rightBarButtonItem_ = self.navigationItem.rightBarButtonItem;

    UIBarButtonItem* newRightBarButtonItem_ = [ [ UIBarButtonItem alloc ]
                                               initWithBarButtonSystemItem: UIBarButtonSystemItemSave
                                                                    target: rightBarButtonItem_.target
                                                                    action: rightBarButtonItem_.action ];

    self.navigationItem.rightBarButtonItem = newRightBarButtonItem_;
}

@end

@interface JDWSaveContactPlugin : NSObject
<
    SCWebPlugin
    , ABNewPersonViewControllerDelegate
    , UIPopoverControllerDelegate
>

@end

@implementation JDWSaveContactPlugin
{
    NSURLRequest* _request;
    UINavigationController* _navigationController;
    UIPopoverController* _popover;
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
        [ self.delegate sendMessage: @"{ error: 'can not open window' }" ];
        [ self.delegate close ];
        return;
    }

    ABNewPersonViewController* controller_ = [ SCPluginABNewPersonViewController new ];
    controller_.newPersonViewDelegate = self;

    controller_.displayedPerson = contact_.person;
    controller_.addressBook     = contact_.addressBook;

    _navigationController = [ [ UINavigationController alloc ] initWithRootViewController: controller_ ];

    if ( [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone )
    {
        [ rootController_ presentTopViewController: _navigationController ];
    }
    else
    {
        [ self showPopoverWithController: _navigationController
                                    view: webView_ ];
    }
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSDictionary* args_  = [ _request.URL queryComponents ];
    SCContact* contact_ = [ [ SCContact alloc ] initWithArguments: args_ ];

    [ self saveOrCreateContact: contact_
                       webView: webView_ ];
}

-(void)sendSavedPerson:( ABRecordRef )person_
{
    SCContact* contact_ = person_
        ? [ [ SCContact alloc ] initWithPerson: person_ ]
        : nil;

    NSString* message_;
    if ( contact_ )
    {
        //STODO - send all fields
        message_ = [ [ NSString alloc ] initWithFormat: @"{ contactInternalId: %d }", contact_.contactInternalId ];
    }
    else
    {
        message_ = @"{ error: 'canceled' }";
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
    _popover = nil;

    [ [ JFFScheduler sharedByThreadScheduler ] addBlock: ^( JFFCancelScheduledBlock cancel_ )
    {
        _navigationController = nil;
    } duration: 0.2 ];

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

@end
