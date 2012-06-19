//
//  SChartNumberRange.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SChartRange;

/** 
 An SChartNumberRange object is an SChartRange that is specific to NSNumber - with each element represented by an NSNumber. This is the likely range of choice for an SChartNumberAxis - but a number range can also be applied to other axis types including SChartDateTimeAxis and SChartCategoryAxis.
 */
@interface SChartNumberRange : SChartRange

@end
