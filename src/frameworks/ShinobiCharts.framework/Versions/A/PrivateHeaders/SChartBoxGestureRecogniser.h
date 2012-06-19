//
//  SChartPinchPanGestureRecogniser.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface SChartBoxGestureRecogniser : UIGestureRecognizer {
#ifdef CANVAS_DRAW_TOUCH_POINTS
@public
#endif
    UITouch *_touches[2];
    CGPoint  _initialTouch;
    
    int  _nFingersDown;
    int  _lastReleasedTouch;

    BOOL _hadTwoFingers; // that's what she said
}

#pragma mark -
#pragma mark Touch Methods
- (void)reset;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

#pragma mark -
#pragma mark Touch Methods
- (CGRect)boxInView:(UIView *)view;

@end
