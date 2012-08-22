
#import "SCWebPlugin.h"

#include "notifications.js.h"

@interface JWSAlertListener : NSObject < SCWebPlugin >

@property ( nonatomic ) NSURLRequest* request;
@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@interface NSString (JDWAlertListener32)
@end

@implementation NSString (JDWAlertListener32)

-(NSArray*)notificationAlertButtonNames
{
    NSArray* result_ = [ self componentsSeparatedByString: @"," ];
    return [ result_ map: ^id( id object_ )
    {
        return [ object_ stringByTrimmingWhitespaces ];
    } ];
}

@end

@implementation JWSAlertListener
{
    UIAlertView* _alertView;
}

-(void)dealloc
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
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
    return [ request_.URL.path isEqualToString: @"/scmobile/notification/alert" ];
}

+(NSString*)pluginJavascript
{
    return [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_notification_notifications_js
                                       length: __SCWebPlugins_Plugins_notification_notifications_js_len
                                     encoding: NSUTF8StringEncoding ];
}

-(void)finishWithButtonIndex:( NSInteger )index_
{
    _alertView.delegate = nil;
    _alertView = nil;

    NSString* indexString_ = [ [ NSString alloc ] initWithFormat: @"{ closeIndex: %d }", index_ ];

    [ self.delegate sendMessage: indexString_ ];
    [ self.delegate close ];
}

-(void)autoHidePopoverWillResignActive:( NSNotification* )notification_
{
    NSInteger index_ = [ _alertView cancelButtonIndex ];
    [ _alertView dismissWithClickedButtonIndex: index_ animated: NO ];
    [ self finishWithButtonIndex: index_ ];
}

-(void)showAlertWithTitle:( NSString* )title_
                  message:( NSString* )message_
              buttonNames:( NSString* )button_names_
{
    UIApplication* application_ = [ UIApplication sharedApplication ];
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( autoHidePopoverWillResignActive: )
                                                    name: UIApplicationWillResignActiveNotification
                                                  object: application_ ];

    _alertView = [ [ UIAlertView alloc ] initWithTitle: title_
                                               message: message_
                                              delegate: self
                                     cancelButtonTitle: nil
                                     otherButtonTitles: nil ];

    NSArray* buttonTitles_ = [ button_names_ notificationAlertButtonNames ];

    for ( id buttonTitle_ in buttonTitles_ )
    {
        [ _alertView addButtonWithTitle: buttonTitle_ ];
    }

    [ _alertView show ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSDictionary* components_ = [ self.request.URL queryComponents ];

    NSString* title_ = [ components_ firstValueIfExsistsForKey: @"title" ];
    title_ = [ title_ stringByTrimmingWhitespaces ];
    title_ = 0 == [ title_ length ] ? @"Alert" : title_;

    NSString* message_ = [ components_ firstValueIfExsistsForKey: @"message" ];

    NSString* button_names_ = [ components_ firstValueIfExsistsForKey: @"buttonNames" ];
    button_names_ = [ button_names_ stringByTrimmingWhitespaces ];
    button_names_ = 0 == [ button_names_ length ] ? @"OK" : button_names_;

    [ self showAlertWithTitle: title_
                      message: message_
                  buttonNames: button_names_ ];
}

-(void)didReceiveMessage:( NSString* )msg_
{
    NSUInteger index_ = [ msg_ integerValue ];
    index_ = index_ < _alertView.numberOfButtons ? index_ : _alertView.numberOfButtons - 1;
    _alertView.delegate = nil;
    [ _alertView dismissWithClickedButtonIndex: index_ animated: NO ];
    _alertView = nil;
}

-(void)didClose
{
    _alertView.delegate = nil;
    [ _alertView dismissWithClickedButtonIndex: [ _alertView cancelButtonIndex ] animated: NO ];
    _alertView = nil;
}

#pragma mark UIAlertViewDelegate

-(void)alertView:( UIAlertView* )alertView_ didDismissWithButtonIndex:( NSInteger )buttonIndex_
{
    [ self finishWithButtonIndex: buttonIndex_ ];
}

-(void)didPresentAlertView:( UIAlertView* )alertView_
{
    [ self.delegate sendMessage: @"{ didPresent: true }" ];
}

@end
