#import "SCGestureRecognizer.h"

@interface SCDoubleTapGestureRecognizer : UITapGestureRecognizer
@end

@implementation SCDoubleTapGestureRecognizer

-(id)initWithView:( UIView* )view_
{
    self = [ super init ];

    if ( self )
    {
        [ self setDelaysTouchesBegan: YES ];
        [ self setNumberOfTapsRequired: 2 ];
        [ view_ addGestureRecognizer: self ];
    }

    return self;
}

-(BOOL)canBePreventedByGestureRecognizer:( UIGestureRecognizer* )preventingGestureRecognizer_
{
    return NO;
}

-(BOOL)canPreventGestureRecognizer:( UIGestureRecognizer* )preventedGestureRecognizer
{
    return NO;
}

@end

@interface SCGestureRecognizer () < UIGestureRecognizerDelegate >
@end

@implementation SCGestureRecognizer 
{
    UITapGestureRecognizer* _doubleTap;
    __weak UIView* _viewToIgnoreTouches;
}

@synthesize scDelegate = _scDelegate;

+(id)recognizerWithView:( UIView* )view_
    viewToIgnoreTouches:( UIView* )viewToIgnoreTouches_
{
    return [ [ SCGestureRecognizer alloc ] initWithView: view_
                                    viewToIgnoreTouches: viewToIgnoreTouches_ ];
}

-(id)initWithView:( UIView* )view_
viewToIgnoreTouches:( UIView* )viewToIgnoreTouches_
{
    self = [ super init ];

    if ( self )
    {
        self.cancelsTouchesInView = NO;
        self.delegate = self;

        _viewToIgnoreTouches = viewToIgnoreTouches_;

        _doubleTap = [ [ SCDoubleTapGestureRecognizer alloc ] initWithView: view_ ];

        [ self requireGestureRecognizerToFail: _doubleTap ];
        [ self setDelaysTouchesBegan: YES ];
        [ self setNumberOfTapsRequired: 1 ];
        [ view_ addGestureRecognizer: self ];
    }

    return self;
}

-(BOOL)canBePreventedByGestureRecognizer:( UIGestureRecognizer* )preventingGestureRecognizer_
{
    return NO;
}

- (BOOL)canPreventGestureRecognizer:( UIGestureRecognizer* )preventedGestureRecognizer_
{
    return NO;
}

#pragma mark UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:( UIGestureRecognizer* )gestureRecognizer
      shouldReceiveTouch:( UITouch* )touch_
{
    if ( [ touch_.view isDescendantOfView: _viewToIgnoreTouches ] )
    {
        [ self.scDelegate gestureRecognizer: self
                     didReceiveReceiveTouch: touch_ ];
        return NO;
    }

    return YES;
}

@end
