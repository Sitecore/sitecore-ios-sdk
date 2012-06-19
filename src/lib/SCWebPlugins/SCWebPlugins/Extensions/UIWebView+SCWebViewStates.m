#import "UIWebView+SCWebViewStates.h"

#include <objc/runtime.h>

static char scHookTouchesViewEnabledKey_;
static char scLastTouchLocationPointKey_;
static char pluginBySocketGuidKey_;

@implementation UIWebView (SCWebViewStates)

-(BOOL)scHookTouchesViewEnabled
{
    return [ objc_getAssociatedObject( self, &scHookTouchesViewEnabledKey_ ) boolValue ];
}

-(void)setScHookTouchesViewEnabled:( BOOL )enabled_
{
    objc_setAssociatedObject( self
                             , &scHookTouchesViewEnabledKey_
                             , [ NSNumber numberWithBool: enabled_ ]
                             , OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-(void)setScLastTouchLocationPoint:(NSString *)scLastTouchLocationPoint
{
    objc_setAssociatedObject( self
                             , &scLastTouchLocationPointKey_
                             , scLastTouchLocationPoint
                             , OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-(NSString*)scLastTouchLocationPoint
{
    return objc_getAssociatedObject( self, &scLastTouchLocationPointKey_ );
}

-(void)setPluginBySocketGuid:(NSString *)pluginBySocketGuid_
{
    objc_setAssociatedObject( self
                             , &pluginBySocketGuidKey_
                             , pluginBySocketGuid_
                             , OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-(JFFMutableAssignDictionary*)pluginBySocketGuid
{
    JFFMutableAssignDictionary* pluginBySocketGuid_ = objc_getAssociatedObject( self, &pluginBySocketGuidKey_ );
    if ( !pluginBySocketGuid_ )
    {
        self.pluginBySocketGuid = [ JFFMutableAssignDictionary new ];
    }
    return pluginBySocketGuid_;
}

@end
