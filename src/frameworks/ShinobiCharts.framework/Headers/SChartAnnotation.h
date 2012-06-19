//
//  SChartAnnotation.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SChartAxis;
@class SChartCanvas;
@class SChartAnnotationZooming;

typedef enum {
    SChartAnnotationAboveData,
    SChartAnnotationBelowData,
} SChartAnnotationPosition;

/** An SChartAnnotation is a UIView that can be displayed on a chart - maintaining aspect ratio at all times and postion in accordance with the panning of the data range (see below). There are several predefined annotations for convenience - these can be created using the methods below and are bands, lines and text. 
 
 An SChartAnnotation is fixed to a single point in the data range which means that it will pan but will always remain a fixed size regardless of zoom level. If you would like to annotate an area that will scale as the data range is zoomed use SChartAnnotationZooming which is anchored to two distinct points.
 */
@interface SChartAnnotation : UIView

/** @name Positioning the annotation */
/** The x-axis that the UIView is attached to. 
 nil value will cause the view to be displayed at the midpoint of the width of the chart plot area. */
@property (nonatomic, retain) SChartAxis *xAxis;
/** The y-axis that the UIView is attached to. 
 nil value will cause the view to be displayed at the midpoint of the height of the chart plot area. */
@property (nonatomic, retain) SChartAxis *yAxis;

/** The value on the given xAxis that the view is going to be anchored to. 
 nil value will cause the view to be displayed at the midpoint of the width of the chart plot area. */
@property (nonatomic, retain) id xValue;
/** The value on the given yAxis that the view is going to be anchored to. 
 nil value will cause the view to be displayed at the midpoint of the height of the chart plot area. */
@property (nonatomic, retain) id yValue;

/** Determines if the annotation should be drawn above or below the chart data.
 
 typedef enum {<br>
 SChartAnnotationAboveData,<br>
 SChartAnnotationBelowData,<br>
 } SChartAnnotationPosition;
 
 Default is SChartAnnotationAboveData.
 */
@property (nonatomic) SChartAnnotationPosition position;

#pragma mark -
#pragma mark Factory methods
/** @name Creating standard pre-defined annotations */
/** Creates an annotation based on a UILabel with the given string at the given x and y axis positions */
+(SChartAnnotation *)annotationWithText:(NSString *)text 
                                andFont:(UIFont *)font
                              withXAxis:(SChartAxis *)xAxis 
                               andYAxis:(SChartAxis *)yAxis 
                            atXPosition:(id)xValue 
                           andYPosition:(id)yValue 
                          withTextColor:(UIColor *)textColor
                    withBackgroundColor:(UIColor *)backgroundColor;

/** Creates a vertical line at the given x position that spans the whole height of the y axis. */
+(SChartAnnotationZooming *)verticalLineAtPosition:(id)xValue 
                                         withXAxis:(SChartAxis *)xAxis 
                                          andYAxis:(SChartAxis *)yAxis 
                                         withWidth:(float)width 
                                         withColor:(UIColor *)color;

/** Creates a horizontal line at the given y position that spans the whole height of the x axis. */
+(SChartAnnotationZooming *)horizontalLineAtPosition:(id)yValue 
                                           withXAxis:(SChartAxis *)xAxis 
                                            andYAxis:(SChartAxis *)yAxis 
                                           withWidth:(float)width 
                                           withColor:(UIColor *)color;

/** Creates a vertical band that spans the given range on the x axis and spans the whole height of the y axis. */
+(SChartAnnotationZooming *)verticalBandAtPosition:(id)minX 
                                           andMaxX:(id)maxX 
                                         withXAxis:(SChartAxis *)xAxis 
                                          andYAxis:(SChartAxis *)yAxis 
                                         withColor:(UIColor *)color;

/** Creates a horizontal band that spans the given range on the y axis and spans the whole width of the x axis. 
 
 */
+(SChartAnnotationZooming *)horizontalBandAtPosition:(id)minY 
                                             andMaxY:(id)maxY 
                                           withXAxis:(SChartAxis *)xAxis 
                                            andYAxis:(SChartAxis *)yAxis 
                                           withColor:(UIColor *)color;

#pragma mark -
#pragma mark Positioning
/** @name Drawing the annotation */
/** Draws the annotation on the chart plot area.
 
 Override this method to provide custom updating of the annotation view during positioning.*/
-(void)updateViewWithCanvas:(SChartCanvas *)canvas;

@end


#pragma mark -
#pragma mark Zooming annotation

/** An SChartAnnotationZooming object is pinned to two points on the chart and will scale according to the current range ofthe axis. This kind of annotation is useful for highlighting areas of data, etc. An SChartAnnotation is pinned at just a single value and will maintain it's own aspect ratio and size regardless of zoom, whereas this SChartAnnotationZooming object will fit between {xValue,yValue} and {xValueMax,yValueMax}.
 */
@interface SChartAnnotationZooming : SChartAnnotation

/** The second value on the x-axis that the view is going to be anchored to. 
 nil value will cause the view to be displayed with its original width. */
@property (nonatomic, retain) id xValueMax;

/** The second value on the y-axis that the view is going to be anchored to. 
 nil value will cause the view to be displayed with its original height. */
@property (nonatomic, retain) id yValueMax;

/** Causes the view to be stretched to cover the whole width of the chart plot area */
@property (nonatomic) BOOL stretchToBoundsOnX;

/** Causes the view to be stretched to cover the whole height of the chart plot area */
@property (nonatomic) BOOL stretchToBoundsOnY;

#pragma mark -
#pragma mark Positioning and Zooming

/** Positions the annotation on the chart plot area and zooms according to axis ranges. */
-(void)updateViewWithCanvas:(SChartCanvas *)canvas;

@end