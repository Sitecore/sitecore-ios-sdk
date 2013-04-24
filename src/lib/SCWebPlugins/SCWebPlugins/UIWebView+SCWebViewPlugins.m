#import "UIWebView+SCWebViewPlugins.h"

#import "SCWebPlugin.h"
#import "SCWebViewPluginHolder.h"
#import "SCWebViewTapGestureRecognizer.h"
#import "UIWebView+SCWebViewStates.h"

#include "pathToAllPluginsJavascripts.h"

//STODO remove
@interface SCWebSocketServer : NSObject

+(void)start;
+(UInt16)port;

@end

//STODO remove
@interface NSString (PathToDWFileURL_SCWebViewPlugins)

-(NSString*)dwFilePath;

@end

//STODO remove
@interface UIDevice(Private_SCWebViewPlugins)

- (NSString *) uniqueDeviceIdentifier;

@end

@interface NSString (SCWebViewPlugins)
@end

@implementation NSString (SCWebViewPlugins)

-(BOOL)scCloseSocketPath
{
    return [ self isEqualToString: @"/didClose" ];
}

@end

@implementation UIWebView (SCWebViewPlugins)

-(void)addSCHookTouchesView
{
    if ( self.scHookTouchesViewEnabled )
        return;

    self.scHookTouchesViewEnabled = YES;

    UITapGestureRecognizer* rec_ = [ SCWebViewTapGestureRecognizer new ];
    [ self addGestureRecognizer: rec_ ];
}

-(void)enableSCWebViewPlugins
{
    static NSString* const javascript_enabled_ = @"function f(){ return __scmobile_webview_plugins_enabled; } f();";

    NSString* result_ = [ self stringByEvaluatingJavaScriptFromString: javascript_enabled_ ];
    if ( [ @"true" isEqualToString: result_ ] )
        return;

    [ self stringByEvaluatingJavaScriptFromString: @"__scmobile_webview_plugins_enabled = true;\n" ];
    [ self stringByEvaluatingJavaScriptFromString: javascript_enabled_ ];


    {
        NSString *deviceName = [ [ UIDevice currentDevice ] name ];
        NSString *deviceId = [ [ UIDevice currentDevice ] uniqueDeviceIdentifier ];
        NSString *systemVersion = [ [ UIDevice currentDevice ] systemVersion ];
        int port = [ SCWebSocketServer port ];
        
        NSString *js_ = [ self getInjectionScriptWithDeviceName: deviceName
                                                       deviceId: deviceId
                                                  systemVersion: systemVersion
                                                     socketPort: port ];
        
        NSString *result = [ self stringByEvaluatingJavaScriptFromString: js_ ];
        NSLog(@"result: %@", result);
    }

    [ self addSCHookTouchesView ];
}

-(NSString*)getInjectionScriptWithDeviceName: ( NSString * ) deviceName
                                    deviceId: ( NSString * ) deviceId
                               systemVersion: ( NSString * ) systemVersion
                                  socketPort: ( int ) port
{
    
    deviceName    = deviceName    ? : @"";
    deviceId      = deviceId      ? : @"";
    systemVersion = systemVersion ? : @"";
    
    NSString* inject_sc_format_ =
    @"function createScriptElementWithWebPlugins() {\n"
    "var headID = document.getElementsByTagName('head')[0];\n"
    "var newScript = document.createElement('script');\n"
    "newScript.type = 'text/javascript';\n"
    "newScript.onload = function(){\n"
    "%@\n"
    "scmobile.device.__fireDeviceReady();\n"
    "};\n"
    "newScript.src = '%@';\n"
    "return headID.appendChild(newScript);\n"
    "}\n"
    "createScriptElementWithWebPlugins();\n";
    
    //STODO create AllJavascripts in separate thread
    NSString* pathToPluginsJS = pathToAllPluginsJavascripts();
    NSString* js_path_ = [ pathToPluginsJS dwFilePath ];
    
    
    NSString *deviceNameWithEscapes = [ deviceName stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
    deviceNameWithEscapes = [ deviceNameWithEscapes stringByReplacingJSEscapes ];
    
    NSMutableArray* settings_ = [ NSMutableArray new ];
    [ settings_ addObject: [ NSString stringWithFormat: @"scmobile.device.name = unescape('%@');"
                            , deviceNameWithEscapes ] ];
    [ settings_ addObject: [ NSString stringWithFormat: @"scmobile.device.uuid = '%@';"
                            ,  deviceId ] ];
    [ settings_ addObject: [ NSString stringWithFormat: @"scmobile.device.version = '%@';"
                            , systemVersion ] ];
    [ settings_ addObject: [ NSString stringWithFormat: @"scmobile.device.socketPort = '%d';"
                            , port ] ];
    
    NSString* result_ = [ NSString stringWithFormat: inject_sc_format_
                     , [ settings_ componentsJoinedByString: @"\n" ]
                     , js_path_ ];
    
    return result_;
}


-(BOOL)applyPluginToRequest:( NSURLRequest* )request_
{
    NSString* scheme_ = [ request_.URL scheme ];
    if ( ![ scheme_ isEqualToString: @"sc" ] )
        return NO;

    NSString* socketGuid_ = [ [ request_.URL queryComponents ] firstValueIfExsistsForKey: @"guid" ];
    NSString* path_ = request_.URL.path;
    SCWebViewPluginHolder* holder_ = self.pluginBySocketGuid[ socketGuid_ ];

    if( !holder_ && [ path_ scCloseSocketPath ] )
    {
        //try to close closed socket
        return YES;
    }

    if ( holder_ )
    {
        if ( [ path_ scCloseSocketPath ] )
        {
            [ holder_ didClose ];
            [ self.pluginBySocketGuid removeObjectForKey: socketGuid_ ];
        }
        else
        {
            NSString* message_ = [ [ request_.URL queryComponents ] firstValueIfExsistsForKey: @"message" ];
            [ holder_ didReceiveMessage: message_ ];
        }
    }
    else
    {
        holder_ = [ SCWebViewPluginHolder webViewPluginHolderForRequest: request_ ];
        self.pluginBySocketGuid[ socketGuid_ ] = holder_;
        [ holder_ didOpenInWebView: self ];
    }

    return YES;
}

@end
