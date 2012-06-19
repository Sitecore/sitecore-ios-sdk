//
//  SChartPieSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

/** An SChartPieSeries displays magnitude data on the chart - the larger the value of the datapoint, the larger the slice representing that datapoint.
 
 Whereas datapoints for Cartesian Series require an X and a Y, Radial Series require a name and a value. 
 The xValue of a datapoint given to a Pie Series is used as the name of the slice, and the yValue is used as its magnitude.
 See 'SChartRadialDatapoint' for a convenience datapoint class.
 
 Tip: Styles for each individual slice can be configured in the series' SChartPieSeriesStyle.
 Tip: Legends on pie charts show an entry for each datapoint, or slice, of a pie chart.
 
 *Related Classes:*
 
 SChartPieSeriesStyle <br>
 SChartRadialSeries <br>
 SChartDonutChart <br>
 SChartRadialDataPoint <br>
 
 */

#import "SChartDonutSeries.h"

@class SChartPieSeriesStyle;

@interface SChartPieSeries : SChartDonutSeries

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartPieSeriesStyle` contains all of the objects relevant to styling a pie series. */
-(SChartPieSeriesStyle *)style;

-(void)setStyle:(SChartPieSeriesStyle *)style;

/** Style settings in this object will be applied when the series is marked as selected (or a slice is selected).*/
-(SChartPieSeriesStyle *)selectedStyle;

-(void)setSelectedStyle:(SChartPieSeriesStyle *)selectedStyle;


@end
