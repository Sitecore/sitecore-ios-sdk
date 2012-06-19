//
//  SChartLegendSymbolOHLCSeries.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import "SChartLegendSymbol.h"

@class SChartOHLCSeries, SChartOHLCSeriesStyle;

@interface SChartLegendSymbolOHLCSeries : SChartLegendSymbol {
    SChartOHLCSeriesStyle *style;
}

/** @name Initialisation */
/** Create a symbol to represent this OHLC series */
- (id)initWithSeries:(SChartOHLCSeries *)series;
/** The style attributes for the associated series.
 
 This readonly set of the style properties enables the symbol to be customised. */
@property (nonatomic, readonly) SChartOHLCSeriesStyle *style;

@end
