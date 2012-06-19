//
//  SChartCrosshairTooltip.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SChartCanvas;

/** A simple extension of the UIView class to use as the standard cross hair tooltip.
 
 To create a custom tooltip - subclass this class and override the functions below. When the standard crosshair moves position it will call the following functions in order:
 
 1) setTooltipStyle: <br>
 2) setDataPoint:fromSeries:fromChart: <br>
 3) setPosition:onCanvas: */
@interface SChartCrosshairTooltip : UIView {
    UILabel *label;
    SChartCrosshairStyle *style;
}

@property (nonatomic, retain) UILabel *label;

/** The first method called by the standard crosshair.
 
 Passes in the crosshair style object to update the look and feel of the tooltip*/
- (void)setTooltipStyle:(SChartCrosshairStyle*)style;

/** The second method called by the standard crosshair.
 
 Passes in information about the current crosshair data point. To convert dataPoint to a useful value - use the axis, eg:
 
 <code>[chart.xAxis stringForValue:dataPoint.x]</code>*/
- (void)setDataPoint:(id<SChartData>)dataPoint fromSeries:(SChartSeries *)series fromChart:(ShinobiChart *)chart;

/** The third and final method called by the standard crosshair.
  
 Passes in the position of the crosshair target and the current canvas. This allows positioning of the tooltip, using the canvas to do border checks. */
- (void)setPosition:(struct SChartPoint)pos onCanvas:(SChartCanvas*)canvas;

@end
