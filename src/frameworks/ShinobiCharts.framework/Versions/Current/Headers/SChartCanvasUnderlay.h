//
//  SChartCanvasUnderlay.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class ShinobiChart;
@class SChartLayer;


// The canvas underlay is responsible for drawing things like gridlines and the axes. It's a transparent layer that is currently rendered _below_ the openGL layer. 

@interface SChartCanvasUnderlay : UIView <SChartLayer> {
    CGContextRef   buffer;
    CGRect glFrame;
}

#pragma mark -
#pragma mark Initialising the underlay
// @name Initialising the underlay */
// The chart owner  - available to let us access the chart objects when we need*/
@property (nonatomic, assign) ShinobiChart *chart;
// Create our drawing layer - we must know where the openGL layer is to keep the scaling in synch. */
-(id)initWithFrame:(CGRect)frame usingChart:(ShinobiChart *)chart;

#pragma mark -
#pragma mark Styling
// @name Styling the plot area */
// The color of the border on the plot area */
@property (nonatomic, retain) UIColor *borderColor;
// The width of the border on the plot area */
@property (nonatomic, assign) float   borderThickness;

#pragma mark -
#pragma mark Drawing on the underlay
-(void)drawLinesForXCoords:(NSArray*)xCoords andYCoords:(NSArray*)yCoords withColor:(UIColor*)color andWidth:(float)width;
-(void)drawLinesForXCoords:(NSArray*)xCoords andYCoords:(NSArray*)yCoords withColor:(UIColor*)color andWidth:(float)width andDashStyle:(NSArray *)dashes;
-(void)drawRects:(NSMutableArray*)rects withColor:(UIColor*)color;

@end
