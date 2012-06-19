//
//  SChartTickStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** The style properties for tick marks 
 
 */
@interface SChartTickStyle : NSObject 
/** @name Styling Properties */
/** Should tick marks be displayed on the axes. */
@property (nonatomic)             BOOL    showTicks;
@property (nonatomic)             BOOL    showTicksSet;

/** Should labels be displayed on the major tick marks. */
@property (nonatomic)             BOOL    showLabels;
@property (nonatomic)             BOOL    showLabelsSet;

/** The orientation of labels on major tick marks
 
 <code>typedef  enum {<br>
 TickLabelOrientationHorizontal,<br>
 TickLabelOrientationDiagonal,<br>
 TickLabelOrientationVertical
 } TickLabelOrientation;</code>
 */
@property (nonatomic)             TickLabelOrientation tickLabelOrientation;
@property (nonatomic)             BOOL    tickLabelOrientationSet;

/** The UIColor for the tick mark lines */
@property (nonatomic, retain)     UIColor *lineColor;
/** The width of the tick mark line in pixels */
@property (nonatomic, retain)     NSNumber *lineWidth;
/** The length of the tick mark lines in pixels */
@property (nonatomic, retain)     NSNumber *lineLength;
/** The color for the text in labels */
@property (nonatomic, retain)     UIColor *labelColor;
/** The font for the labels */
@property (nonatomic, retain)     UIFont  *labelFont;
/** The shadow color for label text */
@property (nonatomic, retain)     UIColor *labelTextShadowColor;
/** The gap between a tick label and its corresponding tick mark */
@property (nonatomic, retain)     NSNumber *tickGap;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartTickStyle *)style;

@end
