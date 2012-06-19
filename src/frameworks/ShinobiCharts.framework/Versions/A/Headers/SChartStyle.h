//
//  SChartStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** The style properties for the ShinobiChart object
 
 */
@interface SChartStyle : NSObject

/** @name Styling Properties */
/** The UIColor for the background of the full chart view */
@property (nonatomic, retain)     UIColor  *backgroundColor;
/** The second UIColor for the background of the full chart view to form a gradient */
@property (nonatomic, retain)     UIColor  *backgroundColorGradient;
/** The UIColor of the border for the full chart view */
@property (nonatomic, retain)     UIColor  *borderColor;
/** The width of the border for the full chart view */
@property (nonatomic, retain)     NSNumber *borderWidth;
/** The UIColor for the background of the plot area.
 
 The plot area being the region bounded by the axes.*/
@property (nonatomic, retain)     UIColor  *plotAreaBackgroundColor;
/** The UIColor for the border of the plot area.
 
 The plot area being the region bounded by the axes.*/
@property (nonatomic, retain)     UIColor  *plotAreaBorderColor;
/** The line width for the border of the plot area.
 
 The plot area being the region bounded by the axes, but excluding the axes.*/
@property (nonatomic, retain)     NSNumber *plotAreaBorderWidth;
/** The UIColor for the background of the canvas area.
 
 The canvas area being the region bounded by the axes, including the axes themselves.*/
@property (nonatomic, retain)     UIColor  *canvasBackgroundColor;

@end
