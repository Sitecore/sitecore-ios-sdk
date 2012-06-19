//
//  SChartLineSeriesStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartSeriesStyle.h"

@class SChartPointStyle;

typedef enum {
    SChartLineCrosshairTraceStyleHorizontal,
    SChartLineCrosshairTraceStyleVertical,
} SChartLineCrosshairTraceStyle;

/** The styling properties for line series on the chart
 
 */
@interface SChartLineSeriesStyle : SChartSeriesStyle 
/** @name Styling properties */
/** Should the area between the line and the axis be filled? */
@property (nonatomic)             BOOL      showFill;
@property (nonatomic)             BOOL      showFillSet;

/** Use the areaColorLowGradient to produce a gradient fill */
@property (nonatomic)             BOOL      fillWithGradient;
@property (nonatomic)             BOOL      fillWithGradientSet;

/** The color of the line */
@property (nonatomic, retain)     UIColor   *lineColor;
/** The color of the line below the baseline */
@property (nonatomic, retain)     UIColor   *lineColorBelowBaseline;
/** The width of the line in pixels */
@property (nonatomic, retain)     NSNumber  *lineWidth;
/** The color of the fill between the line and the axis */
@property (nonatomic, retain)     UIColor   *areaColor;
/** The second color to form a gradient area fill */
@property (nonatomic, retain)     UIColor   *areaColorLowGradient;
/** The color of the fill between the line and the axis below the baseline */
@property (nonatomic, retain)     UIColor   *areaColorBelowBaseline;
/** The second color to form a gradient area fill below the baseline */
@property (nonatomic, retain)     UIColor   *areaColorGradientBelowBaseline;

/** The style properties for points that are not selected */
@property (nonatomic, retain)     SChartPointStyle *pointStyle;
/** The style attributes for points that are selected */
@property (nonatomic, retain)     SChartPointStyle *selectedPointStyle;

/** The direction of the line data to allow the crosshair to traverse it smoothly
 
 Line data points my be ordered from left to right (x-value sorted) or top to bottom (y-value sorted). This parameter lets the chart know to aid the tracing process.
 
 <code>typedef enum {<br>
 SChartLineCrosshairTraceStyleHorizontal,<br>
 SChartLineCrosshairTraceStyleVertical<br>
 } SChartLineCrosshairTraceStyle;</code>
 */
@property (nonatomic)             SChartLineCrosshairTraceStyle lineCrosshairTraceStyle;
@property (nonatomic)             BOOL                          lineCrosshairTraceStyleSet;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartLineSeriesStyle *)style;

@end
