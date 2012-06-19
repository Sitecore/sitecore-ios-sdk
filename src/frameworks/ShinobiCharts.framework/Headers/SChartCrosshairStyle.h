//
//  SChartCrosshairStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** Styling properties for the cross hair object SChartCrosshair
 
 */
@interface SChartCrosshairStyle : NSObject 
/** @name Styling Properties */
/** The width of the lines from the target to the axes */
@property (nonatomic, retain)       NSNumber    *lineWidth;
/** The color of the lines from the target to the axes */
@property (nonatomic, retain)       UIColor     *lineColor;
/** The font of the text in the tooltip */
@property (nonatomic, retain)       UIFont      *defaultFont;
/** The color of the text in the tooltip */
@property (nonatomic, retain)       UIColor     *defaultTextColor;
/** The background color of the labels in the tooltip */
@property (nonatomic, retain)       UIColor     *defaultLabelBackgroundColor;
/** The background color of the tooltip */
@property (nonatomic, retain)       UIColor     *defaultBackgroundColor;
/** The corner radius of the tooltip */
@property (nonatomic, retain)       NSNumber    *defaultCornerRadius;
/** The width of the tooltip border */
@property (nonatomic, retain)       NSNumber    *defaultBorderWidth;
/** The color of the tooltip border */
@property (nonatomic, retain)       UIColor     *defaultBorderColor;
/** The number of key-value pairs displayed on each row of multi-value tooltips. */
@property (nonatomic, retain)       NSNumber    *defaultKeyValuesPerRow;


/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartCrosshairStyle *)style;

@end
