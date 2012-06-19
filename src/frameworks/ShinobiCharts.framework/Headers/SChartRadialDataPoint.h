//
//  SChartRadialDataPoint.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SChartData;

/**
 In a ShinobiChart, one or more SChartRadialSeries, composed of SChartDatapoints in a SChartDataSeries, may be visualised. 
 
 Each SChartRadialDataPoint represents a simple data point in a SChartDataSeries. The radial data point is made up of a name and a value (magnitude).  
 Unlike data points in non-radial Shinobi Charts, an SChartRadialDataPoint can have only one value. The translation of these objects onto a chart is handled internally.
 */

@interface SChartRadialDataPoint : NSObject <SChartData>

#pragma mark -
#pragma mark Data
/** @name Representing real data for a series */
/** The name of this data point */
@property (nonatomic, retain) NSString *name;

/** The value or magnitude of data point.
 
 All radial data points have a single value. */
@property (nonatomic, retain) NSNumber *value;

#pragma mark -
#pragma mark Selection and Highlighting
/** @name Point selection */
/** Is this data point selected.
 
 When set to `YES` this data point will adopt a selected state. One effect based on this state is the style, the series will apply the selected style to a selected point. */
@property (nonatomic, assign) BOOL selected;

@end
