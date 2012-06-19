//
//  SChartLegend.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    SChartSeriesLegendAlignSymbolsLeft,
    SChartSeriesLegendAlignSymbolsRight
} SChartSeriesLegendSymbolAlignment;

typedef enum {
    SChartLegendOrientationVertical,
    SChartLegendOrientationHorizontal
} SChartLegendOrientation;

typedef enum {
    SChartLegendPlacementOutsidePlotArea,
    SChartLegendPlacementInsidePlotArea
} SChartLegendPlacement;

typedef enum {
    SChartLegendPositionTopRight,
    SChartLegendPositionMiddleRight,
    SChartLegendPositionBottomRight,
    SChartLegendPositionBottomMiddle,
    SChartLegendPositionBottomLeft,
    SChartLegendPositionMiddleLeft,
    SChartLegendPositionTopLeft,
    SChartLegendPositionTopMiddle
} SChartLegendPosition;

@class ShinobiChart;
@class SChartLegendStyle;
@class SChartTitle;

/** Series data can be displayed in a legend on a ShinobiChart. A The SChartLegend is a UIView based object that represents the legend as a visual item on the chart. The legend may appear in a number of preset positions within the chart. 
 
 The positioning of the legend inside or outside the plot area has different effects:
 
 <code>typedef enum {<br>
 SChartLegendPlacementOutsidePlotArea,     // the plot area will shrink to accommodate the legend without obscuring the chart plot<br>
 SChartLegendPlacementInsidePlotArea       // the plot area will expand as though the legend is not there - with the legend displaying over the plot area.<br>
 } SChartLegendPlacement;</code>
 
 Irrespective of how the plot area behaves, we can anchor the legend to several preset positions in the chart area:

 <code>typedef enum {<br>
 SChartLegendPositionTopRight,<br>
 SChartLegendPositionMiddleRight,<br>
 SChartLegendPositionBottomRight,<br>
 SChartLegendPositionBottomMiddle,<br>
 SChartLegendPositionBottomLeft,<br>
 SChartLegendPositionMiddleLeft,<br>
 SChartLegendPositionTopLeft,<br>
 SChartLegendPositionTopMiddle<br>
 } SChartLegendPosition;</code>
 
 To create a custom legend object, create a subclass and override `drawLegend` where each series should respond to methods in the SChartLegendItem protocol. Assign the new legend object to `chart.legend`

 
 */


@interface SChartLegend : UIView {
    
    NSNumber *symbolWidth;
    
    int maxSeriesPerLine;
    
    NSMutableArray *symbols;
    NSMutableArray *labels;
    

    
    SChartLegendStyle *style;
    SChartTitle *title;

@private
    BOOL userSetSymbolWidth;
    BOOL userSetFrame;
    BOOL doShowTitle;
    SChartLegendPosition position;
}
#pragma mark -
#pragma mark Initialisation
/** @name Initialisation */
/** Initialise the legend with a reference to the chart. */
- (id)initWithChart:(ShinobiChart *)_chart;

#pragma mark -
#pragma mark Drawing
/** @name Drawing the legend */
/** The main function called by the chart to construct the legend.
 
 Override this function to create a custom legend class. */
- (void)drawLegend;

#pragma mark -
#pragma mark Data
/** @name Data from the chart */

/* A reference to the chart that the legend belongs to */
@property (nonatomic, assign) ShinobiChart *chart;

/** The main function called by the chart when it requires a legend to be drawn.
 
 Override this function when creating a custom legend object. */

#pragma mark -
#pragma mark Formatting
/** @name Formatting the legend */
/**Sets a title for the legend. */
@property (nonatomic, retain) NSString *title;

/** Specifies the positioning of the legend.
 
 *Dictated by*:<br>
 <code>typedef enum {<br>
 SChartLegendPositionTopRight,<br>
 SChartLegendPositionMiddleRight,<br>
 SChartLegendPositionBottomRight,<br>
 SChartLegendPositionBottomMiddle,<br>
 SChartLegendPositionBottomLeft,<br>
 SChartLegendPositionMiddleLeft,<br>
 SChartLegendPositionTopLeft,<br>
 SChartLegendPositionTopMiddle<br>
 } SChartLegendPosition;</code>
 */
@property (nonatomic, assign) SChartLegendPosition position;
/** The position of the legend relative to the chart plot area
 
 <code>typedef enum {
 SChartLegendPlacementOutsidePlotArea,
 SChartLegendPlacementInsidePlotArea
 } SChartLegendPlacement;</code>
 */
@property (nonatomic, assign) SChartLegendPlacement placement;
/** A float representing the width in pixels that the symbol should have.
 
 If this is not set by the user the symbol will automatically take up half of the width of the legend (with the chart series label/text taking up the other half).*/
@property (nonatomic, retain) NSNumber *symbolWidth;

/** A BOOLean that indicates if symbols should be shown in the legend.
 
 The default value is YES (symbols will be shown). Symbols are collected from the series objects through the SChartLegendItem protocol.*/
@property (nonatomic, assign) BOOL showSymbols;

/** A number specifying how many series are shown per row on horizontal legends */
@property (nonatomic, assign) int maxSeriesPerLine;

#pragma mark -
#pragma mark Styling
/** @name Styling */
/** The object containing all of the style properties for the legend. */
@property (nonatomic, retain) SChartLegendStyle *style;
/** Value determining the radius of the border corners.
 
 Default is 0, setting this to nil also equates to a radius of 0 - which results in square corners. */
@property (nonatomic, retain) NSNumber *cornerRadius;

#pragma mark -
#pragma mark Items
/** @name Legend Items */
/** An array of the symbols loaded for this legend. */
@property (nonatomic, retain) NSMutableArray *symbols;
/** An array of the labels loaded for this legend. */
@property (nonatomic, retain) NSMutableArray *labels;

#pragma mark -
#pragma mark Internal: Drawing
/** Causes the legend to redraw itself. Changes in series styling will not be updated within the legend until this method has been called.*/
- (void)reload;



@end
