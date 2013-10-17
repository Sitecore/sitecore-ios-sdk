
#import "SCWebPlugin.h"

#import "SCSocialNetworkPluginError.h"
#import "social.js.h"

#import "SCBaseSocialPoster.h"
#import "SCSocialFactory.h"

#define TESTING

//STODO remove
@interface NSArray (ArrayWithEmailOnly_JDWTwitterPlugin)

-(id)scSelectWithEmailOnly;
-(id)scSelectNotEmptyStrings;

@end

@interface JDWSocialNetworkPlugin : NSObject < SCWebPlugin >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;
@property ( nonatomic ) SCBaseSocialPoster* poster;

@end

@implementation JDWSocialNetworkPlugin
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
    return [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_share_social_js
                                       length: __SCWebPlugins_Plugins_share_social_js_len
                                     encoding: NSUTF8StringEncoding ];
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/share/generic_social" ];
}

+(NSArray*)imagesFromUrlArray:( NSArray* )imageUrls_
{
    imageUrls_ = [ imageUrls_ scSelectNotEmptyStrings ];
    NSMutableArray* result_ = [ NSMutableArray arrayWithCapacity: [ imageUrls_ count ] ];
    
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
                    [ result_ addObject: image_ ];
                }
            }
        }
    }
    
    return result_;
}

+(NSArray*)linksFromUrlArray:( NSArray* )urls_
{
    urls_ = [ urls_ scSelectNotEmptyStrings ];
    NSMutableArray* result_ = [ NSMutableArray arrayWithCapacity: [ urls_ count ] ];
    
    for ( NSString* urlString_ in urls_ )
    {
        NSURL* url_ = [ NSURL URLWithString: urlString_ ];
        if ( url_ )
        {
            [ result_ addObject: url_ ];
        }
    }
    
    return result_;
}


-(UIViewController*)findRootViewControllerWithError:( NSError** )errorPtr
{
    UIViewController* rootController_ = nil;
    UIWindow* window = nil;
    {
        //TODO: @ikg remove test rootController_ later
//#ifdef TESTING
//        window = [ UIApplication sharedApplication ].windows[0];
//        rootController_ = [ [ UIViewController alloc ] init ];
//        window.rootViewController = rootController_;
//#else
        //window = webView_.window;
        window = [ [ UIApplication sharedApplication ] keyWindow ];
        rootController_ = window.rootViewController;
//#endif
    }
    
    
    if ( !rootController_ )
    {
        SCSocialNetworkPluginError* error = [ SCSocialNetworkPluginError noViewControllerError ];
        [ error setToPointer: errorPtr ];
        
        return nil;
    }
    
    return rootController_;
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSError* error = nil;
    UIViewController* rootVc = [ self findRootViewControllerWithError: &error ];
    if ( nil == rootVc )
    {
        [ self.delegate sendMessage: [ error toJson ] ];
        [ self.delegate close ];
        return;
    }

    NSDictionary* components_ = [ self->_request.URL queryComponents ];

    NSString* text_      = [ components_ firstValueIfExsistsForKey: @"text" ];
    NSArray*  urls_      = components_[ @"url" ];
    NSArray*  imageUrls_ = components_[ @"image_url" ];
    
    NSLocale *posixLocale = [ [NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX" ];
    NSString* socialEngine = [ [ components_ firstValueIfExsistsForKey: @"social_engine" ] lowercaseStringWithLocale:posixLocale ];
    
    self->_poster = [ SCSocialFactory newPosterNamed: socialEngine ];
    if ( nil == self->_poster )
    {
        SCSocialNetworkPluginError* error = [ SCSocialNetworkPluginError unknownSocialNetworkError ];
        
        [ self.delegate sendMessage: [ error toJson ] ];
        [ self.delegate close ];
        
        return;
    }

    // initialize poster
    {
        NSArray* images_ = [ [ self class ] imagesFromUrlArray: imageUrls_ ];
        NSArray* links_  = [ [ self class ] linksFromUrlArray : urls_      ];
        
        self->_poster.text   = text_  ;
        self->_poster.images = images_;
        self->_poster.links  = links_ ;
        self->_poster.viewControllerForDialog = rootVc;
    }
    
    id< SCWebPluginDelegate > delegate = self->_delegate;
    __weak JDWSocialNetworkPlugin* weakSelf = self;
    SCAsyncOpResult messagePosted = ^void( id result, NSError* error )
    {
        if ( nil == result )
        {
            [ delegate sendMessage: [ error toJson ] ];
        }
        else
        {
            [ delegate sendMessage: @"{}" ];
        }
        
        [ delegate close ];
        weakSelf.poster = nil; // bad access on "operator->" usage
    };
    
    [ self->_poster postWithCompletion: messagePosted ];
}

@end
