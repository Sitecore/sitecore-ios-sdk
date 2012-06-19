//
//  SChartData.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/** The SChartData protocol allows any object to act as a datapoint for a series on a ShinobiChart. The method `sChart:dataPointAtIndex:forSeriesAtIndex:` on the SChartDatasource requires an object that implements this protocol. It can be your own object or the supplied SChartDataPoint class.
 
 */

@protocol SChartData <NSObject>
#pragma mark -
#pragma mark REQUIRED
@required
/** @name Single value points */
/** Should return an appropriate X value object. */
- (id)sChartXValue;

/** Should return an appropriate Y value object.
 
 This is used for series that require only a single Y value. Series that require multiple Y-values should implement sChartYValueForKey: and check the specific series class for the required keys. */
- (id)sChartYValue;


@optional
/** @name Multi value points */

/** Should return an appropriate X value for the provided key.
 
This is only required for series with more than one X value and keys are specified on the series type - eg: OHLC keys include "low", "high", etc. For series with just a single X implement sChartXValue */
- (id)sChartXValueForKey:(NSString*)key;

/** Should return an appropriate Y value for the provided key. 
 
 This is only required for series with more than one Y value and keys are specified on the series type - eg: OHLC keys include "low", "high", etc. For series with just a single Y implement sChartYValue */
- (id)sChartYValueForKey:(NSString*)key;

@end
