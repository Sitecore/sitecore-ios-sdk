//
//  SChartCandlestickSeriesStyle.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartOHLCSeriesStyle.h"

@interface SChartCandlestickSeriesStyle : SChartOHLCSeriesStyle
/** @name Styling properties */

/** The color of the candlestick's outline */
@property (nonatomic, retain)       UIColor     *outlineColor;

/** The color of the candlestick's 'high' and 'low' sticks */
@property (nonatomic, retain)       UIColor     *stickColor;

/** The width of the candlestick's stick, in pixels */
@property (nonatomic, retain)       NSNumber    *stickWidth;

/** The width of the candlestick's outline, in pixels */
@property (nonatomic, retain)       NSNumber    *outlineWidth;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartCandlestickSeriesStyle *)style;

@end
