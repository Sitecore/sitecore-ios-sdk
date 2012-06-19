//
//  SChartLegendSymbolCandlestickSeries.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import "SChartLegendSymbol.h"

@class SChartCandlestickSeries, SChartCandlestickSeriesStyle;

@interface SChartLegendSymbolCandlestickSeries : SChartLegendSymbol {
    SChartCandlestickSeriesStyle *style;
}

/** @name Initialisation */
/** Create a symbol to represent this candlestick series */
- (id)initWithSeries:(SChartCandlestickSeries *)series;
/** The style attributes for the associated series.
 
 This readonly set of the style properties enables the symbol to be customised. */
@property (nonatomic, readonly) SChartCandlestickSeriesStyle *style;

@end
