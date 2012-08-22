#import "SCNavigationHeader.h"

#import "SCWebBrowser.h"

static CGFloat navigation_button_width_ = 30.f;
static CGFloat navigation_button_height_ = 30.f;

static CGFloat navigation_button_indent_ = 10.f;

@interface SCNavigationHeader ()

@property ( nonatomic ) UIButton* backwardButton;
@property ( nonatomic ) UIButton* forwardButton;
@property ( nonatomic ) UIActivityIndicatorView* activityIndicator;

@end

@implementation SCNavigationHeader

-(id)initWithFrame:( CGRect )frame_
{
    self = [ super initWithFrame: frame_ ];

    if ( self )
    {
        // init your custom navigation view
        self.backgroundColor = [ UIColor redColor ];

        self.backwardButton = [ UIButton buttonWithType: UIButtonTypeCustom ];
        self.backwardButton.frame = [ self backButtonRect ];
        [ self.backwardButton setTitle: @"<" forState: UIControlStateNormal ];
        [ self addSubview: self.backwardButton ];
        [ self.backwardButton addTarget: self
                                 action: @selector( goBackward: )
                       forControlEvents: UIControlEventTouchUpInside ];

        self.forwardButton = [ UIButton buttonWithType: UIButtonTypeCustom ];
        self.forwardButton.frame = [ self forwardButtonRect ];
        [ self.forwardButton setTitle: @">" forState: UIControlStateNormal ];
        [ self addSubview: self.forwardButton ];
        [ self.forwardButton addTarget: self
                                action: @selector( goForward: )
                      forControlEvents: UIControlEventTouchUpInside ];

        self->_activityIndicator = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray ];
        self.activityIndicator.frame = [ self activityIndicatorRect ];
        [ self addSubview: self.activityIndicator ];
    }

    return self;
}

-(CGRect)backButtonRect
{
    return CGRectMake( navigation_button_indent_
                      , navigation_button_indent_ / 2.f
                      , navigation_button_width_
                      , navigation_button_height_ );
}

-(CGRect)forwardButtonRect
{
    return CGRectMake( navigation_button_indent_ * 2 + navigation_button_width_
                      , navigation_button_indent_ / 2.f
                      , navigation_button_width_
                      , navigation_button_height_ );
}

-(CGRect)activityIndicatorRect
{
    CGFloat x_ = self.frame.size.width
        - navigation_button_indent_
        - self.activityIndicator.frame.size.width;
    return CGRectMake( x_
                      , navigation_button_indent_
                      , self.activityIndicator.frame.size.width
                      , self.activityIndicator.frame.size.height );
}

-(void)layoutSubviews
{
    self.backwardButton   .frame = [ self backButtonRect ];
    self.forwardButton    .frame = [ self forwardButtonRect ];
    self.activityIndicator.frame = [ self activityIndicatorRect ];
}

-(void)didStartLoadingWebBrowser:( SCWebBrowser* )webBrowser_
{
    [ self.activityIndicator startAnimating ];
}

-(void)didStopLoadingWebBrowser:( SCWebBrowser* )webBrowser_
{
    [ self.activityIndicator stopAnimating ];
}

#pragma mark Forward Actions

-(void)goBackward:( id )sender_
{
    [ self.delegate goBackWebBrowserNavigator: self ];
}

-(void)goForward:( id )sender_
{
    [ self.delegate goForwardWebBrowserNavigator: self ];
}

@end
