#import "SCWebViewTapGestureRecognizer.h"

@interface UIWebView (SCWebViewTapGestureRecognizer)

@property ( nonatomic, retain ) NSString* scLastTouchLocationPoint;

@end

@interface SCWebViewTapGestureRecognizer () < UIGestureRecognizerDelegate >
@end

@implementation SCWebViewTapGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [ super initWithTarget: self action: @selector( setTouchLocationToWebView: ) ];

    self.delegate = self;

    return self;
}

-(BOOL)canBePreventedByGestureRecognizer:( id )sender_
{
    return NO;
}

-(void)setTouchLocationToWebView:( UITapGestureRecognizer* )sender_
{
    UIWebView* parent_ = (UIWebView*)sender_.view;

    if ( [ parent_ respondsToSelector: @selector( setScLastTouchLocationPoint: ) ] )
    {
        CGPoint location_ = [ sender_ locationInView: sender_.view ];
        parent_.scLastTouchLocationPoint = NSStringFromCGPoint( location_ );
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
