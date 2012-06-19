//
//  SChartBarSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartBarColumnSeries.h"

/** Displays a bar series on the chart. The properties and methods are also common to columns and therefore contained in the SChartBarColumnSeries super class.
 
 */
@interface SChartBarSeries : SChartBarColumnSeries

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartBarSeriesStyle` contains all of the objects relevant to styling a bar series. */
-(SChartBarSeriesStyle *)style;

-(void)setStyle:(SChartBarSeriesStyle *)style;

/** Style settings in this object will be applied when the series is marked as selected (or a datapoint is selected).*/
-(SChartBarSeriesStyle *)selectedStyle;

-(void)setSelectedStyle:(SChartBarSeriesStyle *)selectedStyle;

@end
