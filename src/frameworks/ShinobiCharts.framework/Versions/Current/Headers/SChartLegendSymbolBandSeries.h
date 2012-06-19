//
//  SChartLegendSymbolBandSeries.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import "SChartLegendSymbol.h"

@class SChartBandSeries, SChartBandSeriesStyle;

/** A symbol designed to represent a band series on the legend. 
 
 The symbol takes on the style of the particular series to provide custom styling.*/
@interface SChartLegendSymbolBandSeries : SChartLegendSymbol {
    SChartBandSeriesStyle *style;
}
/** @name Initialisation */
/** Create a symbol to represent this band series */
- (id)initWithSeries:(SChartBandSeries *)series;
/** The style attributes for the associated series.
 
 This readonly set of the style properties enables the symbol to be customised. */
@property (nonatomic, readonly) SChartBandSeriesStyle *style;



@end
