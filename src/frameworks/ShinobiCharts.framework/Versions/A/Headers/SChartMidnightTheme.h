//
//  SChartMidnightTheme.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

/** The SChartMidnightTheme extends the default theme by changing the color palette to the `midnight` set of colors. This theme is based around a black background and with lighter features. */
@class SChartTheme;

@interface SChartMidnightTheme : SChartTheme {
    
    UIColor *midnight_greyColor, 
            *midnight_greyColorLowAlpha,
            *midnight_greyColorLabel,
            *midnight_blueColorDark,
            *midnight_blueColorLight,
            *midnight_greenColorDark,
            *midnight_greenColorLight,
            *midnight_purpleColorDark,
            *midnight_purpleColorLight,
            *midnight_orangeColorDark,
            *midnight_orangeColorLight,
            *midnight_yellowColorDark,
            *midnight_yellowColorLight,
            *midnight_brownColorDark,
            *midnight_brownColorLight,
            *midnight_pinkColor,
            *midnight_pinkColorLowAlpha,
            *midnight_textShadowColor;
}

/** @name Colors for this theme */
/** Gray palette color */
@property (nonatomic, retain) UIColor *midnight_greyColor; 
/** Gray palette color with reduced alpha */
@property (nonatomic, retain) UIColor *midnight_greyColorLowAlpha;
/** Gray palette color for text labels */
@property (nonatomic, retain) UIColor *midnight_greyColorLabel;
/** Blue palette color */
@property (nonatomic, retain) UIColor *midnight_blueColorDark; 
/** Blue palette color with increased brightness */
@property (nonatomic, retain) UIColor *midnight_blueColorLight;
/** Green palette color */
@property (nonatomic, retain) UIColor *midnight_greenColorDark; 
/** Green palette color with increased brightness */
@property (nonatomic, retain) UIColor *midnight_greenColorLight;
/** Purple palette color */
@property (nonatomic, retain) UIColor *midnight_purpleColorDark; 
/** Purple palette color with increased brightness */
@property (nonatomic, retain) UIColor *midnight_purpleColorLight;
/** Orange palette color */
@property (nonatomic, retain) UIColor *midnight_orangeColorDark; 
/** Orange palette color with increased brightness */
@property (nonatomic, retain) UIColor *midnight_orangeColorLight;
/** Yellow palette color */
@property (nonatomic, retain) UIColor *midnight_yellowColorDark; 
/** Yellow palette color with increased brightness */
@property (nonatomic, retain) UIColor *midnight_yellowColorLight;
/** Brown palette color */
@property (nonatomic, retain) UIColor *midnight_brownColorDark; 
/** Brown palette color with increased brightness */
@property (nonatomic, retain) UIColor *midnight_brownColorLight;
/** Pink palette color */
@property (nonatomic, retain) UIColor *midnight_pinkColor; 
/** Pink palette color with reduced alpha */
@property (nonatomic, retain) UIColor *midnight_pinkColorLowAlpha;
/** Shadow palette color for labels */
@property (nonatomic, retain) UIColor *midnight_textShadowColor;
@end
