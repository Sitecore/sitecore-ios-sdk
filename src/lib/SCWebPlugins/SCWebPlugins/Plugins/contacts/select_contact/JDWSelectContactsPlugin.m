#import "SCWebPlugin.h"

#import "SCContact.h"

#import "NSArray+ContactsToJSON.h"
#import "UIPopoverController+PresentPopoverInWebView.h"

#import <AddressBookUI/AddressBookUI.h>

@interface JDWSelectContactsPlugin : NSObject
<
    SCWebPlugin
    , ABPeoplePickerNavigationControllerDelegate
    , UINavigationControllerDelegate
    , UIPopoverControllerDelegate
>

@end

@implementation JDWSelectContactsPlugin
{
    ABPeoplePickerNavigationController* _controller;
    UIPopoverController* _popover;
    NSUInteger _controllerNum;
    NSURLRequest* _request;
    ABRecordRef _person;
}

@synthesize delegate;

-(void)dealloc
{
    CFRelease( _person );
}

-(id)initWithRequest:( NSURLRequest* )request_
{
    self = [ super init ];

    _request = request_;

    return self;
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/contacts/select_contact" ];
}

-(void)selectContactWithWebView:( UIWebView*  )webView_
{
    UIViewController* rootController_ = webView_.window.rootViewController;
    if ( !rootController_ )
    {
        [ self.delegate sendMessage: @"{ error: 'can not open window' }" ];
        [ self.delegate close ];
        return;
    }

    _controller = [ ABPeoplePickerNavigationController new ];
    _controller.delegate = self;
    _controller.peoplePickerDelegate = self;

    NSArray* displayedItems = [ NSArray arrayWithObjects:
                               [ NSNumber numberWithInt: kABPersonPhoneProperty ]
                               , [ NSNumber numberWithInt: kABPersonEmailProperty    ]
                               , [ NSNumber numberWithInt: kABPersonBirthdayProperty ]
                               , nil ];
    _controller.displayedProperties = displayedItems;

    if ( [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone)
    {
        [ rootController_ presentTopViewController: _controller ];
    }
    else
    {
        _popover = [ [ UIPopoverController alloc ] initWithContentViewController: _controller ];
        _popover.delegate = self;
        [ _popover presentPopoverFromRect: CGRectMake( 0.f, 0.f, 480.f, 320.f )
                                inWebView: webView_ ];
    }
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    [ self selectContactWithWebView: webView_ ];
}

-(void)hideControllers
{
    if ( _popover )
    {
        [ _popover dismissPopoverAnimated: YES ];
        return;
    }
    else
    {
        [ _controller dismissViewControllerAnimated: NO
                                         completion: nil ];
    }

    _popover = nil;
    _controller  = nil;
}

-(void)onStopWithMessage:( NSString* )message_
{
    [ self.delegate sendMessage: message_ ];
    [ self.delegate close ];

    _popover = nil;
    _controller  = nil;
}

-(void)selectItemAction:( id )sender_
{
    NSString* message_;
    if ( _person )
    {
        SCContact* contact_ = [ [ SCContact alloc ] initWithPerson: _person ];
        NSArray* contacts_ = [ NSArray arrayWithObject: contact_ ];
        message_ = [ contacts_ scContactsToJSON ];
        message_ = message_ ?: @"{ error: 'Invalid Contacts JSON 1' }";
    }
    else
    {
        message_ = @"{ error: 'canceled' }";
    }

    [ self hideControllers ];
    [ self onStopWithMessage: message_ ];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate

-(void)peoplePickerNavigationControllerDidCancel:( ABPeoplePickerNavigationController* )peoplePicker_
{
    [ self hideControllers ];
    [ self onStopWithMessage: @"{ error: 'canceled' }" ];
}

-(BOOL)peoplePickerNavigationController:( ABPeoplePickerNavigationController* )peoplePicker_
     shouldContinueAfterSelectingPerson:( ABRecordRef )person_
{
    if ( _person != person_ )
    {
        if ( _person )
            CFRelease( _person );
        _person = CFRetain( person_ );
    }
    return YES;
}

- (BOOL)peoplePickerNavigationController:( ABPeoplePickerNavigationController* )peoplePicker_
      shouldContinueAfterSelectingPerson:( ABRecordRef )person_
                                property:( ABPropertyID )property_
                              identifier:( ABMultiValueIdentifier )identifier_
{
    return YES;
}

-(void)didClose
{
    [ self hideControllers ];
}

#pragma mark UINavigationControllerDelegate

-(void)navigationController:( UINavigationController* )navigationController
     willShowViewController:( UIViewController* )viewController_
                   animated:( BOOL )animated
{
    ++_controllerNum;
    _controllerNum %= 2;
    if ( _controllerNum == 0 )
    {
        SEL selector_ = @selector( selectItemAction: );
        UIBarButtonItem* item_ = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                  target: self
                                                                                  action: selector_ ];
        viewController_.navigationItem.rightBarButtonItem = item_;
    }
    else
    {
        if ( _person )
        {
            CFRelease( _person );
            _person = nil;
        }
    }
}

#pragma mark UIPopoverControllerDelegate

-(void)popoverControllerDidDismissPopover:( UIPopoverController* )popoverController_
{
    [ self onStopWithMessage: @"{ error: 'canceled' }" ];
}

@end
