//
//  SChartCanvas.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SChartGLView;
@class SChartCanvasOverlay;
@class SChartCanvasUnderlay;
@class SChartCanvasRenderView;
@class ShinobiChart;

//
// For each ShinobiChart, one single SChartCanvas will exist to contain the drawing of all of the axes and series. Titles, legends and other chart level objects appear outside of this area in the ShinobiChart view. The canvas is responsible for managing the layers that make up the axis and series.
// 
// The canvas itself has no objects drawn directly onto it. The canvas decides how much space it will need to draw any axis and their labels. The openGL view is then sized and laid down to draw the series. This is followed by the SChartCanvasOverlay layer that is used to draw the axes at the highest level.
// */
@interface SChartCanvas : UIView {
    
    SChartCanvasOverlay *overlay;
    SChartCanvasUnderlay *underlay;
    UIView *underlayForAnnotations;
    SChartGLView *glView;
    SChartCanvasRenderView *renderView;
    UIDeviceOrientation lastOrientation;
    
    BOOL redrawGL;
    BOOL orientationChanged;
    BOOL reloadedData;

    void *_reserved;
}

#pragma mark -
#pragma mark Initialising the canvas
// @name Initialising the canvas */
// The chart owner  - available to let us access the chart objects when we need*/
@property (nonatomic, assign) ShinobiChart *chart;
// The chart owner  - available to let us access the chart objects when we need*/
- (id)initWithFrame:(CGRect)frame usingChart:(ShinobiChart *)parentChart;

#pragma mark -
#pragma mark Gestures
-(void) enablePanning:(BOOL)enable;

#pragma mark -
#pragma mark Managing our drawing objects
// @name Managing our drawing objects */
// This is the layer that we draw all of our axes and their labels on - we used pixel based coordinates here */
@property (nonatomic, retain) SChartCanvasUnderlay* underlay;
// This is the layer where we draw all of our annotation views that are under data */
@property (nonatomic, retain) UIView* underlayForAnnotations;
// This is the layer that we draw all of our series on - it's openGL and therefore uses GL based coordinates */
@property (nonatomic, retain) SChartGLView *glView;
// This is the layer that we do things like the crosshair on */
@property (nonatomic, retain) SChartCanvasOverlay* overlay;

@property (nonatomic) BOOL redrawGL;
@property (nonatomic) BOOL reloadedData;

-(void)setNeedsToRenderChart;

@end
