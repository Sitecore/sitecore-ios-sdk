//
//  SChartGridStripeStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** Style properties for the grid stripes that can appear between major tick marks.
 
 */
@interface SChartGridStripeStyle : NSObject 
/** @name Styling Properties */
/** The color of the main stripes between major tick marks */
@property (nonatomic, retain)     UIColor *stripeColor;
/** The color of the alternate stripes between major tick marks */
@property (nonatomic, retain)     UIColor *alternateStripeColor;
/** Should the chart display stripes between the major tick marks. */
@property (nonatomic, assign)     BOOL showGridStripes;
@property (nonatomic, assign)     BOOL showGridStripesSet;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartGridStripeStyle *)style;

@end
