//
//  SChartBarColumnSeriesStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartSeriesStyle.h"

/** The style object for common bar and column properties.
 
 */
@interface SChartBarColumnSeriesStyle : SChartSeriesStyle 
/** @name Styling Properties */
/** Set to `YES` to fill the area inside the bar/column */
@property (nonatomic)             BOOL showArea;
@property (nonatomic)             BOOL showAreaWasSet;
/** Set to `YES` to fill the area inside the bar/column with a gradient */
@property (nonatomic)             BOOL showAreaWithGradient;
@property (nonatomic)             BOOL showAreaWithGradientWasSet;
/** The fill color of the area inside the bar/column if showArea is `YES` */
@property (nonatomic, retain)     UIColor *areaColor;
/** The second fill color of the area inside the bar/column if showAreaWithGradient is `YES` */
@property (nonatomic, retain)     UIColor *areaColorGradient;
/** The fill color of the area inside the bar/column if showArea is `YES` when the data point is below the baseline */
@property (nonatomic, retain)     UIColor *areaColorBelowBaseline;
/** The second fill color of the area inside the bar/column if showAreaWithGradient is `YES` when the data point is below the baseline */
@property (nonatomic, retain)     UIColor *areaColorGradientBelowBaseline;
/** The UIColor of the outline of the bar/column */
@property (nonatomic, retain)     UIColor *lineColor;
/** The UIColor of the outline of the bar/column when the data point is below the baseline */
@property (nonatomic, retain)     UIColor *lineColorBelowBaseline;
/** The width of the outline of the bar/column */
@property (nonatomic, retain)     NSNumber *lineWidth;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartBarColumnSeriesStyle *)style;

@end
