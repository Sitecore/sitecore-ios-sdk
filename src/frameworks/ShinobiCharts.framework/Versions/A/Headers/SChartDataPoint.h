//
//  SChartDataPoint.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 In a ShinobiChart, one or more SChartSeries are visualised. The data displayed by these series is contained in a data series, SChartDataSeries. And, finally, each of these data series contains individual data points. This class is designed to represent these data items. 
 
 Each SChartDataPoint represents a _simple_ data point in a SChartDataSeries. The simple data point is made up of an x and a y object (not multiple y objects). It doesn't need to know what these objects are, it merely looks after them. Knowing how to interpet and translate these objects onto a chart is the job of a SChartAxis.
 */
@protocol SChartData;

@interface SChartDataPoint : NSObject <SChartData> {
    id xValue;
    id yValue;
    
    BOOL selected;
}

#pragma mark -
#pragma mark Data
/** @name Representing real data for a series */
/** The x value for this data point */
@property (nonatomic, retain) id xValue;

/** The y value for this data point.
 
 Used for series with a single Y value.*/
@property (nonatomic, retain) id yValue;

#pragma mark -
#pragma mark Selection and Highlighting
/** @name Point selection */
/** Is this point selected.
 
 When set to `YES` this data point will adopt a selected state. One effect based on this state is the style,  the series will apply the selected style to a selected point. */
@property (nonatomic, assign) BOOL selected;

@end
