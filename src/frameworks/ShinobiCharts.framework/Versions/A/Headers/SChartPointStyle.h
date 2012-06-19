//
//  SChartPointStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** The style properties for the data points
 
 */
@interface SChartPointStyle : NSObject 

/** @name Styling Properties */
/** Should a symbol be shown at each data point. */
@property (nonatomic, assign)     BOOL showPoints;
@property (nonatomic, assign)     BOOL showPointsSet;
/** The UIColor of the data points */
@property (nonatomic, retain)     UIColor   *color;
/** The UIColor of the data points below the baseline */
@property (nonatomic, retain)     UIColor   *colorBelowBaseline;
/** The radius of the default data point */
@property (nonatomic, retain)     NSNumber  *radius;
/** The gradient of the point - starting from the centre, this describes how rapidly the alpha fades

  `1.0` means that the edge is fully transparent, `0.0` means that the edge has the same alpha as the centre
*/
@property (nonatomic, retain)     NSNumber  *gradient;
/** A PNG image to be used for each data point */
@property (nonatomic, retain)     UIImage   *texture;


/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartPointStyle *)style;

@end
