//
//  SChartLegendSymbolBarSeries.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import "SChartLegendSymbol.h"

@class SChartBarSeries, SChartBarSeriesStyle;

/** A symbol designed to represent a bar series on the legend. 
 
 The symbol takes on the style of the particular series to provide custom styling.*/
@interface SChartLegendSymbolBarSeries : SChartLegendSymbol  {
    SChartBarSeriesStyle *style;
}

/** @name Initialisation */
/** Create a symbol to represent this bar series */
- (id)initWithSeries:(SChartBarSeries *)series;

/** The style attributes for the associated series.
 
 This readonly set of the style properties enables the symbol to be customised. */
@property (nonatomic, readonly) SChartBarSeriesStyle *style;


@end
