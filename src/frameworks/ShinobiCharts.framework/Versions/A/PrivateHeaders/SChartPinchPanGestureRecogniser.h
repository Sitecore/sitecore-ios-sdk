//
//  SChartPinchPanGestureRecogniser.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

#define PINCH_HISTORY 5
#define CGPointSize(a) sqrt((a).x * (a).x + (a).y * (a).y)

@interface SChartPinchPanGestureRecogniser : UIPanGestureRecognizer {
#ifdef CANVAS_DRAW_TOUCH_POINTS
@public
#endif
    // pinch scaling
    BOOL    _aspectLock;
    CGPoint _lineRatio;
    CGPoint _initialLineRatio;    // these two are for x/y pinching
    CGPoint _lastPinchCentre;     // for "zoom around this point"
    CGPoint _initialTouchPoint;   // for allowableMovement
    BOOL    _lastPinchCentreValid;
    double  _initialPinchDistance; // used for pinch scale
    
    // pinch momentum
    struct PinchRecord
    {
        double xdistance, ydistance;
        double timestamp;
    } _lastPinchDistance[PINCH_HISTORY]; // circular array
    unsigned int _lastPinchDistanceIndex;
    
    // touch points
    NSMutableArray *_lastTouches; // "_touches" is taken by UIPinchGestureRecognizer :|
    
    // touch status
    BOOL _touchChanged; // this indicated the user should re-request the pan point
    enum
    {
        NONE  = 0,
        PAN   = 1,
        PINCH = 2
    } _touchState, _maxTouchState;
    
    // for checking whether we should allow a pan at the end of a gesture
    double _panStart;      // the last point in time that the user started a _single_ finger pan
    BOOL   _doPanMomentum; // the time spent in a single finger pan
}

@property (nonatomic) BOOL aspectLock;
@property (nonatomic) CGFloat movementThreshold;

#pragma mark -
#pragma mark Touch Methods
- (void)reset;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;


#pragma mark -
#pragma mark Gesture Accessors
// these are pinch-gesture methods tagged on to the pan-superclass, since we combine the recognisers
- (CGPoint)scale;    // pinch x-y-relative scales
- (CGPoint)velocity; // pinch velocity

// only valid if pinching
- (BOOL)hasZoomCentre;
- (CGPoint)zoomCentreInView:(UIView *)view;

- (BOOL)touchStateChanged;
- (BOOL)hasPinched;

@end
