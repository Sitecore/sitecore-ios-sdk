#include "SCMobilePluginsJavaScriptExport.h"

#import "scmobile.js.h"

NSString* scWebPluginsCoreJavascript( void )
{
    static NSString* result_ = nil;
    if ( !result_ )
    {
        result_ = [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Javascript_scmobile_js
                                              length: __SCWebPlugins_Javascript_scmobile_js_len
                                            encoding: NSUTF8StringEncoding ];
    }
    return result_;
}
