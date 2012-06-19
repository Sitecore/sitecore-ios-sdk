//
//  SChartSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartLegendItem.h"
#import "SChartDataSeries.h"
#import "SChartData.h"
#import "SChartInternalDataPoint.h"
#import "SChartGLView.h"
#import "SChartTheme.h"

@class SChartSeriesStyle;
@class SChartDataPoint;
@class ShinobiChart;

typedef enum {
    SChartSelectionNone,
    SChartSelectionSeries,
    SChartSelectionPoint
} SChartSelection;

typedef enum {
    SChartSeriesOrientationHorizontal,
    SChartSeriesOrientationVertical
} SChartSeriesOrientation;

/** 
 The SChartSeries object represents data series which are displayed in terms of cartesian coordinates
  
 
*Related Classes:*

SChartLineSeries<br>
SChartScatterSeries<br>
SChartColumnSeries<br>
SChartBarSeries<br>
 
 */

@interface SChartSeries : NSObject <SChartLegendItem> {
    SChartDataSeries *dataSeries;
    
    NSString *title;
    BOOL showInLegend;
    
    SChartSelection selectionMode;
    BOOL toggleSelection, togglePointSelection;
    BOOL selected;
}

#pragma mark -
#pragma mark Data and Axis
/* @name Data and Axis setup */

@property (nonatomic, retain) SChartDataSeries *dataSeries;

 
#pragma mark -
#pragma mark Status

@property (nonatomic, assign) SChartSeriesOrientation orientation;

#pragma mark -
#pragma mark Selection Options

/** @name Selection Options */
/** What should be selected when the user taps the chart.
 
 When a tap gesture indicates a point on this series - how should the series respond. There is an important effect of choosing `SChartSelectionNone` - this option will remove this series from the algorithm that searches for the nearest point to the tap. Hence, a user may tap near to this series - but the algorithm will select a different series based upon nearest point.
 
 <code>typedef enum {<br>
 SChartSelectionNone,   //nothing happens<br> 
 SChartSelectionSeries, //the whole series is selected<br>
 SChartSelectionPoint   //the single point is selected<br>
 } SChartSelection;</code>
 
 Note that currently, selection is handled separately for radial chart series - selectionMode, toggleSelection, and togglePointSelection are only applicable to subclasses of SChartSeries.
 */
@property (nonatomic) SChartSelection selectionMode;

/** Toggle selection on or off */
@property (nonatomic) BOOL toggleSelection; 

/** Should the series only allow one selected point at a time.
 
 If this is set to 'YES', the series will de-select all other points in this series before selecting the tapped point. Setting `NO` will allow as many points to be selected as are tapped. NOTE: This is _per_ series and will allow multiple points to be selected across series regardless of value. To enable single point selection across all of the series for the chart - use the chart delegate. */
@property (nonatomic) BOOL togglePointSelection;

/** Whether or not the series is selected */
@property (nonatomic, assign) BOOL selected;


#pragma mark -
#pragma mark Crosshair
/** @name Crosshair */
/** Display a tooltip with connecting lines after the user taps-and-holds
 
 For line series, the tooltip will appear on the nearest series and interpolate values between data points. For column/bar series the crosshair will snap to the nearest column. Once a crosshair is visible - it is locked to that current series. It will ignore other series until it is dismissed and re-established on a different series. To dismiss the crosshair the user must perform a single tap on the chart. */
@property (nonatomic) BOOL crosshairEnabled;


#pragma mark -
#pragma mark Drawing

/** Whether or not the series should be drawn on the chart */
- (BOOL)shouldBeDrawn;

- (NSArray*)xValueKeys;
- (NSArray*)yValueKeys;

-(NSString *)stringForSeriesWithDataPoint:(SChartDataPoint *)dataPoint onChart:(ShinobiChart *)chart;

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartLineSeriesStyle` contains all of the objects relevant to styling a bar or column series. */
@property (nonatomic, retain) SChartSeriesStyle *_style;

/** Style settings in this object will be applied when the series is marked as selected (or a point is selected).*/
@property (nonatomic, retain) SChartSeriesStyle *_selectedStyle;

- (void)applyStylesFromTheme:(SChartTheme *)theme
                atStyleIndex:(unsigned)seriesIndex
         preservingSetValues:(BOOL)preserveValues;

- (SEL)themeStyleSelector; // subclasses implement this


#pragma mark -
#pragma mark Legend Display Options

/** @name Legend Display Options */
/** The title of the series to be displayed in the legend. */
@property (nonatomic, retain) NSString *title;

/** Whether or not the series should be represented in the legend */
@property (nonatomic, assign) BOOL showInLegend;


@end
