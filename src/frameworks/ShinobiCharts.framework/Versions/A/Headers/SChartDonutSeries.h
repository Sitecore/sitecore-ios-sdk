//
//  SChartDonutSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartRadialSeries.h"

@protocol SChartDatasource;
@class SChartDonutSeriesStyle;
 
/** An SChartDonutSeries displays magnitude data on the chart - the larger the value of the datapoint, the larger the slice representing that datapoint.
 
 Whereas datapoints for Cartesian Series require an X and a Y, Radial Series require a name and a value. 
 The xValue of a datapoint given to a Donut Series is used as the name of the slice, and the yValue is used as its magnitude.
 See 'SChartRadialDatapoint' for a convenience datapoint class.
 
 Tip: Styles for each individual slice can be configured in the series' SChartDonutSeriesStyle.
 Tip: Legends on donut charts show an entry for each datapoint, or slice, of a donut chart.
 
 
 *Related Classes:*
 
 SChartDonutSeriesStyle <br>
 SChartRadialSeries <br>
 SChartPieChart <br>
 SChartRadialDataPoint <br>
 
 */

@interface SChartDonutSeries : SChartRadialSeries {
    CGPoint donutCenter;
    BOOL    _firstRender;
    float   targetRotation;
}

#pragma mark -
#pragma mark Styling
/**@name Styling */
/** Override any default settings or theme settings on a _per series_ basis by editing the values in these style objects.
 
 The `SChartDonutSeriesStyle` contains all of the objects relevant to styling a donut series. */
-(SChartDonutSeriesStyle *)style;

-(void)setStyle:(SChartDonutSeriesStyle *)style;

/** Style settings in this object will be applied when the series is marked as selected (or a slice is selected).*/
-(SChartDonutSeriesStyle *)selectedStyle;

-(void)setSelectedStyle:(SChartDonutSeriesStyle *)selectedStyle;


/** The inner radius of the series. */
@property (nonatomic)         float                  innerRadius;

/** The outer radius of the series. */
@property (nonatomic)         float                  outerRadius;

/** The position to which the slice will rotate once selected **/
@property (nonatomic, retain) NSNumber               *selectedPosition;

/** The current rotation of the series */
@property (nonatomic)         float                  rotation;


/** Creates the labels for the donut series **/
-(void)createLabels:(id <SChartDatasource>)datasource;

/** Select a slice within a series **/
-(void)setSlice:(int)sliceIndex asSelected:(BOOL)sel;

/** Draw a slice of a series **/
- (void)drawSlice:(int)sliceIndex ofTotal:(int)totalSlices fromAngle:(float)startAngle toAngle:(float)endAngle 
       fromCentre:(CGPoint)centre withInnerRadius:(float)innerRadius andOuterRadius:(float)outerRadius asSelected:(BOOL)sel inFrame:(CGRect)frame;

/** Returns the centre of the slice at a given index within the chart as a CGPoint **/
- (CGPoint)getSliceCenter:(int)sliceIndex;

-(void)drawWithDrawer:(SChartGLView *)glView;

@end
