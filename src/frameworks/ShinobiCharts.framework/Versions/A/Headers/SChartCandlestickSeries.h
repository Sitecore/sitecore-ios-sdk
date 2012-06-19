//
//  SChartCandlestickSeries.h
//  SChart
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartOHLCSeries.h"
#import "SChartCandlestickSeriesStyle.h"

/** SChartCandlestickSeries is a type of SChartSeries which displays Open-High-Low-Close data on a chart.
 
 An SChartCandlestickSeries' datapoints should implement the <code>-(id)sChartXValueForKey:</code> or <code>-(id)sChartYValueForKey:</code> methods of the SChartData protocol, depending on series orientation, in order to provide the Open, High, Low, and Close values to the chart.
 
 The key values are:
    SChartCandlestickKeyOpen
    SChartCandlestickKeyHigh
    SChartCandlestickKeyLow
    SChartCandlestickKeyClose
 
 The Candlestick series is visualised as a thick candle between the open and close values, with 'wicks' indicating the high and low positions.
 
 *Related Classes:*
 
 SChartCandlestickSeriesStyle <br>
 SChartOHLCSeries <br>
 SChartMultiYDataPoint <br>
 SChartMultiXDataPoint <br>
 
 */

extern NSString *const SChartCandlestickKeyOpen;
extern NSString *const SChartCandlestickKeyHigh;
extern NSString *const SChartCandlestickKeyLow;
extern NSString *const SChartCandlestickKeyClose;

@interface SChartCandlestickSeries : SChartOHLCSeries

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartCandlestickSeriesStyle` contains all of the objects relevant to styling a candlestick series. */
-(SChartCandlestickSeriesStyle *)style;

-(void)setStyle:(SChartCandlestickSeriesStyle *)style;

/** Style settings in this object will be applied when the series is marked as selected (or a datapoint is selected).*/
-(SChartCandlestickSeriesStyle *)selectedStyle;

-(void)setSelectedStyle:(SChartCandlestickSeriesStyle *)selectedStyle;

@end
