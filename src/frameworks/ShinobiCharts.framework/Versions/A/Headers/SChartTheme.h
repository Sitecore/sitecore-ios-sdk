//
//  SChartTheme.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SChartStyle;
@class SChartTitleStyle;
@class SChartLegendStyle;
@class SChartAxisStyle;
@class SChartAxisStyle;
@class SChartCrosshairStyle;
@class SChartBoxGestureStyle;
@class SChartLineSeriesStyle;
@class SChartBandSeriesStyle;
@class SChartColumnSeriesStyle;
@class SChartBarSeriesStyle;
@class SChartDonutSeriesStyle;
@class SChartScatterSeriesStyle;
@class SChartOHLCSeriesStyle;
@class SChartCandlestickSeriesStyle;

/** Each ShinobiChart has a SChartTheme object that can control the style for all objects on the chart in one central location. Individual properties can still be set directly on the chart objects, indeed they will take precedence over theme values, but the theme is a convenient way to control the overall look and feel of the chart. 
 
 SCharts come with two built-in themes - Default (SChartTheme) and Midnight (SChartMidnightTheme). Each theme contains a number of style objects that affect the look of certain aspects of the chart ie: chart, axes, etc. There are also a number of style objects for each series type. If there are more series of that type than styles - they will wrap around and use the first style again. 
 
 *Default Theme*: Brighter colors based on a white background<br>
 *Midnight Theme*: Softer colors on a black background
 
 To create custom themes, choose one of the three built-in themes that most matches your desired theme and customise. To switch the theme on a chart - simply set `chart.theme` to a new theme object.
 */
@interface SChartTheme : NSObject {
    
    // Style Objects
    SChartStyle      *chartStyle;    
    SChartTitleStyle *chartTitleStyle;
    SChartLegendStyle     *legendStyle;    
    SChartAxisStyle       *xAxisStyle;
    SChartAxisStyle       *yAxisStyle;
    SChartCrosshairStyle  *crosshairStyle;
    SChartBoxGestureStyle *boxGestureStyle;
    
    // Theme Colors
    UIColor *blackColor,
            *blackColorLowAlpha,
            *redColorDark,
            *redColorLight,
            *redColorBrightLight,
            *greenColorDark,
            *greenColorLight,
            *greenColorBrightLight,
            *blueColorDark,
            *blueColorLight,
            *orangeColorDark,
            *orangeColorLight,
            *purpleColorDark,
            *purpleColorLight,
            *yellowColorDark,
            *yellowColorLight;
    
    NSNumber *lineWidth;
    NSNumber *columnLineWidth;
    NSNumber *barLineWidth;
    NSNumber *crustThickness;
     
    NSMutableArray *lineSeriesStyles,           *lineSeriesSelectedStyles;
    NSMutableArray *bandSeriesStyles,           *bandSeriesSelectedStyles;
    NSMutableArray *columnSeriesStyles,         *columnSeriesSelectedStyles;
    NSMutableArray *barSeriesStyles,            *barSeriesSelectedStyles;
    NSMutableArray *scatterSeriesStyles,        *scatterSeriesSelectedStyles;
    NSMutableArray *donutSeriesStyles,          *donutSeriesSelectedStyles;
    NSMutableArray *ohlcSeriesStyles,           *ohlcSeriesSelectedStyles;
    NSMutableArray *candlestickSeriesStyles,    *candlestickSeriesSelectedStyles;
}


/** @name Initialising a theme */
/** Simple init function creates the style object with settings */
- (id)init;

- (void)setStyles;

/** @name Individual style objects */
/** Style options relating to the chart such as background colors */
@property (nonatomic, retain) SChartStyle       *chartStyle;

/** Style options relating to the chart title such as font etc */
@property (nonatomic, retain) SChartTitleStyle  *chartTitleStyle;

/** Style options relating to the legend such as background, border etc */
@property (nonatomic, retain) SChartLegendStyle      *legendStyle;

/** Style options relating to the X axis such as lines, labels etc */
@property (nonatomic, retain) SChartAxisStyle        *xAxisStyle;

/** Style options relating to the Y axis such as lines, labels etc */
@property (nonatomic, retain) SChartAxisStyle        *yAxisStyle;

/** Style options relating to the cross hair such as lines, labels etc */
@property (nonatomic, retain) SChartCrosshairStyle   *crosshairStyle;

/** Style options relating to the box gesture, such as line color */
@property (nonatomic, retain) SChartBoxGestureStyle *boxGestureStyle;


/** @name Colors for this theme */
/** Black palette color */
@property (nonatomic, retain) UIColor *blackColor;
/** Black palette color with reduced alpha */
@property (nonatomic, retain) UIColor *blackColorLowAlpha;
/** Red palette color */
@property (nonatomic, retain) UIColor *redColorDark;
/** Red palette color with increased brightness */
@property (nonatomic, retain) UIColor *redColorLight;
/** Red palette color with increased brightness */
@property (nonatomic, retain) UIColor *redColorBrightLight;
/** Green palette color */
@property (nonatomic, retain) UIColor *greenColorDark;
/** Green palette color with increased brightness */
@property (nonatomic, retain) UIColor *greenColorLight;
/** Green palette color with increased brightness */
@property (nonatomic, retain) UIColor *greenColorBrightLight;
/** Blue palette color */
@property (nonatomic, retain) UIColor *blueColorDark;
/** Blue palette color with increased brightness */
@property (nonatomic, retain) UIColor *blueColorLight;
/** Orange palette color */
@property (nonatomic, retain) UIColor *orangeColorDark;
/** Orange palette color with increased brightness */
@property (nonatomic, retain) UIColor *orangeColorLight;
/** Purple palette color */
@property (nonatomic, retain) UIColor *purpleColorDark;
/** Purple palette color with increased brightness */
@property (nonatomic, retain) UIColor *purpleColorLight;
/** Yellow palette color */
@property (nonatomic, retain) UIColor *yellowColorDark;
/** Yellow palette color with increased brightness */
@property (nonatomic, retain) UIColor *yellowColorLight;



/** @name Managing series styles */
/** Default line width for all line series 
 
 Use this setting to apply a consistent line width across all lines series - after setting call setStyle to apply it. */
@property (nonatomic, retain) NSNumber *lineWidth;
/** Default line width for all column series 
 
 Use this setting to apply a consistent line width across all column series - after setting call setStyle to apply it. */
@property (nonatomic, retain) NSNumber *columnLineWidth;
/** Default line width for all bar series 
 
 Use this setting to apply a consistent line width across all bar series - after setting call setStyle to apply it. */
@property (nonatomic, retain) NSNumber *barLineWidth;

/** Default outline or 'crust' thickness for all radial series
 
 Use this setting to apply a consistent crust thickness across all radial series - after setting call setStyle to apply it. */
@property (nonatomic, retain) NSNumber *crustThickness;
  
/** @name Initialising the theme */

/** Stores the series style in the array of line series styles
 
 Use the selected option to indicate if this style should be used when the series is selected.*/
- (void)addLineSeriesStyle:(SChartLineSeriesStyle *)newStyle asSelected:(BOOL)selected;

/** Stores the series style in the array of band series styles
 
 Use the selected option to indicate if this style should be used when the series is selected.*/
- (void)addBandSeriesStyle:(SChartBandSeriesStyle *)newStyle asSelected:(BOOL)selected;

/** Stores the series style in the array of column series styles
 
 Use the selected option to indicate if this style should be used when the series is selected.*/
- (void)addColumnSeriesStyle:(SChartColumnSeriesStyle *)newStyle asSelected:(BOOL)selected;

/** Stores the series style in the array of bar series styles
 
 Use the selected option to indicate if this style should be used when the series is selected.*/
- (void)addBarSeriesStyle:(SChartBarSeriesStyle *)newStyle asSelected:(BOOL)selected;
/** Encodes the donut series style object and stores in the array of donut series styles. */
- (void)addDonutSeriesStyle:(SChartDonutSeriesStyle *)newStyle asSelected:(BOOL)selected;

/** Stores the series style in the array of scatter series styles
 
 Use the selected option to indicate if this style should be used when the series is selected.*/
- (void)addScatterSeriesStyle:(SChartScatterSeriesStyle *)newStyle asSelected:(BOOL)selected;

/** Stores the series style in the array of ohlc series styles
 
 Use the selected option to indicate if this style should be used when the series is selected.*/
- (void)addOHLCSeriesStyle:(SChartOHLCSeriesStyle *)newStyle asSelected:(BOOL)selected;

/** Stores the series style in the array of candlestick series styles
 
 Use the selected option to indicate if this style should be used when the series is selected.*/
- (void)addCandlestickSeriesStyle:(SChartCandlestickSeriesStyle *)newStyle asSelected:(BOOL)selected;

/** Returns the line series style - using `seriesIndex % lineSeriesStyles.count` to determine which. 
 
 Use `selected` to return styles intended for a selected series.*/
- (SChartLineSeriesStyle *)lineSeriesStyleForSeriesAtIndex:(int)seriesIndex selected:(BOOL)selected;

/** Returns the band series style - using `seriesIndex % bandSeriesStyles.count` to determine which. 
 
 Use `selected` to return styles intended for a selected series.*/
- (SChartBandSeriesStyle *)bandSeriesStyleForSeriesAtIndex:(int)seriesIndex selected:(BOOL)selected;

/** Returns the column series style - using `seriesIndex % columnSeriesStyles.count` to determine which. 
 
 Use `selected` to return styles intended for a selected series.*/
- (SChartColumnSeriesStyle *)columnSeriesStyleForSeriesAtIndex:(int)seriesIndex selected:(BOOL)selected;

/** Returns the bar series style - using `seriesIndex % barSeriesStyles.count` to determine which. 
 
 Use `selected` to return styles intended for a selected series.*/
- (SChartBarSeriesStyle *)barSeriesStyleForSeriesAtIndex:(int)seriesIndex selected:(BOOL)selected;

/** Decodes and returns the donut series style - using `seriesIndex % donutSeriesStyles.count` to determine which. */
- (SChartDonutSeriesStyle *)donutSeriesStyleForSeriesAtIndex:(int)seriesIndex selected:(BOOL)selected;

/** Returns the scatter series style - using `seriesIndex % scatterSeriesStyles.count` to determine which. 
 
 Use `selected` to return styles intended for a selected series.*/
- (SChartScatterSeriesStyle *)scatterSeriesStyleForSeriesAtIndex:(int)seriesIndex selected:(BOOL)selected;

/** Returns the ohlc series style - using `seriesIndex % ohlcSeriesStyles.count` to determine which. 
 
 Use `selected` to return styles intended for a selected series.*/
- (SChartOHLCSeriesStyle *)ohlcSeriesStyleForSeriesAtIndex:(int)seriesIndex selected:(BOOL)selected;

/** Returns the candlestick series style - using `seriesIndex % candlestickSeriesStyles.count` to determine which. 
 
 Use `selected` to return styles intended for a selected series.*/
- (SChartCandlestickSeriesStyle *)candlestickSeriesStyleForSeriesAtIndex:(int)seriesIndex selected:(BOOL)selected;

@end
