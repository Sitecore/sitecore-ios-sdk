//
//  SChartLineSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartCartesianSeries.h"

typedef enum {
    SChartLineFillDirectionHorizontal,
    SChartLineFillDirectionVertical,
} eFillDirection;

/** 
 SChartLineSeries is a type of SChartSeries that uses the data points to construct a line series. The line series consists of a number of points which may or may not be marked, that are connected by a line with an optional fill (ie: area series) between the line and x-axis.
 
 Series are always drawn in order with the lowest series index first. This means that higher numbered series sit on top and potentially obscure lower numbered series.
 
    Hint: When styling use the UIColor properties to control the alpha of the series parts.
 */
@interface SChartLineSeries : SChartCartesianSeries {
@protected
    BOOL stepLine;
}

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartLineSeriesStyle` contains all of the objects relevant to styling a line series. */
-(SChartLineSeriesStyle *)style;

-(void)setStyle:(SChartLineSeriesStyle *)style;

/** Style settings in this object will be applied when the series is marked as selected (or a datapoint is selected).*/
-(SChartLineSeriesStyle *)selectedStyle;

-(void)setSelectedStyle:(SChartLineSeriesStyle *)selectedStyle;

@end
