//
//  SChartAxis.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SChartGLView;
@class SChartInternalDataPoint;
@class SChartRange;
@class SChartCanvasUnderlay;
@class ShinobiChart;
@class SChartTickMark;
@class SChartSeries;
@class SChartAxisStyle;
@class SChartTitle;
@class SChartCartesianSeries;
@class SChartBarColumnSeries;

typedef enum {
    SChartOrientationHorizontal,
    SChartOrientationVertical
} SChartOrientation;

typedef enum {
    SChartAxisPositionNormal,
    SChartAxisPositionReverse,
} SChartAxisPosition;

typedef enum {
    SChartAxisZoomLevelOriginal,
    SChartAxisZoomLevelDouble,
    SChartAxisZoomLevelHalf
} SChartAxisZoomLevel;

typedef  enum {
    TickLabelOrientationHorizontal,
    TickLabelOrientationDiagonal,
    TickLabelOrientationVertical
} TickLabelOrientation;

typedef enum {
    SChartAxisPanToStart,
    SChartAxisPanToEnd,
    SChartAxisPanToCenter
} SChartAxisPanTo;

/** 
 The SChartAxis is responsible for managing the coordinate space of the chart. It is the link between the set of real data in a series and the laying down of that series on a chart in a desired manner. Each series on the chart is linked to an axis and this SChartAxis is responsible for managing all of the series linked to it.
 
 The axis range can be set to a desired range or left to calculate its own minimum and maximum. When auto-calculating the range, it will consider all data series associated with it.
 
 The axis is also the home of the tick marks and their labels. These can be auto-calculated or set to specific values.
 
 *Related Classes:*
 
 SChartCategoryAxis <br>
 SChartDateTimeAxis <br>
 SChartNumberAxis <br>
 
 */
@interface SChartAxis : NSObject {
    SChartAxisStyle *style;
    
    // Chart & Data
    NSNumber *width;
    NSMutableArray *seriesOnAxis;
    
    // Range
    SChartRange *maxRange;
    SChartRange *glRange;
    float glMin, glMax;
    BOOL glMinSet, glMaxSet;
    
    id rangePaddingLow;
    id rangePaddingHigh;
    float internalRangeLowPadding;
    float internalRangeHighPadding;
    
    BOOL    defaultRangeSet;
    BOOL    dataRangeValid;
    
    BOOL    allowPanningOutOfMaxRange;      // public
    BOOL    allowPanningOutOfDefaultRange;  // public

    // Range animation
    BOOL    animatingRange;
    BOOL    animationEdgeBouncing, animationEnabled;
    struct MinMax
    {
        double min, max;
    } animationStart, animationTarget;
    int animationIterations;
    double lastAnimationFrame;
    double lastMomentumPanFrame;
    double lastMomentumZoomFrame;
    
    double zoom;
    double initialZoom;
    CGRect axisFrame;
    SChartOrientation axisOrientation;
    BOOL  enableGestureZooming;
    BOOL  enableGesturePanning;
    
	// Tick Marks
    id majorTickFrequency;
    id minorTickFrequency;
    id internalMajorTickFrequency;
    id internalMinorTickFrequency;
    
    NSNumber *anchorPoint;
    
    NSString *labelFormatString;
    
    CGSize lastTickLabelSize;
    double lastTickFreq;
    
    UIView *axisLineView;
    
    BOOL needToSortTickMarks;

    
    // Momentum "constants"
    double  panMomentumDelay;
    double  panMomentumFactor;
    double zoomMomentumDelay;
    double zoomMomentumFactor;

    BOOL    isMomentumZooming;
    BOOL    isMomentumPanning;
    BOOL    enableMomentumZooming;
    BOOL    enableMomentumPanning;

    // mid-pinch vars
    double  zoomMomentumCurrent;
    double  zoomMomentumCentre;
    // mid-pan vars
    double  panMomentumCurrent;
    double  panMomentumInitial;
    double  panMomentumLimit;
    
    ShinobiChart *chart;
    NSMutableArray *tickMarks;
    float largestLabelWidth;
    float largestLabelHeight;
    float largestLabelDiagonal;
    BOOL  axisWidthIsSufficient;
    
    BOOL userSetWidth;

}

#pragma mark -
#pragma mark Initialising and managing the axis
/** @name Initializing the axis */
/** Create an axis for a given chart area.*/
- (id)init;

/** Create an axis for a given chart area with a default range.
 
 See `defaultRange` for the implications of setting this type of range. */
- (id)initWithRange:(SChartRange *)range;

#pragma mark -
#pragma mark Chart
/** A pointer to the parent chart
 
 The axis retains a handle on the chart using it so that it can access user-set drawing parameters. */
@property (nonatomic, assign) ShinobiChart *chart;

#pragma mark -
#pragma mark Position
/** @name Position */
/** The SChartAxisPosition defines whether the axis will be positioned at the normal or reverse location.

 typedef enum {<br>
 SChartAxisPositionNormal,<br>
 SChartAxisPositionReverse,<br>
 } SChartAxisPosition 
 
 Normal positions are bottom for x axis and left for y axis. */

@property (nonatomic) SChartAxisPosition axisPosition;

/** @name Value attachement for dynamic axis lines */

/** The (x/y) axis lines will be drawn at the position of this numeric value on the opposite (y/x) axis. */
@property (nonatomic, retain) NSNumber *axisPositionValue;

/** @name Axis Labels fixed in place? */

/** This property determines whether the axis labels will move with the axis lines and tick marks when an axis position value has been set.
    If this is set, labels will stay fixed at the bottom/left or top/right of the chart depending on the axisPosition parameter.*/
@property (nonatomic) BOOL axisLabelsAreFixed;

#pragma mark -
#pragma mark Styling
/** @name Styling */
/** The SChartAxisStyle object that manages the styles for this axis.
 
 Setting these values will override any values set by the theme.*/
@property (nonatomic, retain) SChartAxisStyle *style;

/** Specifies a fixed width for the axis area that won't change.
 
 This is useful to fix the axis in position to align multiple charts. However, it may restrict the options for labelling the chart. */
@property (nonatomic, retain) NSNumber *width;

/** The text of the SChartTitle of the axis */
@property (nonatomic, retain) NSString *title;

/** The SChartTitle of the axis. */
@property (nonatomic, retain) SChartTitle *titleLabel;

#pragma mark -
#pragma mark Range
/** @name Ranges */

/** The current _displayed_  range of the axis.
 
 This property is the actual range currently displayed on the visible area of the chart- which may not be the range that was explicitly set. The axis may make small adjustments to the range to make sure that whole bars are displayed etc. This is a `readonly` property - explicit requests to change the axis range should be made through the method setRangeWithMinimum:andMaximum: */
@property (nonatomic, retain, readonly) SChartRange *axisRange;

/** A readonly property indicating the total data range across all series represented by this axis.
 
 These are absolute minimum and absolute maximum values from the data series represented by this axis.*/
@property (nonatomic, readonly) SChartRange *dataRange;

/** This is the range that will be displayed after the chart initially loads - and if the zoom is reset.
 
 By default it is set to be the dataRange, but can be set to custom values.*/
@property (nonatomic, retain) SChartRange *defaultRange;

/** In data terms, the amount by which the lower limit of the axis range will be lowered past the range of the data.
 
 By default, this is set to 0.*/
@property (nonatomic, retain) id rangePaddingLow;

/** In data terms, the amount by which the upper limit of the axis range will be raised past the range of the data.
 
 By default, this is set to 0.*/
@property (nonatomic, retain) id rangePaddingHigh;

/** Whether or not the user is permitted to pan outside of the user-set default range.
 
 With a user-set default range this can be used to either limit panning and zooming to a subset of the data or to allow panning or zooming outside of the datarange but whilst still setting limits. If the default range is not set, it defaults to `dataRange` and `allowPanningOutOfMaxRange' should be used instead. */
@property (nonatomic) BOOL    allowPanningOutOfDefaultRange;

/** Whether or not the user is permitted to pan outside of the union of the data range and the default range 
 
 If this is enabled but `allowPanningOutOfDataRange` is disabled, panning will still be restricted to the data range*/
@property (nonatomic) BOOL    allowPanningOutOfMaxRange;

/** Should the axis allow the range to go outside the limit specified, temporarily, and bounce back in?
 
 If this is enabled, the range will bounce back into the given limit. If there is no range limit, this option does nothing*/
@property (nonatomic) BOOL    animationEdgeBouncing;

/** Should the axis animate when zooming programmatically, or via double-tap on box gesture. 
 
 If this is enabled, the axis will zoom smoothly from starting to target zoom levels. */
@property (nonatomic) BOOL    animationEnabled;

/** The frame bounding the area where the axis is drawn.
 
 This area includes all of the labels and tickmarks and the axis line. It can have a fixed with if the `width` property is set, otherwise it wil be dynamic and affected by the tickmarks and their labels.  */
@property (nonatomic)         CGRect axisFrame;

/** The orientation of the axis. 
 
 Axis objects are universal and may be used as an x-axis or as a y-axis. This property is determined when the axis is assigned to the chart. */
@property (nonatomic, readonly) SChartOrientation axisOrientation;

/** Attempts to set the current visible range `axisRange` to the specified minimum and maximum.
 
 Given any restrictions on setting the range, such as allowPanningOutOfMaxRange etc, this method will attempt to set the current axis range. Return value is the success of the operation. */
- (BOOL)setRangeWithMinimum:(id)minimum andMaximum:(id)maximum;

- (BOOL)setRangeWithMinimum:(id)minimum andMaximum:(id)maximum withAnimation:(BOOL)animation;
- (BOOL)setRangeWithMinimum:(id)minimum andMaximum:(id)maximum withAnimation:(BOOL)animation usingBounceLimits:(BOOL)rangeChecks; // NOTE: this method is very very private

- (BOOL)beyondAxisLimits;
- (BOOL)beyondAxisMinLimit;
- (BOOL)recheckAxisRange;

/** Creates a new range object with the given maximum and minimum 
 
 The subclass of SChartRange that is returned will correspond to the axis type. */
- (SChartRange *)getNewRangeWithMinimum:(NSNumber *)minimum withMaximum:(NSNumber *)maximum;



#pragma mark -
#pragma mark Tick Marks
/** @name Tickmarks and labels */
/** An appropriate object representing the major tick mark frequency
 
 If this value is set, the chart will not make any auto-calculations for major tick marks and only display a major tick mark at this frequency, regardless of zoom level. The definition of appropriate value is dependent upon the axis type - ie: SChartNumberAxis, SChartDateAxis. The first major tick mark will be at the absolute minimum data value across all series for this axis - with subsequent major tick marks incrementing by the frequency. To change this initial value see `anchorPoint`. By default an appropriate major tick mark value will be selected by the chart and will adapt as the user zooms the chart. */
@property (nonatomic, retain) id majorTickFrequency;

/** An appropriate object representing the minor tick mark frequency
 
 If this value is set, the chart will not make any auto-calculations for minor tick marks and only display a minor tick mark at these values, regardless of zoom level. The first minor tick mark will be at the absolute minimum data value across all series for this axis - with subsequent minor tick marks incrementing by the frequency. To change this initial value see `anchorPoint`. By default an appropriate minor tick mark value will be selected by the chart and will adapt as the user zooms the chart. Minor tick mark values are independent of the major tick mark values.  */
@property (nonatomic, retain) id minorTickFrequency;

/** The start point for the calculation of tick marks.
 
 Regardless of whether a tick mark frequency has been set or automatically calculated, it must start somewhere. This value acts as the origin point for tickmarks on the axis. */
@property (nonatomic, retain) NSNumber *anchorPoint;

/** A string to format each tick mark label - actual format is dependent on axis type.
 
 If an axis is auto-calculating tick marks - it will select an appropriate label format (ie: months, days, hours, etc). However, setting this value will override all tick mark labels to use this formatter. 
 
- For a number axis, use the float formatter, ie: `@"%1.2f mm"`.
- For a date axis, use the date formatter, ie: `@"dd MMM"`.
- For a category axis, use the string formatter, ie: `@"%@ District"`.
 */
@property (nonatomic, retain) NSString *labelFormatString;


#pragma mark -
#pragma mark BarColumn Series
/** @name BarColumn Series */
/** The smallest change in value between any adjacent bars or columns. 
 
 Specifying this can improve the render time of the chart - it will not have to traverse all of the data to compare differences. */
@property (nonatomic) double barColSpacing;

/* The minimum x value of a column across all of the barColumn series for this axis. */
@property (nonatomic, readonly) NSNumber *barColMin;

/* The maximum x value of a column across all of the barColumn series for this axis. */
@property (nonatomic, readonly) NSNumber *barColMax;

/** During the next render process, forces the recalculation of the barcolumn series.
 
 During normal operation the panning and zooming will take place using transforms - with only periodic recalculations. Setting this to YES will force the bars and columns to recalculate all coordinates.*/
@property (nonatomic) BOOL recalculateBarColumnsRequired;

/** A boolean indicating if the bar and column series are already configured.
 
 If this is YES the chart will not traverse the data to work out spacing and ranges. */
@property (nonatomic) BOOL barColumnsConfigured;


#pragma mark -
#pragma mark Zooming
/** @name Zooming */
/** Set to `YES` to allow pinch gestures to zoom the chart. */
@property (nonatomic)         BOOL enableGestureZooming;

/** Sets the zoom of the axis, based around a fixed point 
 
 Zooms the axis around a given position, if position is nil the axis zooms around the centre point. */
- (BOOL) setZoom:(double)z fromPosition:(double *)position withAnimation:(BOOL)animation andBounceLimits:(BOOL)bounceLimits;
- (BOOL) setZoom:(double)z fromPosition:(double *)position withAnimation:(BOOL)animation;
- (BOOL) setZoom:(double)z fromPosition:(double *)position;
- (BOOL) setZoom:(double)s withAnimation:(BOOL)animate;
- (BOOL) setZoom:(double)s;

- (void)zoomToPoint:(double)point withRange:(double)range withAnimation:(BOOL)animate usingBounceLimits:(BOOL)bounce;
- (void)zoomToPoint:(double)point withRange:(double)range;

/** Sets the axis back to its original zoom */
- (BOOL)resetZoomLevel;

- (BOOL)resetZoomLevelWithAnimation:(BOOL)animate;

/** Sets the zoom to a standard level.
 
 @param zoomLevel A predefined SChartAxisZoomLevel for the axis. To set an explicit zoom use setZoom:fromPosition:
 
 typedef enum {<br>
 SChartAxisZoomLevelOriginal,<br>
 SChartAxisZoomLevelDouble,<br>
 SChartAxisZoomLevelHalf<br>
 } SChartAxisZoomLevel */
- (BOOL)setZoomLevel:(SChartAxisZoomLevel)zoomLevel;

/** Returns the current zoom level*/
- (double) zoom;


#pragma mark -
#pragma mark Panning
/** @name Panning */
/** Set to `YES` to allow swipe gestures to pan the chart. */
@property (nonatomic) BOOL enableGesturePanning;

/** Pan the axis range by an explicit amount */
- (BOOL)panByValue:(double)value;

- (BOOL)panByValue:(double)value withAnimation:(BOOL)animation;
- (BOOL)panByValue:(double)value withAnimation:(BOOL)animation withBounceLimits:(BOOL)panWithBouncing; // very private
- (BOOL)panByValue:(double)value withAnimation:(BOOL)animation withBounceLimits:(BOOL)panWithBouncing andRedraw:(BOOL)redraw;

/** Pan to a standard position.
 
 To set an explicit zoom use panByValue: 
 
 typedef enum {<br>
 SChartAxisPanToStart,<br>
 SChartAxisPanToEnd,<br>
 SChartAxisPanToCenter<br>
 } SChartAxisPanTo
*/
- (BOOL)panTo:(SChartAxisPanTo)where;
- (BOOL)panTo:(SChartAxisPanTo)where withAnimation:(BOOL)animation;


#pragma mark -
#pragma mark Momentum Gestures
/** @name Adding momentum to panning and zooming */
/** Enables momentum zooming
 
 When momentum zooming is enabled, fast pinch gestures will cause the chart to continue
 to zoom during a brief 'slowing down' period rather than stopping immediately. */
@property (nonatomic, assign)   BOOL    enableMomentumZooming;

/** Will always be YES when the axis is decelerating from a pinch zoom gesture */
@property (nonatomic, readonly) BOOL    isMomentumZooming;

/** The time steps of each deceleration after a pinch zoom gesture.
 
 If enableMomentumZooming is set to YES, the velocity of the zoom pinch gesture will decay over a number of increments. These increments are a fixed time period specified here. During this fixed period the velocity will decay by a factor `zoomMomentumFactor`*/
@property (nonatomic) double  zoomMomentumDelay;

/** The factor by which the velocity of the gesture will decay during one deceleration time period.
 
 If enableMomentumZooming is set to YES, the velocity of the zoom pinch gesture will decay over a number of increments. These increments are a fixed time period specified in `zoomMomentumDelay`. During this fixed period the velocity will decay by this factor. */
@property (nonatomic) double  zoomMomentumFactor;

/** Enables momentum panning
 
 When momentum panning is enabled, fast pan gestures will cause the chart to continue
 to pan during a brief 'slowing down' period rather than stopping immediately. */
@property (nonatomic, assign)   BOOL    enableMomentumPanning;

/** Will always be YES when the axis is decelerating from a pan swipe gesture */
@property (nonatomic, readonly) BOOL    isMomentumPanning;

/** The time steps of each deceleration after a pan swipe gesture.
 
 If enableMomentumPanning is set to YES, the velocity of the swipe gesture will decay over a number of increments. These increments are a fixed time period specified here. During this fixed period the velocity will decay by a factor `panMomentumFactor`*/
@property (nonatomic) double  panMomentumDelay; 

/** The factor by which the velocity of the gesture will decay during one deceleration time period.
 
 If enableMomentumPanning is set to YES, the velocity of the swipe gesture will decay over a number of increments. These increments are a fixed time period specified in `panMomentumDelay`. During this fixed period the velocity will decay by this factor. */
@property (nonatomic) double  panMomentumFactor;


#pragma mark -
#pragma mark Internal: Panning and Zooming Internal
- (BOOL)panWithMomentumStartingAt:(double)panVelocityWrapper;
- (BOOL)panWithMomentum;
- (void)updateZoom;


#pragma mark -
#pragma mark Internal: Range
- (void)refreshDataRange;
- (void)updateMaxRange;

- (BOOL)zoomWithMomentum;

// Zooms the axis based on momentum, centred on a specified position
-(BOOL)zoomWithMomentum:(double)velocity fromPosition:(double)position;


#pragma mark -
#pragma mark Internal
- (BOOL) isXAxis;
- (void) checkRangeAgainstAxisLimitationWithMin:(double *)min andMax:(double *)max;


#pragma mark -
#pragma mark Internal: Tick Marks
// Implemented in subclasses:
- (NSString *) longestLabel;
- (CGSize) sizeTickLabels;
- (BOOL) spaceForLabels:(int)numLabels withLabelSizeScalers:(CGPoint)scale;
- (void) updateInternalMajorTickFrequency:(CGSize *)largestLabelSize;
- (void) updateInternalMinorTickFrequency;
- (NSNumber *) firstMajorTick;
- (BOOL) firstTickInsideChart:(double)firstTickValue;
- (NSNumber *) firstMinorTick;
- (BOOL) isOverAlternate:(double)tickMarkValue;
- (double) incrementTickMarkValue:(double)tickMarkValue isMajor:(BOOL) major;

// Implemented in superclass:
- (void) generateTickMarks:(BOOL)redrawLabels;
- (double) getPixelforTick:(double)tickMarkValue;
- (void) rotateLabel:(UILabel *)tickLabel;
- (NSNumber *) setAnchorPoint;
- (SChartTickMark *) createTickMarkWithFrame:(CGRect)frame withTickMark:(SChartTickMark *)tm forValue:(double)value asMajor:(BOOL)major shouldCreateLabel:(BOOL)createLabel isOverAlternateStripe:(BOOL)overAlternate shouldUpdateText:(BOOL)updateText;


#pragma mark -
#pragma mark Internal: Data
- (void)dataSeriesChanged;
- (id)internalFloatToDataObject:(double)fp;

#pragma mark -
#pragma mark Internal: Series Linking
- (BOOL)isLinkedToSeries:(SChartSeries *)series;
- (NSArray *)ownedSeries;

#pragma mark -
#pragma mark Internal: Mapping
/*
 * These functions are used only internally, for:
 * 1) Annotation mapping       - map a pixel to a data value to display
 * 2) Annotaiton mapping       - map an interpolated data value back to a pixel
 * 3) Momentum panning         - map a pixel-velocity to a coord-velocity (otherwise momentum speed would be proportional to the axis range)
 * 4) Zooming {bar,col}Spacing - for calculating the minimum gl points, to draw to, in canvas
 */
// pixel --> data
- (double)scaleDataValueForPixelValue:(double)pixelValue inFrame:(CGRect)frame;
- (double)scaleDataValueForPixelValue:(double)pixelValue;
- (double)mapDataValueForPixelValue:(double)pixelValue;

// data --> pixel
- (double)mapPixelValueForDataValue:(double)dataValue usingSeries:(SChartSeries *)series; // need series to offset for {col,bar}Spacing
- (double)scalePixelValueForDataValue:(double)dataValue;

// return the adjustment applied to a datavalue for its actual display position on the canvas
- (double)dataValueAdjustForSeries:(SChartSeries *)series;

// data <--> gl-coord
- (double)scaleCoordForDataValue:(id)datavalue;
- (double)mapCoordForDataValue:(id)datavalue;

/*  Map all the series data to openGL coordinates. */
//- (void)mapCoordinatesForDataPoints:(NSArray *)serieses;

/* Returns the real data represented by a glCoord (1D) */
-(NSNumber *)dataValueFromCoord:(double)coord;

/* Map a datapoint to openGL coordinates. */
-(void)mapCoordinatesForDataPoint:(SChartInternalDataPoint *)dp inSeries:(SChartCartesianSeries *)series;

/* Map a datapoint of a barColumnSeries to openGL coordinates. */
-(void)mapCoordinatesForBarColumnChartDataPoint:(SChartInternalDataPoint *)dp inSeries:(SChartBarColumnSeries *)series;

/* Recalculate barcolumn spacing, min and max values */
- (void) recalculateBarColumns:(NSArray *)barColumnSeries;

/** Provide bounds and spacing data for column series within the chart to improve performance */
- (void)configureColumns:(float) colSpacing withMinX:(NSNumber *)minX withMaxX:(NSNumber *)maxX;

/** Provide bounds and spacing data for bar series within the chart to improve performance */
- (void)configureBars:(float) barSpacing withMinY:(NSNumber *)minY withMaxY:(NSNumber *)maxY;


#pragma mark -
#pragma mark Internal: Drawing
- (void)drawTickMarksWithGLFrame:(CGRect)glFrame usingAxisDrawer:(SChartCanvasUnderlay*)drawer needToRedrawLabels:(BOOL)redrawLabels;

/* Draws the axis relative to the openGl frame*/
@property (nonatomic, assign) float secondaryAxisOffset;
- (void)drawAxisWithGLFrame:(CGRect)frame usingAxisDrawer:(SChartCanvasUnderlay *)drawer;

/* Returns the amount of space need by the axis for tick marks, labels etc. */
- (float)spaceRequiredToDraw;

- (BOOL)valueIsVisible:(double)value onSeries:(SChartSeries *)series;
- (void)ensureValueIsVisible:(double)value andRedraw:(BOOL)redraw;
- (void)ensureValueIsVisible:(double)value;
- (NSString *)stringForValue:(double)value;
- (NSString *)stringForId:(id)obj;


#pragma mark -
#pragma mark Internal: Gestures
- (void) cancelGestures;
- (void) stopAnimations;

- (void)stopMomentumZooming;
- (void)stopMomentumPanning;

@end
