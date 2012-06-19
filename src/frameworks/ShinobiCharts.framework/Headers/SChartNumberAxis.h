//
//  SChartNumberAxis.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SChartAxis.h"

@class SChartNumberRange;

/** 
 An SChartNumberAxis is a subclass of SChartAxis designed to work with data points that use NSNumber. When mapping coordinates it will cast each object to an NSNumber. 
 
 The frequency values for tick marks are expected to be NSNumber objects.
 */
@interface SChartNumberAxis : SChartAxis {
    
@private
    int requiredPrecision;
    int maxPrecision;
}

#pragma mark - 
#pragma mark Initialisation
/** @name Initialisation */
/** Init with a SChartNumberRange as the default range*/
- (id)initWithRange:(SChartNumberRange *)range;

#pragma mark - 
#pragma mark Internal: Precisions for labels
- (void)calcPrecision:(double)value;

@end
