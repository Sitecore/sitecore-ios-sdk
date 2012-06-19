//
//  SChartLegendStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/** Styling for the default legend object SChartLegend
 
 */
@interface SChartLegendStyle : NSObject {
@private
    BOOL showSymbolsSet;
    BOOL symbolAlignmentSet;
    BOOL orientationSet;
}

/** @name Styling Properties */
/** The font used for the series titles */
@property (nonatomic, retain)     UIFont *font;
/** The color of the text used to display the series titles */
@property (nonatomic, retain)     UIColor *fontColor;
/** The font for the legend title */
@property (nonatomic, retain)     UIFont *titleFont;
/** The color for the legend title text */
@property (nonatomic, retain)     UIColor *titleFontColor;
/** The amount of padding in pixels around the inside perimeter of the legend */
@property (nonatomic, retain)     NSNumber *marginWidth;
/** The color of the border line */
@property (nonatomic, retain)     UIColor *borderColor;
/** The radius of the corners on legend view.
 
 Setting a radius of `0` will draw square corners. */
@property (nonatomic, retain)     NSNumber *cornerRadius;
/** Should the legend show symbols next to the series titles */
@property (nonatomic)             BOOL showSymbols;
/** Where should the symbols be drawn if showSymbols is `YES`
 
 <code>typedef enum {<br>
 SChartSeriesLegendAlignSymbolsLeft,<br>
 SChartSeriesLegendAlignSymbolsRight<br>
 } SChartSeriesLegendSymbolAlignment;</code>
 
 */
@property (nonatomic)             SChartSeriesLegendSymbolAlignment symbolAlignment;
/** The layout of the series within the legend
 
 <code>typedef enum {<br>
 SChartLegendOrientationVertical,<br>
 SChartLegendOrientationHorizontal
 } SChartLegendOrientation;</code>
 */
@property (nonatomic)             SChartLegendOrientation orientation;

@property (nonatomic, retain)     UIColor *areaColor;

- (void)supplementStyleFromStyle:(SChartLegendStyle *)style;

@end
