//
//  SChartAnimationCurve.h
//  SChart
//
//  Copyright 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    SChartAnimationCurveLinear,
    SChartAnimationCurveEaseIn,
    SChartAnimationCurveEaseOut,
    SChartAnimationCurveEaseInOut,
    SChartAnimationCurveBounce,
} SChartAnimationCurve;


/** Evaluators for custom animation curves. 
    Expects a position between 0.0 .. 1.0, returns a corresponding value on the curve between 0.0 .. 1.0

 <code>typedef enum {<br>
    SChartAnimationCurveLinear,<br>
    SChartAnimationCurveEaseIn,<br>
    SChartAnimationCurveEaseOut,<br>
    SChartAnimationCurveEaseInOut,<br>
    SChartAnimationCurveBounce,<br>
 } SChartAnimationCurve;</code>
 
 */
@interface SChartAnimationCurveEvaluator

+ (float)evaluateCurve:(SChartAnimationCurve)curve atPosition:(float)position;

@end 
