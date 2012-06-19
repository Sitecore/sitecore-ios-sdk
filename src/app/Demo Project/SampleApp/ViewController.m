#import "NavigationToolbar.h"
#import "ViewController.h"

#import <MessageUI/MessageUI.h>

static NSString* const defaultUrlKey_   = @"urlToLoad";
static NSString* const defaultUrlValue_ = @"http://uvo1x9xg1sagz55xsg9.env.cloudshare.com/";

static NSString* const defaultUserAgentKey_   = @"userAgent";
static NSString* const defaultUserAgentValue_ = @"Version/5.1 Safari/535.19 MSDKApp/1.0";

@interface ViewController () < SCWebBrowserDelegate, MFMailComposeViewControllerDelegate >
@end

@implementation ViewController
{
    MFMailComposeViewController* _emailController;
}

@synthesize webBrowser;

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    webBrowser.dataDetectorTypes = UIDataDetectorTypeAll;
    webBrowser.delegate = self;

    NavigationToolbar* view_ = [ [ NavigationToolbar alloc ] initWithFrame: CGRectMake( 0.f, 0.f, 110.f, 35.f ) ];
    [ webBrowser setCustomToollbarView: view_ ];

    NSUserDefaults* defaults_ = [ NSUserDefaults standardUserDefaults ];

    {
        NSDictionary* registeredDefaults_ = [ NSDictionary dictionaryWithObjectsAndKeys:
                                         defaultUrlValue_, defaultUrlKey_
                                         , defaultUserAgentValue_, defaultUserAgentKey_
                                         , nil ];

        [ registeredDefaults_ enumerateKeysAndObjectsUsingBlock: ^( id key_, id obj_, BOOL* stop_ )
        {
            id object_ = [ defaults_ stringForKey: key_ ];
            if ( object_ == nil )
                [ defaults_ setObject: obj_ forKey: key_ ];
        } ];

        [ defaults_ synchronize ];
    }

	NSString* path_ = [ defaults_ stringForKey: defaultUrlKey_ ];
	NSString* userAgent_ = [ defaults_ stringForKey: defaultUserAgentKey_ ];

    [ SCWebView setUserAgentAddition: userAgent_ ];

    if ( ![ path_ hasPrefix: @"http://" ] && ![ path_ hasPrefix: @"https://" ] && path_ )
    {
        path_ = [ @"http://" stringByAppendingString: path_ ];
    }
    if ( path_ )
        [ webBrowser loadURLWithString: path_ ];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:( UIInterfaceOrientation )interfaceOrientation_
{
    return YES;
}

#pragma mark SCWebBrowserDelegate

-(BOOL)webView:(SCWebBrowser *)webView_
shouldStartLoadWithRequest:(NSURLRequest *)request_
navigationType:(UIWebViewNavigationType)navigationType_
{
    if ( [ @"mailto" isEqualToString: request_.URL.scheme ]
        && [ MFMailComposeViewController canSendMail ] )
    {
        self->_emailController = [ MFMailComposeViewController new ];
        self->_emailController.mailComposeDelegate = self;
        NSArray* recipients_ = [ [ NSArray alloc ] initWithObjects: request_.URL.resourceSpecifier, nil ];
        [ self->_emailController setToRecipients: recipients_ ];
        [ self presentViewController: self->_emailController
                            animated: YES
                          completion: nil ];

        return NO;
    }

    return YES;
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:( MFMailComposeViewController* )controller_
          didFinishWithResult:( MFMailComposeResult )result_
                        error:( NSError* )error_
{
    MFMailComposeViewController* emailController_ = self->_emailController;
    [ self->_emailController dismissViewControllerAnimated: YES
                                          completion: ^()
    {
        if ( emailController_ == self->_emailController )
            self->_emailController = nil;
    } ];
}

@end
