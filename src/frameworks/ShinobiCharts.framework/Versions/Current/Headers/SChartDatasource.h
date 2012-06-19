//
//  SChartDatasource.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShinobiChart;
@class SChartSeries;
@class SChartInternalDataPoint;
@class SChartAxis;
@protocol SChartData;

/**
 The SChartDatasource protocol is adopted by an object that wishes to provide data for a ShinobiChart. The data source provides the chart with the information it needs to construct the chart object. In general, styling and event response is handled by objects implementing the SChartDelegate protocol - the data source has minimal impact on the look and feel of the chart.
 
 The _required_ methods provide the chart with information about all of the series to be displayed on that chart - and the data for those series. The relevant chart object is always returned - to support the option of using a single object as the data source for multiple charts.
 */
@protocol SChartDatasource <NSObject>
#pragma mark -
#pragma mark REQUIRED
@required
#pragma mark -
#pragma mark Series
/** @name Providing data for a ShinobiChart */
/** The number of individual series for this chart. 
 
 The chart can display an integer number of series - for example, a line series or two column series and a scatter series. For each of these series, the chart will expect to receive a SChartSeries object through sChart:seriesAtIndex: */
- (int)numberOfSeriesInSChart:(ShinobiChart*)chart;

/** This method must return the SChartSeries object for the given index, the number of SChartSeries are specified in numberOfSeriesInSChart:.
 
 The order is important for some series layouts - lower index series are placed on the chart first and will be _behind_ subsequent series. It is much more likely that a subclass of SChartSeries will be returned here, eg: SChartLineSeries, SChartBarSeries.
 */
- (SChartSeries*)sChart:(ShinobiChart*)chart seriesAtIndex:(int)index;

#pragma mark -
#pragma mark Data
/** The number of data points in the series indicated by this index.
 
 The series index is implied from sChart:seriesAtIndex: and the order in which the series are returned. For each of these data points, the chart will expect to receive an object that implements the SChartData protocol - provided by sChart:dataPointAtIndex:forSeriesAtIndex:
 */
- (int)sChart:(ShinobiChart*)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex;

/** The object that represents the data point at this index for this series.
 
 The number of points for a series is set by sChart:numberOfDataPointsForSeriesAtIndex: This can be any object that implements the SChartData protocol - such as the provided class SChartInternalDataPoint */
- (id<SChartData>)sChart:(ShinobiChart*)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex; 


#pragma mark -
#pragma mark OPTIONAL
@optional


#pragma mark -
#pragma mark Tickmarks
/** @name Custom tick marks */
/** Return an array of major tick mark values for an axis.
 
 If this method is implemented, the major tick marks will be fixed as those values in the array - no other values will be calculated or interpolated. 
 Objects in the array should be of the NSNumber class */
- (NSArray *)sChart:(ShinobiChart*)chart majorTickValuesForAxis:(SChartAxis *)axis;


#pragma mark -
#pragma mark Data Points
/** @name Custom data point images */
/** Return a UIImage to be displayed on a data point
 
 If this method is implemented and a non-nil UIImage is returned for a data point in a series, that UIImage will be displayed on the data point. */
- (UIImage *)sChartTextureForPoint:(ShinobiChart*)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex;

/** @name Custom data point radii */
/** Return a float as the radius of a data point

 If this method is implemented and a non-zero radius is returned for a data point in a series, that radius will be used for the data point. */
- (float)sChartRadiusForDataPoint:(ShinobiChart*)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex;


#pragma mark -
#pragma mark Radial Chart Labels
/** @name Custom labels for radial charts */
/** Return a UILabel for a 'slice' of a radial chart series.
 
 If this method is implemented and a non-nil UILabel is returned for a 'slice' in a radial chart series, that UILabel will be added to the chart. */
- (UILabel *)getLabelsForRadialChartSeries:(SChartSeries *)series forIndex:(int)sliceIndex;


#pragma mark -
#pragma mark Axes
/** @name Assigning an axis to a series */
/** The x-axis for this series on the chart
 
 If this method is implemented the chart will look here for which axis to use when representing this series, otherwise this series will default to using the primary x-axis on the chart.
 
 Hint: This is only needed on charts with multiple axes.
 
 *Note: The SChartAxis returned should be referenced from an existing chart axis and not a new object. _eg: return chart.xAxis_*
 
 To specify an axis for some series and not for others, returning `nil` for a series index will revert to default behaviour for that series.
 */
- (SChartAxis*)sChart:(ShinobiChart*)chart xAxisForSeriesAtIndex:(int)index;

/** The y-axis for this series on the chart
 
 If this method is implemented the chart will look here for which axis to use when representing this series, otherwise this series will default to using the primary y-axis on the chart.
 
 Hint: This is only needed on charts with multiple axes.
 
 *Note: The SChartAxis returned should be referenced from an existing chart axis and not a new object. _eg: return chart.yAxis_*
 
 To specifiy an axis for some series and not for others, returning `nil` for a series index will revert to default behaviour for that series.*/
- (SChartAxis*)sChart:(ShinobiChart*)chart yAxisForSeriesAtIndex:(int)index;


@end
