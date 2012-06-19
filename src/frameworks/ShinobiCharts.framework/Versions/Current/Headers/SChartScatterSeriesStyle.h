//
//  SChartScatterSeriesStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartSeriesStyle.h"

@class SChartPointStyle;

/** The style properties for scatter series on the chart */
@interface SChartScatterSeriesStyle : SChartSeriesStyle 

/** @name Style Properties */
/** The style of points that are not selected */
@property (nonatomic, retain)     SChartPointStyle *pointStyle;
/** The style of points that are selected */
@property (nonatomic, retain)     SChartPointStyle *selectedPointStyle;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartScatterSeriesStyle *)style;

@end
