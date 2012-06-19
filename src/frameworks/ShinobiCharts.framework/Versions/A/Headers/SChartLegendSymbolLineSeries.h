//
//  SChartLegendSymbolLineSeries.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import "SChartLegendSymbol.h"

@class SChartLineSeries, SChartLineSeriesStyle;

/** A symbol designed to represent a line series on the legend. 
 
 The symbol takes on the style of the particular series to provide custom styling.*/
@interface SChartLegendSymbolLineSeries : SChartLegendSymbol {
    SChartLineSeriesStyle *style;
}
/** @name Initialisation */
/** Create a symbol to represent this line series */
- (id)initWithSeries:(SChartLineSeries *)series;
/** The style attributes for the associated series.
 
 This readonly set of the style properties enables the symbol to be customised. */
@property (nonatomic, readonly) SChartLineSeriesStyle *style;



@end
