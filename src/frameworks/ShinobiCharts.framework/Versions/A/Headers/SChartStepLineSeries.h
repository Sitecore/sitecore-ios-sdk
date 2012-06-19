//
//  SChartStepLineSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartLineSeries.h"

/** 
 SChartStepLineSeries is a type of SChartLineSeries that uses the data points to construct a step line series. 
 
 The step line series consists of a number of points which may or may not be marked, that are connected by a stepping line with an optional fill (ie: area series) between the line and x-axis.
 
 Series are always drawn in order with the lowest series index first. This means that higher numbered series sit on top and potentially obscure lower numbered series.
 
    Hint: When styling use the UIColor properties to control the alpha of the series parts.
 */
@interface SChartStepLineSeries : SChartLineSeries

@end
