
#import "SCWebPlugin.h"

#import <Twitter/Twitter.h>

#include "twitter.js.h"

//STODO remove
@interface NSArray (ArrayWithEmailOnly_JDWTwitterPlugin)

-(id)scSelectWithEmailOnly;
-(id)scSelectNotEmptyStrings;

@end

@interface JDWTwitterPlugin : NSObject < SCWebPlugin >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation JDWTwitterPlugin
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
    return [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_share_twitter_twitter_js
                                       length: __SCWebPlugins_Plugins_share_twitter_twitter_js_len
                                     encoding: NSUTF8StringEncoding ];
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/share/twitter" ];
}

-(void)tweetText:( NSString* )text_
       imageUrls:( NSArray* )imageUrls_
            urls:( NSArray* )urls_
         webView:( UIWebView* )webView_
{
    UIViewController* rootController_ = webView_.window.rootViewController;
    if ( !rootController_ )
    {
        [ self.delegate sendMessage: @"{ error: 'can not open window' }" ];
        [ self.delegate close ];
        return;
    }

    TWTweetComposeViewController* controller_ = [ TWTweetComposeViewController new ];
    __weak UIViewController* weak_controller_ = controller_;

    [ controller_ setInitialText: text_ ];

    imageUrls_ = [ imageUrls_ scSelectNotEmptyStrings ];
    for ( NSString* urlString_ in imageUrls_ )
    {
        NSURL* url_ = [ NSURL URLWithString: urlString_ ];
        if ( url_ )
        {
            NSData* data_ = [ NSData dataWithContentsOfURL: url_ ];
            if ( data_ )
            {
                UIImage* image_ = [ UIImage imageWithData: data_ ];
                if ( image_ )
                {
                    [ controller_ addImage: image_ ];
                }
            }
        }
    }

    urls_ = [ urls_ scSelectNotEmptyStrings ];
    for ( NSString* urlString_ in urls_ )
    {
        NSURL* url_ = [ NSURL URLWithString: urlString_ ];
        if ( url_ )
            [ controller_ addURL: url_ ];
    }

    controller_.completionHandler = ^void( TWTweetComposeViewControllerResult result_ )
    {
        if ( TWTweetComposeViewControllerResultCancelled == result_ )
        {
            [ self.delegate sendMessage: @"{ error: 'canceled' }" ];
        }
        else if ( TWTweetComposeViewControllerResultDone == result_ )
        {
            [ self.delegate sendMessage: @"{}" ];
        }
        [ self.delegate close ];
        [ weak_controller_ dismissViewControllerAnimated: NO
                                              completion: nil ];
    };

    [ rootController_ presentTopViewController: controller_ ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSDictionary* components_ = [ self->_request.URL queryComponents ];

    NSString* text_      = [ components_ firstValueIfExsistsForKey: @"text" ];
    NSArray*  urls_      = components_[ @"url" ];
    NSArray*  imageUrls_ = components_[ @"image_url" ];

    [ self tweetText: text_
           imageUrls: imageUrls_
                urls: urls_
             webView: webView_ ];
}

@end
