//
//  SChartLegendSymbolDonutSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import "SChartLegendSymbol.h"

@class SChartDonutSeries, SChartDonutSeriesStyle;

/** A symbol designed to represent a slice of a donut series on the legend. 
 
 The symbol takes on the style of the particular series to provide custom styling.*/
@interface SChartLegendSymbolDonutSeries : SChartLegendSymbol {
    SChartDonutSeries *series;
    SChartDonutSeriesStyle *style;
    int sliceIndex;
}

/** The style attributes for the associated series.
 
 This set of the style properties enables the symbol to be customised. */
@property (nonatomic, retain) SChartDonutSeriesStyle *style;

/** @name Initialisation */
/** Create a symbol to represent this slice of a donut series. */
- (id)initWithSeries:(SChartDonutSeries *)donutSeries andSliceIndex:(int)index;

@end
