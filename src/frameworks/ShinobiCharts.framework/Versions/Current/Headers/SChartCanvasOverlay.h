//
//  SChartCanvasOverlay.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol SChartLayer;
@protocol SChartData;
@class ShinobiChart;
@class SChartSeries;
@class SChartInternalDataPoint;
@class SChartCrosshairStyle;
@class SChartPinchPanGestureRecogniser;
@class SChartBoxGestureRecogniser;
@class SChartCrosshair;
@class SChartCanvas;
@class SChartDataPoint;

//
// The canvas overlay is responsible for drawing objects that appear over the plot area - such as crosshairs.  It's a transparent layer that is rendered _above_ the openGL layer. 
//
@interface SChartCanvasOverlay : UIView <SChartLayer> {
    SChartCanvas *canvas;
    
    SChartCrosshair *crosshair;
    
    // stored so it can be enabled and disabled as the axis.enableGesturePanning is
    SChartPinchPanGestureRecogniser *pinchAndPanGesture;
    SChartBoxGestureRecogniser      *boxGesture;
    UITapGestureRecognizer          *doubleTapGesture;
    UITapGestureRecognizer          *singleTapGesture;
    UITapGestureRecognizer          *radialTapGesture;
    UILongPressGestureRecognizer    *longPressGesture;
    BOOL gesturePanCancelsCrosshair;
    BOOL atLeastOneAxisNeedsPanning; // YES if at least one axis needs panning enabled
    
    CGPoint lastPanPoint;
    CGPoint prevScale;
    CGPoint prevZoomFactor;
    CGRect  lastZoomBox; // for boxGesture
    UIView *zoomBoxView;
    UIView *zoomBoxLine1;
    UIView *zoomBoxLine2;
    
    // Long tap variables */
    SChartSeries *lastSeries;         // lock to this series
    SChartPoint   lastDataPoint;      // last interpolated value
    id<SChartData> lastSeriesPoint; // last user-datapoint
    
    CFTimeInterval       lastLongPressTime; // used to prevent sudden zipping to the end of a chart
    
    BOOL firstTimeTracking; // Dirrrrrty
}

#pragma mark -
#pragma mark Initialising the underlay
// @name Initialising the overlay */
// The chart owner  - available to let us access the chart objects when we need*/
@property (nonatomic, assign) ShinobiChart *chart;

// Create our drawing layer - we must know where the openGL layer is for drawing */
-(id)initWithFrame:(CGRect)frame usingChart:(ShinobiChart *)parentChart andCanvas:(SChartCanvas *)parentCanvas;

#pragma mark -
#pragma mark Crosshair
// @name Crosshair */
// The crosshair object */
@property (nonatomic, retain) SChartCrosshair *crosshair;
-(SChartPoint)crosshairPositionToFramePosition:(SChartPoint)dataPoint withSeries:(SChartSeries *)series;
-(void)positionCrosshairIfVisible;

#pragma mark -
#pragma mark Gestures

@property (nonatomic) BOOL gesturePinchAspectLock, gesturePanCancelsCrosshair;
@property (nonatomic, assign) SChartGesturePanType gesturePanType;

-(void)enablePanning:(BOOL)enable;

// Alerts chart delegate if all axes have finished momentum zooming */
-(void) axisFinishedMomentumZooming:(SChartAxis *)axis;

// Alerts chart delegate if all axes have finished momentum panning */
-(void) axisFinishedMomentumPanning:(SChartAxis *)axis;

-(void) resetGestureRecognisers;
-(void) createGestureRecognizers;

-(void)axisIsZooming:(SChartAxis *)axis;
-(void)axisIsPanning:(SChartAxis *)axis;

@end
