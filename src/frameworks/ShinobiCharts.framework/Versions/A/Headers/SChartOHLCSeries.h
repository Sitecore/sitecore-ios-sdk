//
//  SChartOHLCSeries.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartBarColumnSeries.h"
#import "SChartOHLCSeriesStyle.h"

/** SChartOHLCSeries is a type of SChartSeries which displays Open-High-Low-Close data on a chart.
 
 An SChartOHLCSeries' datapoints should implement the <code>-(id)sChartXValueForKey:</code> or <code>-(id)sChartYValueForKey:</code> methods of the SChartData protocol, depending on series orientation, in order to provide the Open, High, Low, and Close values to the chart.
 
 The key values are:
    SChartOHLCKeyOpen
    SChartOHLCKeyHigh
    SChartOHLCKeyLow
    SChartOHLCKeyClose
 
 The OHLC series is visualised as a line between the high and low values, with short perpendicular bars indicating the open and close positions.
 
 *Related Classes:*
 
 SChartOHLCSeriesStyle <br>
 SChartCandlestickSeries <br>
 SChartMultiYDataPoint <br>
 SChartMultiXDataPoint <br>
 
 */

extern NSString *const SChartOHLCKeyOpen;
extern NSString *const SChartOHLCKeyHigh;
extern NSString *const SChartOHLCKeyLow;
extern NSString *const SChartOHLCKeyClose;


@interface SChartOHLCSeries : SChartBarColumnSeries

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartOHLCSeriesStyle` contains all of the objects relevant to styling an OHLC series. */
-(SChartOHLCSeriesStyle *)style;

-(void)setStyle:(SChartOHLCSeriesStyle *)style;

/** Style settings in this object will be applied when the series is marked as selected (or a datapoint is selected).*/
-(SChartOHLCSeriesStyle *)selectedStyle;

-(void)setSelectedStyle:(SChartOHLCSeriesStyle *)selectedStyle;

@end
