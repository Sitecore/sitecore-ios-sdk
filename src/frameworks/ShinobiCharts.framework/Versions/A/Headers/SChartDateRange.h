//
//  SChartDateRange.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SChartRange;

/** 
 An SChartDateRange object is an SChartRange that is specific to NSDate - with each element represented by an NSDate. This is the likely range of choice for an SChartDateTimeAxis. 
 */
@interface SChartDateRange : SChartRange {
    
}

#pragma mark -
#pragma mark Initialization
/** @name Initialization */
/** Initializes the range with date objects for the min and max. */
- (id)initWithDateMinimum:(NSDate *)min andDateMaximum:(NSDate *)max;

/** @name Information about the range */
/** Returns the minimum of the range as an NSDate object */
- (NSDate *)minimumAsDate;

/** Returns the maximum of the range as an NSDate object */
- (NSDate *)maximumAsDate;


@end
