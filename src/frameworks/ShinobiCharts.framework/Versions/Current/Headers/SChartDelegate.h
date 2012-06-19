//
//  SChartDelegate.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShinobiChart;
@class SChartSeries;
@class SChartDataPoint;
@class SChartRadialDataPoint;
@class SChartRadialSeries;

/**
  SChartMovementInformation describes why a chart is triggering pan and zoom delegate methods.

  Currently it contains one member - movementIsMomentum. This is true if the chart is panning due to momentum.
 */
typedef struct SChartMovementInformation
{
    int movementIsMomentum : 1;
} SChartMovementInformation;

/**
 The SChartDelegate protocol provides the chart with a target to relay events to, such as when the user is zooming or other touch events. Objects that act as a delegate to the ShinobiChart can use these notifications to synchronise other charts or update objects with the current status of this chart.
 
 In general, the data used to build the chart is handled by objects implementing the SChartDatasource protocol.
 */
@protocol SChartDelegate <NSObject>
#pragma mark -
#pragma mark REQUIRED
@required

#pragma mark -
#pragma mark OPTIONAL
@optional
#pragma mark -
#pragma mark Zooming
/** @name Responding to zoom events */
/** A notification that the chart object has started a zoom operation.
 
 This method is called once at the start of a zoom gesture by the user. Each axis maintains its own zoom level, which is available through the property `chart.xAxis.zoom` etc. To monitor the progress of the zoom gesture as it happens, implement the method sChartIsPanning: */
- (void)sChartDidStartZooming:(ShinobiChart *)chart;

/** A notification that the chart object has finished a zoom operation.
 
 The resulting zoom level is available for each axis object, eg: `chart.xAxis.zoom` */
- (void)sChartDidFinishZooming:(ShinobiChart *)chart;

/** A notification that the chart object has reset the zoom level.
 
 The zoom level can be reset to the _default range_. Implement this method to be notified when the chart has reset to the default zoom level. */
- (void)sChartDidResetZoom:(ShinobiChart *)chart;

/** A notification that the chart object is zooming.
 
 This method will be continually called during a zoom operation and is particularly useful to keep multiple charts synchronised. The current zoom level is available on the axis object, and other charts may be programatically zoomed to respond. */
- (void)sChartIsZooming:(ShinobiChart *)chart;

/** A notification that the chart object is zooming, with additional data
 
 This method is similar to sChartIsZooming:, however extra data describing the zoom is given as an argument */
- (void)sChartIsZooming:(ShinobiChart *)chart withChartMovementInformation:(const SChartMovementInformation *)information;

/** A notification that the chart has adjusted zoom level using the box feature. */
- (void)sChartDidBoxZoom:(ShinobiChart *)chart;

#pragma mark -
#pragma mark Panning
/** @name Responding to panning events */
/** A notification that the chart object has started a panning operation.
 */
- (void)sChartDidStartPanning:(ShinobiChart *)chart;

/** A notification that the chart object has finished a panning operation.
 
 After a pan operation, the axis will have a new range available eg: `chart.xAxis.axisRange`*/
- (void)sChartDidFinishPanning:(ShinobiChart *)chart;

/** A notification that the chart object is panning.
 
 The range for each axis (ie: `chart.xAxis.axisRange`) is updated as the user pans the chart - this method is called continually during the pan gesture.*/
- (void)sChartIsPanning:(ShinobiChart *)chart;

/** A notification that the chart object is panning, with additional data
 
 This method is similar to sChartIsPanning:, however extra data describing the pan is given as an argument */
- (void)sChartIsPanning:(ShinobiChart *)chart withChartMovementInformation:(const SChartMovementInformation *)information;

#pragma mark -
#pragma mark Touch Gestures
/** @name Responding to touch events */
/** A notification that a series has been selected or de-selected.
 
 A touch gesture has resulted in the `selected` property of the series changing. The nearest data point is returned along with the current pixel coordinates of that point.  */
- (void)sChart:(ShinobiChart *)chart toggledSelectionForSeries:(SChartSeries *)series nearPoint:(SChartDataPoint *)dataPoint
atPixelCoordinate:(CGPoint)pixelPoint;

/** A notification that a data point has been selected or de-selected.
 
 A touch gesture has resulted in the `selected` property of the data point changing. The data point is returned along with the current pixel coordinates of that point and the series that it belongs to.  */
- (void)sChart:(ShinobiChart *)chart toggledSelectionForPoint:(SChartDataPoint *)dataPoint inSeries:(SChartSeries *)series
atPixelCoordinate:(CGPoint)pixelPoint;

/** A notification that a data point on a radial (pie or donut, etc) chart has been selected or de-selected.
 
 A touch gesture has resulted in the `selected` property of the data point changing. The data point is returned along with the current pixel coordinates of that point and the series that it belongs to.  */
- (void)sChart:(ShinobiChart *)chart toggledSelectionForRadialPoint:(SChartRadialDataPoint *)dataPoint inSeries:(SChartRadialSeries *)series
atPixelCoordinate:(CGPoint)pixelPoint;

#pragma mark -
#pragma mark Crosshair
/** @name Tracking the crosshair */
/** Notifies the user when the crosshair moves
 
 When the crosshair is panned, the new values at the crosshair point are passed into this method. For a line series, the values will be interpolated if they lie between actual data points. On a category axis - or bar/column series - the crosshair will snap to the discrete values. */
- (void)sChart:(ShinobiChart *)chart crosshairMovedToXValue:(id)x andYValue:(id)y;

#pragma mark -
#pragma mark Rendering

/** A notification that the chart object has started rendering

  If the chart is carrying out a full redraw, the second argument, fullRedraw, is true */
- (void)sChartRenderStarted:(ShinobiChart *)chart withFullRedraw:(BOOL)fullRedraw;

/** A notification that the chart object has finished rendering
  */
- (void)sChartRenderFinished:(ShinobiChart *)chart;

@end

