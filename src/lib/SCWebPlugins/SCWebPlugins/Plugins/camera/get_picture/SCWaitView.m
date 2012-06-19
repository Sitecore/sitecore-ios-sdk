#import "SCWaitView.h"

@interface SCWaitView ()

@property ( nonatomic ) UIAlertView* alert;

@end

//STODO create beautiful wait screen
@implementation SCWaitView

@synthesize alert = _alert;

-(id)init
{
    self = [ super init ];

    if ( self )
    {
       //STODO use JFFAlertView insted of UIAlertView
        self->_alert = [ [ UIAlertView alloc ] initWithTitle: @"\n"
                                                     message: nil
                                                    delegate: self
                                           cancelButtonTitle: nil
                                           otherButtonTitles: nil ];
    }

    return self;
}

+(id)waitView
{
    return [ [ self alloc ] init ];
}

-(void)show
{
    [ self.alert show ];

    UIActivityIndicatorView* indicator_ = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];

    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator_.center = CGPointMake( self.alert.bounds.size.width / 2
                                    , self.alert.bounds.size.height - 50);
    [ indicator_ startAnimating ];
    [ self.alert addSubview: indicator_ ];
}

-(void)hide
{
    [ self.alert dismissWithClickedButtonIndex: [ self.alert cancelButtonIndex ]
                                      animated: NO ];
}

@end
