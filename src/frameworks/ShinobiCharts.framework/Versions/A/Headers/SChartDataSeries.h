//
//  SChartDataSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 
 Each SChartSeries requires a set of data points that it will visually represent. The SChartDataSeries looks after these points and is not concerned with style or aesthetics. All properties here are related to the data only.
 
 */
@interface SChartDataSeries : NSObject {
    NSMutableArray *dataPoints;
    NSMutableArray *xValueKeys;
    NSMutableArray *yValueKeys;
}
/** @name Data for the series */
/** An array of SChartInternalDataPoints representing the data for the series.
 
 The data series maintains it's own copy of the data points. This allows the data provided to the data source to be modified and then atomically updated using `reloadData` at the chart level. */
@property (nonatomic, retain) NSMutableArray *dataPoints;

/** An array of keys (NSString objects) for this series.
 
 If the series requires multiple x values, it should return the keys here. The data source will then attempt to load these keys for this series. */
@property (nonatomic, retain) NSMutableArray *xValueKeys;

/** An array of keys (NSString objects) for this series.
 
 If the series requires multiple y values, it should return the keys here. The data source will then attempt to load these keys for this series. */
@property (nonatomic, retain) NSMutableArray *yValueKeys;

-(NSArray*)allXValues;
-(NSArray*)allYValues;

@end
