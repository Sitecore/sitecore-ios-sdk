//
//  SChartMultiXDataPoint.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SChartData;

@interface SChartMultiXDataPoint : NSObject <SChartData>

#pragma mark -
#pragma mark Data
/** @name Representing real data for a series */
/** A single x value representation of this data point */
@property (nonatomic, retain) id xValue;

/** The y value of this data point. */
@property (nonatomic, retain) id yValue;

/** A dictionary of values for this data point. */
@property (nonatomic, retain) NSMutableDictionary *xValues;

#pragma mark -
#pragma mark Selection and Highlighting
/** @name Point selection */
/** Is this point selected.
 
 When set to `YES` this data point will adopt a selected state. One effect based on this state is the style,  the series will apply the selected style to a selected point. */
@property (nonatomic, assign) BOOL selected;


@end