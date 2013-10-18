#import "SCWaitView.h"

@implementation SCWaitView
{
    __weak UIView* _superview;
    __weak UIActivityIndicatorView* _activity;
    CGFloat _cornerRadius;
}

-(instancetype)initWithFrame:( CGRect )frame
                cornerRadius:( CGFloat )cornerRadius
                   superview:( UIView* )superview
{
    self = [ super initWithFrame: frame ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_cornerRadius = cornerRadius;
    self->_superview = superview;
    self.backgroundColor = [ UIColor grayColor ];
    
    return self;
}

-(void)show
{
    CGRect superviewFrame = self->_superview.frame;
    CGSize superviewSize = superviewFrame.size;
    
    self.center = CGPointMake( superviewSize.width / 2, superviewSize.height / 2 );
    self.layer.cornerRadius = self->_cornerRadius;

    if ( nil == self->_activity )
    {
        UIActivityIndicatorView* activity = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge ];

        [ self addSubviewAndScale: activity ];
        self->_activity = activity;
    }
    
    [ self->_activity startAnimating ];
    [ self->_superview addSubview: self ];
}

-(void)hide
{
    [ self->_activity stopAnimating ];
    [ self removeFromSuperview ];
}

@end
