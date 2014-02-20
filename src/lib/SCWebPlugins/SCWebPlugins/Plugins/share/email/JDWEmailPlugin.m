
#import "SCWebPlugin.h"

#include "email.js.h"

#import "SCEmailFields.h"
#import "SCMobileEmailError.h"


@interface JDWEmailPlugin : NSObject
    <
    SCWebPlugin
    , MFMailComposeViewControllerDelegate
    >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation JDWEmailPlugin
{
    NSURLRequest* _request;
    MFMailComposeViewController* _emailController;
}

-(id)initWithRequest:( NSURLRequest* )request_
{
    self = [ super init ];

    if ( self )
    {
        self->_request = request_;
    }
    else
    {
        NSLog( @"[BEGIN] JDWEmailPlugin - [ super init ] error" );
    }

    return self;
}

+(NSString*)pluginJavascript
{
    NSString* result_ = [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_share_email_email_js
                                                    length: __SCWebPlugins_Plugins_share_email_email_js_len
                                                  encoding: NSUTF8StringEncoding ];

    return result_;
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    BOOL result_ =[ request_.URL.path isEqualToString: @"/scmobile/share/email" ];
    NSLog( @"JDWEmailPlugin->canInitWithRequest(%@) == %d", request_.URL, result_ );
    
    return result_;
}

-(void)sendEmail:( SCEmailFields* )fields_
         webView:( UIWebView* )webView_
{
    UIViewController* rootController_ = webView_.window.rootViewController;
    SCMobileEmailError* error = nil;
    
    
    if ( ![ MFMailComposeViewController canSendMail ] )
    {
        NSLog( @"sendEmail - canSendMail() failed" );
        error = [ [ SCMobileEmailError alloc ] initWithDescription: @"There is no e-mail account on your device"
                                                              code: 1 ];
    }
    if ( !rootController_ )
    {
        NSLog( @"sendEmail - no root ViewController" );
        
        error = [ [ SCMobileEmailError alloc ] initWithDescription: @"No window to present e-mail composer"
                                                              code: 2 ];
    }
    
    if ( nil != error )
    {
        [ self.delegate sendMessage: [ error toJson ] ];
        [ self.delegate close ];
        return;
    }
    

    self->_emailController = [ MFMailComposeViewController new ];
    self->_emailController.mailComposeDelegate = self;

    [ self->_emailController setToRecipients:  fields_.toRecipients  ];
    [ self->_emailController setSubject:       fields_.subject       ];
    [ self->_emailController setCcRecipients:  fields_.ccRecipients  ];
    [ self->_emailController setBccRecipients: fields_.bccRecipients ];
    [ self->_emailController setMessageBody:   fields_.body isHTML: fields_.isHTML ];

    //STODO
    //[addAttachmentData:mimeType:fileName:];

    [ rootController_ presentTopViewController: self->_emailController ];
}

-(void)hideControllers
{
    [ self->_emailController dismissViewControllerAnimated: NO
                                                completion: nil ];

    JFFScheduledBlock actionBlock_ = ^( JFFCancelScheduledBlock cancel_ )
    {
        self->_emailController = nil;
    };
    [ [ JFFTimer sharedByThreadTimer ] addBlock: actionBlock_ duration: 0.2 ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSDictionary* components_ = [ self->_request.URL queryComponents ];
    SCEmailFields* fields_ = [ SCEmailFields emailFieldsWithComponents: components_ ];

    [ self sendEmail: fields_ webView: webView_ ];
}

-(BOOL)closeWhenBackground
{
    return YES;
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:( MFMailComposeViewController* )controller_
          didFinishWithResult:( MFMailComposeResult )result_
                        error:( NSError* )error_
{
    [ self hideControllers ];

    if ( nil != error_ )
    {
        [ self.delegate sendMessage: [ error_ toJson ] ];
        [ self.delegate close ];
        return;        
    }
    else if ( result_ == MFMailComposeResultFailed )
    {
        NSError* mailFailedError = [ [ SCMobileEmailError alloc ] initWithDescription: @"Email sending failed"
                                                                                 code: 3 ];
        
        [ self.delegate sendMessage: [ mailFailedError toJson ] ];
        [ self.delegate close ];
        return;
    }

    NSString* resultStatus_ = @"sent";
    switch ( result_ )
    {
        case MFMailComposeResultCancelled:
        {
            resultStatus_ = @"cancelled";
            break;
        }
        case MFMailComposeResultSaved:
        {
            resultStatus_ = @"saved";
            break;
        }
        case MFMailComposeResultSent:
        {
            resultStatus_ = @"sent";
            break;
        }
        case MFMailComposeResultFailed:
        {
            break;
        }
    }

    NSString* msg_ = [ [ NSString alloc ] initWithFormat: @"{ result: '%@' }", resultStatus_ ];
    [ self.delegate sendMessage: msg_ ];
    [ self.delegate close ];
}

-(void)didClose
{
    [ self performSelectorOnMainThread: @selector( hideControllers )
                            withObject: nil
                         waitUntilDone: NO ];
}

@end
