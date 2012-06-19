//
//  SChart.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class SChartCanvas;
@class SChartAxis;
@class SChartTitle;
@class SChartLegend;
@class SChartCrosshair;
@class SChartLogger;
@class SChartTheme;
@class SChartSeries;
@class SChartAnnotation;
@class SChartGradientView;
@protocol SChartDatasource;
@protocol SChartDelegate;

/**
A ShinobiChart displays data arranged in either cartesian _or_ radial series. 
 
A ShinobiChart will display its cartesian series (line, column, bar, scatter) if a cartesian series is added to it first, or all its radial series (donuts, pies) if a radial series is added to it first. If a radial series is added to a 'cartesian chart' or vice versa, a warning will be issued and that series discarded.
 
Data is always represented in a series or a set of series. The SChartSeries determines the look and style of the data contained in a SChartDataSeries. There is a one-to-one relationship between a chart series and the data series it represents. 
 
A chart must have a minimum of one x-axis and one y-axis to display cartesian series, however, these will be automatically generated if none are specified. 
 
A ShinobiChart must have an object that acts as the data source to display any data and optionally can have an object that acts as the delegate. The data source must adopt the SChartDatasource protocol and the delegate must adopt the SChartDelegate protocol. The data source provides the information needed by the chart to construct the series and represent the data.  Series are identified by an index integer by the data source. 
 
The ShinobiChart is a subclass of UIView,  and as such it can be added to other parent views or set as the root view of a view controller. 
 
A ShinobiChart will only update to reflect any changes to data when the reloadData method is called. 
 
 */

typedef enum {
    SChartTitleCentreOnChart,
    SChartTitleCentreOnPlottingArea,
    SChartTitleCentreOnCanvas 
} SChartTitleCentreOn;

typedef enum {
    SChartAxisTypeNumber,
    SChartAxisTypeDateTime,
    SChartAxisTypeCategory,
    SChartAxisTypeLogarithmic
} SChartAxisType;


typedef struct SChartPoint
{
    double x, y;
} SChartPoint;

typedef struct SChartSize
{
    double width, height;
} SChartSize;

typedef enum {
    SChartGesturePanTypePanPinch,
    SChartGesturePanTypeBoxDraw
} SChartGesturePanType;


@interface ShinobiChart : UIView {
	NSMutableArray *xAxes, *yAxes;
    
    NSMutableArray *annotations;
    
    SChartGradientView *gradientView;
}

/** @name Series */
/** Every series associated with this chart through the data source. */
- (NSMutableArray*)allChartSeries;

#pragma mark -
#pragma mark Layout and Styling
/** @name Layout and Styling */
/** The frame that contains the whole chart object */
- (CGRect)chartFrame;
/** The area rendered by the openGL functions */
- (CGRect)getGLFrame;
/** Background color of the chart view */
- (UIColor*)chartBackgroundColor;
/** Background colour of the plot area - ie: the area inside the axis. */
- (UIColor*)plotBackgroundColor;
/** The position of the legend object if it's being displayed */
- (void)positionLegend;
/** Redraw the chart elements */
- (void)redrawChart;
/** Redraw the chart if it has basic componenents */
- (void)setNeedsLayoutIfHaveAxesAndData;


#pragma mark -
#pragma mark Axes
/** @name Axes */
/** The primary X axis object for this chart */ 
- (SChartAxis*)xAxis;
/** The primary Y axis object for this chart */
- (SChartAxis*)yAxis;

#pragma mark -
#pragma mark Notifications through the delegate
/** @name Notifications through the delegate */
/** The object assigned as the chart delegate */
- (id<SChartDelegate>)delegate;
/** Returns a string that represents the x and y values for the crosshair. */
- (NSString *)stringForX:(double)x andY:(double)y;
/** A reference to the chart object */
- (ShinobiChart*)getChart;
/** A reference to the canvas object of the chart */
- (SChartCanvas*)getCanvas;
/** Notify the chart that one of the axis has panned */
- (void)axisPanningChanged;


///** Notify the chart that the crosshair has appeared at x and y */
//-(void)crosshairAtInterpolatedX:(double)x andY:(double)y;


@property (nonatomic, readonly) SChartLogger *logger;

#pragma mark -
#pragma mark Delegates, Data Sources and License Key
/** @name Managing the delegate and data source */

/**
 The object that acts as the chart's delegate.
 
 The object must implement the SChartDelegate protocol */
@property (nonatomic, retain) id <SChartDelegate> delegate;

/** 
 The object that acts as the data source of the receiving chart.
 
 The object must implement the SChartDatasource protocol */
@property (nonatomic, retain) id <SChartDatasource> datasource;


/** 
 The License Key for this Chart
 
 A valid license key must be set before the chart will render */
@property (nonatomic, assign) NSString *licenseKey;


#pragma mark -
#pragma mark Axes
/** @name Information about the chart axes */
/** 
 The primary x-axis for this chart. 
 
 This will be automaticaly generated if not specified
 */
@property (nonatomic, retain) SChartAxis *xAxis;

/** 
 The primary y-axis for this chart. 
 
 This will be automaticaly generated if not specified 
 */
@property (nonatomic, retain) SChartAxis *yAxis;


/** @name Configuring the axes */
/** Adds an X-Axis for the chart */
- (void)addXAxis:(SChartAxis *)newXAxis;

/** Adds a Y-Axis for the chart */
- (void)addYAxis:(SChartAxis *)newYAxis;

/** Removes an X-Axis from the chart */
- (void)removeXAxis:(SChartAxis *)newXAxis;

/** Removes a Y-Axis from the chart */
- (void)removeYAxis:(SChartAxis *)newYAxis;

/** Replaces a X-Axis on the chart */
- (void)replaceXAxis:(SChartAxis *)oldXAxis withAxis:(SChartAxis *)newXAxis;

/** Replaces a Y-Axis on the chart */
- (void)replaceYAxis:(SChartAxis *)oldYAxis withAxis:(SChartAxis *)newYAxis;

/** Returns all axes associated with this chart */
- (NSArray *)allAxes;
/** Returns all Primary axes associated with this chart */
- (NSArray *)primaryAxes;
/** Returns all Secondary axes associated with this chart */
- (NSArray *)secondaryAxes;
/** Returns all X axes associated with this chart */
- (NSArray *)allXAxes;
/** Returns all Y axes associated with this chart */
- (NSArray *)allYAxes;
/** Returns all Secondary X axes associated with this chart */
- (NSArray *)secondaryXAxes;
/** Returns all Secondary Y axes associated with this chart */
- (NSArray *)secondaryYAxes;

/** Returns this chart's primary X Axis */
- (SChartAxis *)primaryXAxis;
/** Returns this chart's primary Y Axis */
- (SChartAxis *)primaryYAxis;

- (void)axesForSeries:(SChartSeries *)series storeX:(SChartAxis **)xStore andStoreY:(SChartAxis **)yStore;

#pragma mark -
#pragma mark Series

/** @name Information about the series displayed on the chart */
/** 
 A _readonly_ array of SChartSeries objects for this chart.
 
 Series should be specified by the data source that implements the SChartDatasource protocol*/
@property (nonatomic, retain, readonly) NSMutableArray *chartSeries;


#pragma mark -
#pragma mark Titles
/** @name Setting the title */
/** Sets the text value of a title label and displays in the standard position.
 
 See also titleLabel for the property representing the actual UILabel object.*/
@property (nonatomic, retain) NSString *title;

/** A UILabel representing the title for the chart.
 
 This object is created and automatically handled through the title property. However, modifying this object will give greater control over the title attributes.*/
@property (nonatomic, retain) SChartTitle *titleLabel;

/** A BOOLean to indicate if the chart title label shouldreserve space at the top of the chart or overlap the canvas.
 
 Setting this attribute to `YES` will allow the UILabel to appear over the chart plot area. Setting it to `NO` will push the canvas area down and reserve space obove the chart plots for the title.  calculateTargetBounds controls the space reserved for chart objects outside of the canvas area.*/
@property (nonatomic, assign) BOOL overlapChartTitle;

@property (nonatomic, assign) SChartTitleCentreOn titleCentresOn;

@property (nonatomic)         CGFloat defaultTitleWidth;
@property (nonatomic)         CGFloat titleWidthModifier;


#pragma mark -
#pragma mark Legend
/** @name Configuring a legend*/
/** The object that represents the chart's legend.*/
@property (nonatomic, retain) SChartLegend *legend;


#pragma mark -
#pragma mark Styling the chart
/** @name Styling the chart */

/** The general styling configuration for the whole chart.
 
 A ShinobiChart will take all of it's UI configuration - colors, line thicknesses, etc - from the SChartPalette object palette. The chart is initially created with a theme that sets the palette values - see initWithFrame:usingTheme:. After this, changes made to individual objects will have precendence - for example setting the series color in the data source. To reset the palette to a theme - use applyTheme: - this will clear all values from the palette and set them to the theme defaults. */
@property (nonatomic, retain) SChartTheme *theme;

/** The background color of the _canvas area_ where the axis and plots are drawn.
 
 This area does not include any titles and legends etc. To set the background color of the whole chart area use `setBackgroundColor`. Default value is `clearColor`.*/
@property (nonatomic, assign) UIColor *canvasAreaBackgroundColor;

/** The background color of the _plot area_ where the series are drawn.
 
 To set the background color of the whole chart area use `backgroundColor` - also see `chartAreaBackgroundColor`. Default value is `clearColor`.*/
@property (nonatomic, retain) UIColor *plotAreaBackgroundColor;

/** The color of the border around the _plot area_ where the series are drawn.
 
 To set the border color of the whole chart area use `borderColor`. Default value is `clearColor`.*/
@property (nonatomic, retain) UIColor *plotAreaBorderColor;

/** The thickness of the border around the _plot area_ where the series are drawn.
 
 To set the border thickness of the whole chart area use `borderThickness`. Default value is `1.0f`.*/
@property (nonatomic, assign) float plotAreaBorderThickness;

/** The color of the border around the chart view.
 
 Default value is `clearColor`.*/
@property (nonatomic, retain) UIColor *borderColor;

/** The thickness of the border chart view.
 
 Default value is `1.0f`.*/
@property (nonatomic, retain) NSNumber *borderThickness;


#pragma mark -
#pragma mark Displaying a crosshair
/** The object displayed after a _tap-and-hold_ gesture on the chart
 
 The crosshair will draw a target cirle with axis markers and also display a tooltip. To customize, subclass SChartCrosshair and set it to this parameter or subclass just the tooltip. */
@property (nonatomic, retain) SChartCrosshair *crosshair;


#pragma mark -
#pragma mark Chart Gesture Options
/** @name Interacting with the chart */
/**  Set the method for zooming the chart
 
 The chart may be configured to use either pinch zoom gestures or the touch gestures can generate a box on the chart. 
 For box style zooming, the chart will animate the zoom level to display the area marked by the box. 
 
 <code>typedef enum {<br>
 SChartGesturePanTypePanPinch,<br>
 SChartGesturePanTypeBoxDraw<br>
 } SChartGesturePanType;</code>
 
 Default `SChartGesturePanTypePanPinch` */
@property (nonatomic) SChartGesturePanType gesturePanType;

/** When set to `YES` all of the axis will zoom the same amount
 
 The chart will maintain its aspect ratio regardless of the type or orientation of gesture */
@property (nonatomic) BOOL gesturePinchAspectLock;

/** When set to `YES` the crosshair will be dismissed if a pan gesture occurs */
@property (nonatomic) BOOL gesturePanCancelsCrosshair;

/** When set to `YES` the _double-tap_ gesture will reset the zoom level to _default_
 
 Otherwise, if set to `NO` the chart will zoom in  a set amount. Default `NO`. */
@property (nonatomic) BOOL gestureDoubleTapResetsZoom;

/** When set to `YES` the zoom resulting from a box gesture will animate to the new zoom level */
@property (nonatomic) BOOL animateBoxGesture;

/** When set to `YES` the zoom resulting from a pinch gesture will animate to the new zoom level */
@property (nonatomic) BOOL animateZoomGesture;


@property (nonatomic, readonly) SChartCanvas *canvas;

#pragma mark -
#pragma mark Initialisation
/** @name Initialising a ShinobiChart object */

/** Initialise a chart object with a specified frame.
    Uses SChartThemeDefault to set the theme values.*/
- (id)initWithFrame:(CGRect)frame;
 
/** Initialise the chart object with the specified frame and set the palette values to use this theme */
- (id)initWithFrame:(CGRect)frame withTheme:(SChartTheme *)theme;

/** Initialise the chart object with the specified frame and axes 
    Uses SChartThemeDefault to set the theme values.*/
- (id)initWithFrame:(CGRect)frame withPrimaryXAxisType:(SChartAxisType)xAxisType withPrimaryYAxisType:(SChartAxisType)yAxisType;

/** Initialise the chart object with the specified frame, theme and axes */
- (id)initWithFrame:(CGRect)frame withTheme:(SChartTheme *)theme withPrimaryXAxisType:(SChartAxisType)xAxisType withPrimaryYAxisType:(SChartAxisType)yAxisType;


#pragma mark -
#pragma mark Data and Reloading
/** @name Reloading the Chart */

/** Reloads the data points for the chart.
    The data is reloaded during the next draw cycle. Changes to data points in the data source will not be reflected on the chart until this method is called*/
- (void)reloadData;

/** Update the canvas to allow for axes, titles, and legend. */
- (void)updateCanvasSize;

/** Causes the graphics layer to redraw itself.
    This does not affect the data - data must be reload using `reloadData`. */
- (void)redrawChartAndGL:(BOOL)redrawGL;

/*  Convenience method - calls redrawChartAndGL:NO */
- (void)redrawChart;

#pragma mark -
#pragma mark Interaction
-(NSString *)stringForX:(double)fx andY:(double)fy usingXAxis:(SChartAxis *)xAxis andYAxis:(SChartAxis *)yAxis;
-(NSString *)stringForX:(double)fx andY:(double)fy usingSeries:(SChartSeries *)series;
-(NSString *)stringForX:(double)fx andY:(double)fy;
/** Convert a pair of values into a string, using the primary axes */
-(NSString *)stringForIdX:(id)fx andIdY:(id)fy usingSeries:(SChartSeries *)series;

- (void)axisPanningChanged;

-(BOOL)pointIsVisible:(SChartPoint)point onSeries:(SChartSeries *)series;


#pragma mark -
#pragma mark Handle
- (CGRect)chartFrame;


#pragma mark -
#pragma mark Legend
- (void)positionLegend;

#pragma mark -
#pragma mark Annotations
/** Add an annotation view to be displayed on the plot area */
- (void)addAnnotation:(SChartAnnotation *)newAnnotation;

/** Replace an annotation with the given index with a new one */
- (void)replaceAnnotationAtIndex:(NSUInteger)index withAnnotation:(SChartAnnotation *)newAnnotation;

/** Get a list of currently active annotations */
-(NSArray *)getAnnotations;

/** Remove an annotation view */
-(void)removeAnnotation:(SChartAnnotation *)annotation;

/** Remove all annotation views */
-(void)removeAllAnnotations;

#pragma mark -
#pragma mark Info
+(NSString *)getInfo;
-(NSString *)getInfo;

@end
