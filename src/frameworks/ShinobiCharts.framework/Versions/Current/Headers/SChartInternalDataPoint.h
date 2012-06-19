//
//  SChartInternalDataPoint.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SChartData;

/* Internal data points */
@interface SChartInternalDataPoint : NSObject <SChartData>

#pragma mark -
#pragma mark Data
/* @name Representing real data for a series */
/* The x value for this data point */
@property (nonatomic, retain) id xValue;

/* The y value for this data point */
@property (nonatomic, retain) id yValue;

/* X values by key for series that require multiple values. */
@property (nonatomic, retain) NSMutableDictionary *xValues;

/* Y values by key for series that require multiple values. */
@property (nonatomic, retain) NSMutableDictionary *yValues;


#pragma mark -
#pragma mark Texture
@property (nonatomic, retain) UIImage *texture;

#pragma mark -
#pragma mark Radius
@property (nonatomic, assign) float radius;


#pragma mark -
#pragma mark Coords
/* The x coordinate for this data point - calculate by the relevant axis */
@property (nonatomic, assign) double xCoord;

/* The y coordinate for this data point - calculate by the relevant axis */
@property (nonatomic, assign) double yCoord;

/* X coordinates by key for series that require multiple values. */
@property (nonatomic, retain) NSMutableDictionary *xCoords;

/* Y coordinates by key for series that require multiple values. */
@property (nonatomic, retain) NSMutableDictionary *yCoords;


#pragma mark -
#pragma mark Interaction
/* Is this point selected by a user */
@property (nonatomic, assign, getter = isSelected) BOOL selected;


#pragma mark -
#pragma mark Comparing values
/* @name Comparing values */
/* Compare the X component values of these two internal data points */
-(NSComparisonResult)compareXAsNumber:(SChartInternalDataPoint*)dp;

/* Compare the Y component values of these two internal data points */
-(NSComparisonResult)compareYAsNumber:(SChartInternalDataPoint*)dp;

@end
