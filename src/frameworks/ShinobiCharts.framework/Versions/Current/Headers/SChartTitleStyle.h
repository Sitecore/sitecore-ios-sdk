//
//  SChartTitleStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** The style properties for the chart title
 
 */
@interface SChartTitleStyle : NSObject 
/** @name Styling Properties */
/** The color of the text for the chart title */
@property (nonatomic, retain)     UIColor         *textColor;
/** The font for the chart title text */
@property (nonatomic, retain)     UIFont          *font;
/** The minimum font size for the chart title text.
 
 Functions in the same way as the UILabel equivalent property.*/
@property (nonatomic)             CGFloat         minimumFontSize;
/** The text alignment of the chart title */
@property (nonatomic)             UITextAlignment textAlign;
/** The background color of the title label */
@property (nonatomic, retain)     UIColor         *backgroundColor;
/** Setting to `YES` will allow the title label to overlap the other chart elements.
 
 If set to `NO` it will reserve its own space */
@property (nonatomic)             BOOL            overlap;

@end
