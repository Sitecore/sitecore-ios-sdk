//
//  SChartLegendSymbolScatterSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import "SChartLegendSymbol.h"

@class SChartScatterSeries, SChartScatterSeriesStyle;

/** A symbol designed to represent a scatter series on the legend. 
 
 The symbol takes on the style of the particular series to provide custom styling.*/
@interface SChartLegendSymbolScatterSeries : SChartLegendSymbol {
    SChartScatterSeriesStyle *style;
}

/** The style attributes for the associated series.
 
 This readonly set of the style properties enables the symbol to be customised. */
@property (nonatomic, readonly) SChartScatterSeriesStyle *style;

/** @name Initialisation */
/** Create a symbol to represent this scatter series. */
- (id)initWithSeries:(SChartScatterSeries *)series;

@end
