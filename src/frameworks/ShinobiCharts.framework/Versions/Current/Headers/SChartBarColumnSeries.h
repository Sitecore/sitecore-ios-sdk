//
//  SChartBarColumnSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartCartesianSeries.h"
#import "SChartBarColumnSeriesStyle.h"
#import "SChartAnimationCurve.h"

/** This is the base class for column and bar series - containing all of the common functions between the two. To display a bar or column series on the chart init and use one of the classes SChartBarSeries or SChartColumnSeries respectively. */
@interface SChartBarColumnSeries : SChartCartesianSeries

#pragma mark -
#pragma mark Config settings


@property (nonatomic, assign) SChartSeriesOrientation orientation;

/** When this flag is set, bars/columns will animate from the baseline to their normal position */
@property (nonatomic) BOOL animated;

/** Animation duration in seconds */
@property (nonatomic) float animationDuration;

/** Animation curve
 
<code>typedef enum {<br>
    SChartAnimationCurveLinear,<br>
    SChartAnimationCurveEaseIn,<br>
    SChartAnimationCurveEaseOut,<br>
    SChartAnimationCurveEaseInOut,<br>
    SChartAnimationCurveBounce,<br>
} SChartAnimationCurve;</code>

Default `SChartAnimationCurveLinear` */
@property (nonatomic) SChartAnimationCurve animationCurve;

@end
