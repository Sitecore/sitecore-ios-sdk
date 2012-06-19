//
//  SChartAxisStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SChartTickStyle;
@class SChartTickStyle;
@class SChartMajorGridlineStyle;
@class SChartGridStripeStyle;
@class SChartAxisTitleStyle;
@class SChartAxisStyle;

/** The axis style object controls the look and feel for the axis, tick marks and labels, gridlines and grid stripes.

 */
@interface SChartAxisStyle : NSObject 

/** @name Styling Properties */
/** The UIColor for the axis line */
@property (nonatomic, retain)     UIColor  *lineColor;

/** The width in pixels of the axis line */
@property (nonatomic, retain)     NSNumber *lineWidth;

/** The padding between datapoints of different series where they are plotted on the same axis value.
 
 A value between `0.0` and `1.0` as a percentage of the available space */
@property (nonatomic, retain)     NSNumber *interSeriesPadding;

/** The padding between sets of series' datapoints on neighbouring axis values.
 
 A value between `0.0` and `1.0` as a percentage of the available space */
@property (nonatomic, retain)     NSNumber *interSeriesSetPadding;

/** DEPRECATED - use interSeriesPadding instead of interColumnPadding.
 
 The padding between columns of different series at a data point. A value between `0.0` and `1.0` as a percentage of the available space */
@property (nonatomic, retain)     NSNumber *interColumnPadding DEPRECATED_ATTRIBUTE;

/** DEPRECATED - use interSeriesSetPadding instead of interColumnSetPadding.
 
 The padding between sets of columns on different data points. A value between `0.0` and `1.0` as a percentage of the available space */
@property (nonatomic, retain)     NSNumber *interColumnSetPadding DEPRECATED_ATTRIBUTE;

/** DEPRECATED - use interSeriesPadding instead of interBarPadding. 
 
 The padding between bars of different series at a data point. A value between `0.0` and `1.0` as a percentage of the available space */
@property (nonatomic, retain)     NSNumber *interBarPadding DEPRECATED_ATTRIBUTE;

/** DEPRECATED - use interSeriesSetPadding instead of interBarSetPadding.
 
 The padding between sets of bars on different data points. A value between `0.0` and `1.0` as a percentage of the available space */
@property (nonatomic, retain)     NSNumber *interBarSetPadding DEPRECATED_ATTRIBUTE;

/** An SChartTickStyle object containing styling preferences for the major tick marks */
@property (nonatomic, retain)     SChartTickStyle *majorTickStyle;

/** An SChartTickStyle object containing styling preferences for the minor tick marks */
@property (nonatomic, retain)     SChartTickStyle *minorTickStyle;

/** An SChartMajorGridlineStyle object containing styling preferences for the major gridlines */
@property (nonatomic, retain)     SChartMajorGridlineStyle *majorGridLineStyle;

/** An SChartGridStripeStyle object containing styling preferences for the grid stripes */
@property (nonatomic, retain)     SChartGridStripeStyle *gridStripeStyle;

/** An SChartAxisTitleStyle object containing styling preferences for the axis title */
@property (nonatomic, retain)     SChartAxisTitleStyle *titleStyle;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartAxisStyle *)style;

@end
