//
//  SChartCrosshair.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShinobiChart;
@class SChartSeries;
@class SChartCrosshairStyle;
@class SChartCrosshairTooltip;
@protocol SChartData;

/** The SChartCrosshair provides a small circle target with lines that extend to the axis. This is accompanied by a tooltip object - nominally a UIView.
 
 The crosshair is enabled with a _tap-and-hold gesture_ and will lock to the nearest series to pan through the values. On a line series the values will be interpolated between data points, on all other series types the crosshair will jump from data point to data point. Note that line series interpolation can be switched off by setting `interpolatePoints` to `NO` */
@interface SChartCrosshair : UIView {
@private
    
    struct SChartPoint crosshairCentrePoint;
    
    SChartSeries *crosshairSeries;
}

#pragma mark -
#pragma mark Init
/** @name Initialisation */
/** Create a crosshair with frame and the chart handle */
-(id)initWithChart:(ShinobiChart *)parentChart;

-(id)initWithFrame:(CGRect)frame usingChart:(ShinobiChart *)parentChart DEPRECATED_ATTRIBUTE;

/** The handle to the chart allowing the crosshair to access chart data */
@property (nonatomic, assign) ShinobiChart *chart;

#pragma mark -
#pragma mark Style
/** @name Style */
/** All of the properties to style the crosshair */
@property (nonatomic, retain) SChartCrosshairStyle *style;

#pragma mark -
#pragma mark Format
/** @name Format */
/** The UIView to present the data values to the user 
 
 Override this to provide a custom view to present the crosshair data.*/
@property (nonatomic, retain) SChartCrosshairTooltip *tooltip;

/** When set to `YES` the lines from the target point to the axis will be displayed. */
@property (nonatomic)         BOOL    enableCrosshairLines;
@property (nonatomic)         BOOL    enableCrosshairLinesSet;

/** If set to 'YES' the crosshair will move smoothly betwen points when tracking a line series */
@property (nonatomic)         BOOL      interpolatePoints;

/** Displays the crosshair (with lines and tooltip) on the chart
 
 This method is called by the chart when the crosshair should be displayed. Override this method to control the display of the crosshair in subclasses. */
-(void)showCrosshair;

/** Hides the crosshair (with lines and tooltip) on the chart
 
 This method is called by the chart when the crosshair should be dismissed. Override this method to control the display of the crosshair in subclasses. */
-(BOOL)removeCrosshair;

/** Performs the drawing of the lines and target circle element of the crosshair.
 
 Override this function to provide custom lines or other drawn elements. */
-(void)drawCrosshairLines;

/** Sets the current tooltip element of the crosshair to be the default baseclass - SChartCrosshairTooltip. */
-(void)setDefaultTooltip;

/** This method is called when the crosshair changes position. 

The point `coords` is the location in pixels on the series where the crosshair should appear. The `dataPoint` is either an interpolated point or actual data point to represent in the tooltip. Override this method in a subclass to populate a custom crosshair. */
- (void)moveToPosition:(SChartPoint)coords andDisplayDataPoint:(SChartPoint)dataPoint fromSeries:(SChartSeries *)series andSeriesDataPoint:(id<SChartData>)datapoint;


@end
