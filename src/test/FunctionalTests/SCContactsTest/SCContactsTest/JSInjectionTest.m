#import <UIKit/UIKit.h>
#import <SCWebPlugins/SCWebPlugins/UIWebView+SCWebViewPlugins.h>
#import <SCWebPlugins/SCWebPlugins/Details/pathToAllPluginsJavascripts.h>
#import <SCDevice2Web/Extensions/NSString+PathToDWFileURL.h>

#import <objc/message.h>

@interface SocialPluginsTest : GHTestCase
@end


@implementation SocialPluginsTest

-(void)setUp
{

}

-(void)tearDown
{

}

-(void)testInjectionScriptWithNillValues
{    
    __block NSString *expectedResult;
    __block NSString *result;
    
    dispatch_sync( dispatch_get_main_queue(), ^{
        
        UIWebView *webView = [[ UIWebView alloc ] initWithFrame:CGRectMake(0, 0, 100, 100)];
        result = objc_msgSend( webView,
                                @selector(getInjectionScriptWithDeviceName:deviceId:systemVersion:socketPort:),
                                nil,
                                nil,
                                nil,
                                0 );
        
        NSString *expectedResultTemplate = @"function createScriptElementWithWebPlugins() {\n"
            "var headID = document.getElementsByTagName('head')[0];\n"
            "var newScript = document.createElement('script');\n"
            "newScript.type = 'text/javascript';\n"
            "newScript.onload = function(){\n"
            "scmobile.device.name = unescape( decodeURIComponent('') );\n"
            "scmobile.device.uuid = '';\n"
            "scmobile.device.version = '';\n"
            "scmobile.device.socketPort = '0';\n"
            "scmobile.device.__fireDeviceReady();\n"
            "};\n"
            "newScript.src = '%@';\n"
            "return headID.appendChild(newScript);\n"
        "}\n"
        "createScriptElementWithWebPlugins();\n";
        
        NSString* pathToPluginsJS = pathToAllPluginsJavascripts();
        NSString* js_path_ = [ pathToPluginsJS dwFilePath ];
        
        expectedResult = [ NSString stringWithFormat:expectedResultTemplate , js_path_];
                
    });
    
    GHAssertEqualStrings(result, expectedResult, @"unexpected injection script");
}

-(void)testInjectionScriptWithSpecialSymbolsInName
{
    __block NSString *expectedResult;
    __block NSString *result;
    
    dispatch_sync( dispatch_get_main_queue(), ^{
        
        UIWebView *webView = [[ UIWebView alloc ] initWithFrame:CGRectMake(0, 0, 100, 100)];
        result = objc_msgSend( webView,
                              @selector(getInjectionScriptWithDeviceName:deviceId:systemVersion:socketPort:),
                              @"aa'aa a\\a",
                              nil,
                              nil,
                              0 );
        
        NSString *expectedResultTemplate = @"function createScriptElementWithWebPlugins() {\n"
        "var headID = document.getElementsByTagName('head')[0];\n"
        "var newScript = document.createElement('script');\n"
        "newScript.type = 'text/javascript';\n"
        "newScript.onload = function(){\n"
        "scmobile.device.name = unescape( decodeURIComponent('aa\\'aa%%20a%%5Ca') );\n"
        "scmobile.device.uuid = '';\n"
        "scmobile.device.version = '';\n"
        "scmobile.device.socketPort = '0';\n"
        "scmobile.device.__fireDeviceReady();\n"
        "};\n"
        "newScript.src = '%@';\n"
        "return headID.appendChild(newScript);\n"
        "}\n"
        "createScriptElementWithWebPlugins();\n";
        
        NSString* pathToPluginsJS = pathToAllPluginsJavascripts();
        NSString* js_path_ = [ pathToPluginsJS dwFilePath ];
        
        expectedResult = [ NSString stringWithFormat:expectedResultTemplate , js_path_];
        
    });
    
    GHAssertEqualStrings(result, expectedResult, @"unexpected injection script");
}


@end
