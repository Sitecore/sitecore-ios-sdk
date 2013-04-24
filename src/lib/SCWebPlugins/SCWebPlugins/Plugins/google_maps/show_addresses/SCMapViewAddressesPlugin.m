#import "SCWebPlugin.h"

#import <SCMap/SCMapViewController.h>

#import "NSArray+AddressesDictionariesWithJSON.h"
#import "SCMobileMapPluginError.h"

#import "google_maps.js.h"

//STODO move to SCMap project
@interface SCMapViewAddressesPlugin : NSObject < SCWebPlugin >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation SCMapViewAddressesPlugin
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
    return [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_google_maps_google_maps_js
                                       length: __SCWebPlugins_Plugins_google_maps_google_maps_js_len
                                     encoding: NSUTF8StringEncoding ];
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/google_maps/showAdresses" ];
}

-(void)showGoogleMapWithAddresses:( NSArray* )addresses_
                          webView:( UIWebView* )webView_
                        drawRoute:( BOOL )drawRoute_
                     regionRadius:( CLLocationDistance )regionRadius_
{
    if ( !webView_.window )
    {
        SCMobileMapPluginError* error = [ [ SCMobileMapPluginError alloc ] initWithDescription: @"Root view controller not found"
                                                                                         code: 1 ];
        
        [ self.delegate sendMessage: [ error toJson ] ];
        [ self.delegate close ];
        return;
    }

    UIViewController* rootController_ = webView_.window.rootViewController;

    SCMapViewController* mapController_ = [ SCMapViewController new ];
    mapController_.addresses    = addresses_;
    mapController_.drawRoute    = drawRoute_;
    mapController_.regionRadius = regionRadius_;

    if ( rootController_ )
    {
        [ rootController_ presentTopViewController: mapController_ ];
    }
    else
    {
        webView_.window.rootViewController = mapController_;
    }
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSDictionary* components_ = [ _request.URL queryComponents ];

    NSString* addressesJSONStr_ = [ components_ firstValueIfExsistsForKey: @"addresses" ];
    NSArray* addresses_ = [ NSArray contactAddressesDictionariesWithJSON: addressesJSONStr_ ];

    BOOL drawRoute_                  = [ [ components_ firstValueIfExsistsForKey: @"drawRoute" ] boolValue ];
    CLLocationDistance regionRadius_ = [ [ components_ firstValueIfExsistsForKey: @"regionRadius" ] doubleValue ];

    [ self showGoogleMapWithAddresses: addresses_
                              webView: webView_
                            drawRoute: drawRoute_
                         regionRadius: regionRadius_ ];

    [ self.delegate close ];
}

@end
