//
//  SChartScatterSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

#import "SChartCartesianSeries.h"
#import "SChartScatterSeriesStyle.h"

/** SChartScatterSeries is a type of SChartSeries that uses the data points to construct a scatter series.  */

@interface SChartScatterSeries : SChartCartesianSeries

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartScatterSeriesStyle` contains all of the objects relevant to styling a scatter series. */
-(SChartScatterSeriesStyle *)style;
-(void)setStyle:(SChartScatterSeriesStyle *)style;

/** Style settings in this object will be applied when the series is marked as selected (or a datapoint is selected).*/
-(SChartScatterSeriesStyle *)selectedStyle;
-(void)setSelectedStyle:(SChartScatterSeriesStyle *)selectedStyle;


@end
