//
//  SChartColumnSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartBarColumnSeries.h"

/** Displays a column series on the chart. The properties and methods are also common to bars and therefore contained in the SChartBarColumnSeries super class.
 
 */
@interface SChartColumnSeries : SChartBarColumnSeries 

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartColumnSeriesStyle` contains all of the objects relevant to styling a column series. */
-(SChartColumnSeriesStyle *)style;

-(void)setStyle:(SChartColumnSeriesStyle *)style;

/** Style settings in this object will be applied when the series is marked as selected (or a datapoint is selected).*/
-(SChartColumnSeriesStyle *)selectedStyle;

-(void)setSelectedStyle:(SChartColumnSeriesStyle *)selectedStyle;

@end
