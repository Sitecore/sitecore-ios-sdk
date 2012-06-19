//
//  SChartLegendSymbolColumnSeries.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import "SChartLegendSymbol.h"

@class SChartColumnSeries, SChartColumnSeriesStyle;

/** A symbol designed to represent a column series on the legend. 
 
 The symbol takes on the style of the particular series to provide custom styling.*/
@interface SChartLegendSymbolColumnSeries : SChartLegendSymbol {
    SChartColumnSeriesStyle *style;
}

/** @name Initialisation */
/** Create a symbol to represent this column series */
- (id)initWithSeries:(SChartColumnSeries*)series;

/** The style attributes for the associated series.
 
 This readonly set of the style properties enables the symbol to be customised. */
@property (nonatomic, readonly) SChartColumnSeriesStyle *style;

@end
