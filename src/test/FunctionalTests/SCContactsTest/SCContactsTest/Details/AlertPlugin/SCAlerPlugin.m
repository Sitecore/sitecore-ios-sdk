#import "SCWebPlugin.h"

@interface SCAlerPlugin : NSObject < SCWebPlugin >

@property ( nonatomic, strong ) NSURLRequest* request;
@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation SCAlerPlugin

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
    return [ request_.URL.path isEqualToString: @"/sitecore/close_alert" ];
}

//STODO move to GTestsUtils lib
-(void)hideActiveAlertWithIndex:( NSUInteger )index_
{
    UIApplication* application_ = [ UIApplication sharedApplication ];
    UIAlertView* alert_ = (UIAlertView*)[ application_.keyWindow findSubviewOfClass: [ UIAlertView class ] ];

    NSArray* buttons_ = [ alert_.subviews select: ^BOOL( id object_ )
    {
        return [ object_ isKindOfClass: [ UIButton class ] ];
    } ];

    UIButton* button_ = [ buttons_ noThrowObjectAtIndex: index_ ];
    [ button_ sendActionsForControlEvents: UIControlEventTouchUpInside ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSArray* components_ = [ self.request.URL queryComponents ][ @"bt" ];
    NSUInteger index_ = [ [ components_ noThrowObjectAtIndex: 0 ] integerValue ];

    [ self hideActiveAlertWithIndex: index_ ];
}

@end
