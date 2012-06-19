//
//  SChartDonutSeriesStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartSeriesStyle.h"

typedef enum SChartRadialChartEffect {
    SChartRadialChartEffectFlat,
    SChartRadialChartEffectBevelled,
    SChartRadialChartEffectBevelledLight,
    SChartRadialChartEffectRounded, 
    SChartRadialChartEffectRoundedLight 
} SChartRadialChartEffect;

/** The styling properties for donut series on the chart.
 
 */
@interface SChartDonutSeriesStyle : SChartSeriesStyle {
    
    BOOL showFlavourSet, showCrustSet, showLabelsSet;
}

/** Whether or not the inside of the donut is filled or 'flavoured'. */
@property (nonatomic)                   BOOL                        showFlavour;

/** Whether or not the outline or 'crust' of the donut is to be shown. */
@property (nonatomic)                   BOOL                        showCrust;

/** Whether or not the 'slices' of the series are annotated with labels. */
@property (nonatomic)                   BOOL                        showLabels;

/** The appearance of the series, either flat, bevelled, or rounded.
 
 typedef enum { <br>
 SChartRadialChartEffectFlat, <br>
 SChartRadialChartEffectBevelled, <br>
 SChartRadialChartEffectBevelledLight, <br>
 SChartRadialChartEffectRounded <br>
 SChartRadialChartEffectRoundedLight <br>
 } SChartRadialChartEffect;
 */
@property (nonatomic)                   SChartRadialChartEffect     chartEffect;

/** An array containing the 'crust' colors of the 'slices' in the series. */
@property (nonatomic, retain)           NSMutableArray              *crustColors;

/** The thickness of the outline or 'crust' */
@property (nonatomic, retain)           NSNumber                    *crustThickness;

/** An array containing the 'flavour' colors of the 'slices' in the series. */
@property (nonatomic, retain)           NSMutableArray              *flavourColors;

/** The rotation of the series in radians. */
@property (nonatomic, retain)           NSNumber                    *initialRotation;

/** The amount by which the slice slides out from the centre
    when selected **/
@property (nonatomic,)                  float                       protrusion;

/** Whether or not the protrusion has been set by the user */
@property (nonatomic)                   BOOL                        protrusionSet;

/** The font used in the labels annotating the series. */
@property (nonatomic, retain)           UIFont                      *labelFont;

/** The font color used in the labels annotating the series. */
@property (nonatomic, retain)           UIColor                     *labelFontColor;

/** The background color of the labels annotating the series. */
@property (nonatomic, retain)           UIColor                     *labelBackgroundColor;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void) supplementStyleFromStyle:(SChartDonutSeriesStyle *)style;

/** Returns the outline or 'crust' color for a 'slice' in the series */
- (UIColor*) crustColorAtIndex:(int)index;

/** Returns the fill or 'flavour' color for a 'slice' in the series */
- (UIColor*) flavourColorAtIndex:(int)index;

@end
