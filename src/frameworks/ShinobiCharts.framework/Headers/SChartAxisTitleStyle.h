//
//  SChartAxisTitleStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    SChartAxisTitleOrientationHorizontal,
    SChartAxisTitleOrientationVertical
} SChartAxisTitleOrientation;

/** The axis title style object controls the look and feel for the axis title.
 
 */
@interface SChartAxisTitleStyle : NSObject

/** @name Styling Properties */
/** The color of the text for the title */
@property (nonatomic, retain)     UIColor         *textColor;
/** The font of the label text */
@property (nonatomic, retain)     UIFont          *font;
/** The minimum font size of the title
 
 This functions in the same way as the UILabel property with the same name */
@property (nonatomic)             CGFloat         minimumFontSize;
@property (nonatomic)             BOOL            minimumFontSizeSet;

/** Text alignment for the title text */
@property (nonatomic)             UITextAlignment textAlign;
@property (nonatomic)             BOOL            textAlignSet;

/** UIColor used for the background of the title */
@property (nonatomic, retain)     UIColor         *backgroundColor;
/** One of the preset orientations for the title
 
 <code>typedef enum {<br>
 SChartAxisTitleOrientationHorizontal,<br>
 SChartAxisTitleOrientationVertical
 } SChartAxisTitleOrientation;</code>
*/
@property (nonatomic)             SChartAxisTitleOrientation titleOrientation;
@property (nonatomic)             BOOL                       titleOrientationSet;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartAxisTitleStyle *)style;

@end
