//
//  SChartBandSeriesStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartLineSeriesStyle.h"

@class SChartPointStyle;

/** The styling properties for band series on the chart
 
 */
@interface SChartBandSeriesStyle : SChartSeriesStyle 
/** @name Styling properties */
/** Should the area between the linea be filled? */
@property (nonatomic)             BOOL      showFill;
@property (nonatomic)             BOOL      showFillSet;

/** The color of the high line */
@property (nonatomic, retain)     UIColor   *lineColorHigh;
/** The color of the low line */
@property (nonatomic, retain)     UIColor   *lineColorLow;
/** The width of the line in pixels */
@property (nonatomic, retain)     NSNumber  *lineWidth;
/** The color of the fill between the lines when the high line is above the low line */
@property (nonatomic, retain)     UIColor   *areaColorNormal;
/** The color of the fill between the lines when the low line is above the high line */
@property (nonatomic, retain)     UIColor   *areaColorInverted;

/** The style properties for points that are not selected */
@property (nonatomic, retain)     SChartPointStyle *pointStyle;
/** The style attributes for points that are selected */
@property (nonatomic, retain)     SChartPointStyle *selectedPointStyle;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartBandSeriesStyle *)style;

@end
