#import "NavigationToolbar.h"

@implementation NavigationToolbar

@synthesize backButton;
@synthesize forwardButton;
@synthesize activityIndicator;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame: frame ];

    if ( self )
    {
        self.backgroundColor = [ UIColor colorWithPatternImage: [ UIImage imageNamed: @"bg_black.png" ] ];
        
        self.backButton = [ UIButton new ];
        self.forwardButton = [ UIButton new ];
        self.activityIndicator = [ UIActivityIndicatorView new ];

        UIImage* button_image_ = [ UIImage imageNamed: @"arrowright.png"];
        [ self.forwardButton  setBackgroundImage: button_image_ forState: UIControlStateNormal ];
        button_image_ = [ UIImage imageNamed: @"arrowleft.png"];
        [ self.backButton  setBackgroundImage: button_image_ forState: UIControlStateNormal ];
        [ self.forwardButton setFrame:CGRectMake( 60.f, 7.f, 20.f, 20.f ) ];
        [ self.backButton setFrame:CGRectMake( 20.f, 7.f, 20.f, 20.f ) ];
        
        [ self.backButton addTarget: self 
                             action: @selector( goBack: ) 
                   forControlEvents: UIControlEventTouchUpInside ];
        [ self.forwardButton addTarget: self 
                                action: @selector( goForward: ) 
                      forControlEvents: UIControlEventTouchUpInside ];

        
        [ self addSubview: self.forwardButton ];
        [ self addSubview: self.backButton ];

        [ self addSubview: self.activityIndicator ];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [ super layoutSubviews ];

    [ self.activityIndicator setFrame:CGRectMake( self.frame.size.width - 27, 7.f, 20.f, 20.f ) ];
}

- (void)didStartLoadingWebBrowser:(SCWebBrowser*)webBrowser
{
    [ self.activityIndicator startAnimating ];
}

- (void)didStopLoadingWebBrowser:(SCWebBrowser*)webBrowser
{
    [self.activityIndicator stopAnimating];
}

#pragma mark Forward Actions

- (void)goBack:(id)sender
{
    [ self.delegate goBackWebBrowserNavigator:self ];
}

- (void)goForward:(id)sender
{
    [ self.delegate goForwardWebBrowserNavigator:self ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


@end
