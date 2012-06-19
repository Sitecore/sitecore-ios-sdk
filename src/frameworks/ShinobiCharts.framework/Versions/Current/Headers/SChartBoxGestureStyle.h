//
//  SChartBoxGestureStyle.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** The style properties for the box zoom feature.
 
 */
@interface SChartBoxGestureStyle : NSObject 
/** @name Styling Properties */
/** The UIColor assigned to the outline of the box that will be the new zoomed area */
@property (nonatomic, retain) UIColor *boxLineColor;
/** The width of the outline of the box that will be the new zoomed area */
@property (nonatomic, assign) float boxLineWidth;
/** The UIColor if the lines that extend from the zoom box to the axes */
@property (nonatomic, retain) UIColor *trackingLineColor;
/** The width if the lines that extend from the zoom box to the axes */
@property (nonatomic, assign) float trackingLineWidth;

@end
