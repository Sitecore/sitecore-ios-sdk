//
//  SChartRadialChartSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SChartSeries.h"

/** This is the base class for radial series.
 
 Currently only donut and pie series are supported.
 To display a pie or donut chart use one of the classes SChartPieSeries or SChartDonutSeries respectively. */

@interface SChartRadialSeries : SChartSeries

/** @name Label Format */
/** A string to format labels annotating data within a radial series, such as a slice in a pie chart.
 
 Setting this property will override the default format of @"%.2f"
 */
@property (nonatomic, retain) NSString               *labelFormatString;


@end
