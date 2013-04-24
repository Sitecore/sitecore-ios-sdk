#import "SCAbstractTriggerPlugin.h"

#import "analytics.js.h"

@implementation SCAbstractTriggerPlugin

#pragma mark -
#pragma mark init
-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(void)parseRequestParams:( NSURLRequest* )request
{
    NSDictionary* args  = [ request.URL queryComponents ];
    
    self->_itemRenderingUrl = [ args firstValueIfExsistsForKey: @"itemRenderingUrl" ];
    self->_triggerId = [ self parseTriggerIdWithRequestArgs: args ];
}


#pragma mark -
#pragma mark SCWebPlugin
+(NSString*)pluginJavascript
{
    return [ [ NSString alloc ] initWithBytesNoCopy: __SCWebContentApi_analytics_analytics_js
                                             length: __SCWebContentApi_analytics_analytics_js_len
                                           encoding: NSUTF8StringEncoding
                                       freeWhenDone: NO ];
}

-(id)initWithRequest:( NSURLRequest* )request
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    [ self parseRequestParams: request ];

    return self;
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    JFFAsyncOperation action = [ self triggeringAction ];
    id< SCWebPluginDelegate > delegate = self.delegate;
    
    if ( nil == action )
    {
        NSError* error = [ [ SCTriggeringError alloc ] initWithDescription: @"Internal error - no action block available"
                                                                    code: -1 ];
        
        [ delegate sendMessage: [ error toJson ] ];
        [ delegate close ];
        
        return;
    }
    
    action( nil, nil, ^void( id result, NSError* error )
    {
        NSString* message = [ error toJson ];
        if ( nil == message )
        {
            message = @"{}";
        }
        
        [ delegate sendMessage: message ];
        [ delegate close ];
    } );
}

-(BOOL)closeWhenBackground
{
    return YES;
}


#pragma mark -
#pragma mark abstract methods
-(NSString*)parseTriggerIdWithRequestArgs:( NSDictionary* )args
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(JFFAsyncOperation)triggeringAction
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

@end
