//
//  SChartBandSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartCartesianSeries.h"
#import "SChartBandSeriesStyle.h"

/** 
 SChartBandSeries is a type of SChartSeries that uses the data points to construct a band series. 
 
 An SChartBandSeries' datapoints should implement the <code>-(id)sChartXValueForKey:</code> or <code>-(id)sChartYValueForKey:</code> methods of the SChartData protocol, depending on series orientation, in order to provide the High and Low values to the chart.
 
 The key values are:
    SChartBandSeriesHigh
    SCHartBandSeriesLow
 
 The Band Series is visualised as two Line Series, one for the High values and one for the Low, with an area fill between the lines. 
 The colour of this fill depends on the relationship between the lines, ie. it may be green if the High value is greater than the Low value, and red if the opposite is true.
 
 *Related Classes:*
 
 SChartBandSeriesStyle <br>
 SChartMultiYDataPoint <br>
 SChartMultiXDataPoint <br>
 
 */

extern NSString *const SChartBandKeyHigh;
extern NSString *const SChartBandKeyLow;

@interface SChartBandSeries : SChartCartesianSeries {
}

@property (nonatomic, readonly) SChartSeriesOrientation orientation;

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartBandSeriesStyle` contains all of the objects relevant to styling a band series. */
-(SChartBandSeriesStyle *)style;

-(void)setStyle:(SChartBandSeriesStyle *)style;

/** Style settings in this object will be applied when the series is marked as selected (or a datapoint is selected).*/
-(SChartBandSeriesStyle *)selectedStyle;

-(void)setSelectedStyle:(SChartBandSeriesStyle *)selectedStyle;

@end
